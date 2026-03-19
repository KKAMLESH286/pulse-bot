import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import {
  callClaudeWithTools,
  anthropicSetupToken,
  ToolUseBlock,
  TextBlock,
} from "../claude/client";
import { assembleSystemPrompt } from "../claude/systemPrompt";
import { getMessagesRef } from "../utils/firestore";
import { COACH_TOOLS } from "./tools";
import { executeTool } from "./toolExecutor";
import { buildConversationHistory } from "./historyManager";

const MAX_TOOL_LOOPS = 5;

/**
 * HTTP Callable Cloud Function: chat proxy with Claude tool loop.
 *
 * Flutter calls this instead of writing to Firestore and waiting for a trigger.
 * The function:
 * 1. Persists the user message to Firestore
 * 2. Assembles system prompt + conversation history (with rolling summary)
 * 3. Calls Claude with tool schemas
 * 4. Loops: if Claude returns tool_use, execute the tool and feed result back
 * 5. Returns the final text response to Flutter
 * 6. Persists the assistant response to Firestore
 */
export const chat = onCall(
  {
    secrets: [anthropicSetupToken],
    timeoutSeconds: 120,
    memory: "512MiB",
  },
  async (request) => {
    // Auth check
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "Must be authenticated");
    }

    const userId = request.auth.uid;
    const userMessage = request.data?.message as string | undefined;

    if (!userMessage || userMessage.trim().length === 0) {
      throw new HttpsError("invalid-argument", "Message is required");
    }

    const db = getFirestore();
    const messagesRef = getMessagesRef(db, userId);

    // 1. Persist user message to Firestore
    const userMsgRef = await messagesRef.add({
      role: "user",
      text: userMessage.trim(),
      status: "processing",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    try {
      // 2. Assemble system prompt
      let systemPrompt = await assembleSystemPrompt(db, userId);

      // 3. Build conversation history with rolling summary
      const { messages, summaryContext } = await buildConversationHistory(
        db,
        userId
      );

      // Inject summary into system prompt if available
      if (summaryContext) {
        systemPrompt += `\n\nConversation Summary (older messages):\n${summaryContext}`;
      }

      // 4. Tool loop: call Claude, execute tools, repeat
      let loopCount = 0;
      let finalText = "";

      while (loopCount < MAX_TOOL_LOOPS) {
        loopCount++;

        const response = await callClaudeWithTools(
          systemPrompt,
          messages,
          COACH_TOOLS
        );

        // Extract text blocks
        const textBlocks = response.content.filter(
          (b): b is TextBlock => b.type === "text"
        );
        if (textBlocks.length > 0) {
          finalText = textBlocks.map((b) => b.text).join("\n");
        }

        // Check if there are tool_use blocks
        const toolUseBlocks = response.content.filter(
          (b): b is ToolUseBlock => b.type === "tool_use"
        );

        if (toolUseBlocks.length === 0 || response.stop_reason === "end_turn") {
          break;
        }

        // Add assistant's response (with tool_use blocks) to messages
        messages.push({
          role: "assistant",
          content: response.content,
        });

        // Execute each tool and build tool_result messages
        const toolResults: Array<{
          type: "tool_result";
          tool_use_id: string;
          content: string;
          is_error?: boolean;
        }> = [];

        for (const toolUse of toolUseBlocks) {
          console.log(`Executing tool: ${toolUse.name}`, toolUse.input);

          const result = await executeTool(
            db,
            userId,
            toolUse.name,
            toolUse.input as Record<string, unknown>
          );

          toolResults.push({
            type: "tool_result",
            tool_use_id: toolUse.id,
            content: result.content,
            ...(result.is_error && { is_error: true }),
          });
        }

        // Add tool results as user message
        messages.push({
          role: "user",
          content: toolResults,
        });
      }

      if (!finalText) {
        finalText = "I processed your request but couldn't generate a response.";
      }

      // 5. Mark user message as done
      await userMsgRef.update({ status: "done" });

      // 6. Persist assistant response to Firestore
      await messagesRef.add({
        role: "assistant",
        text: finalText,
        status: "done",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // 7. Return response to Flutter
      return {
        text: finalText,
        status: "done",
      };
    } catch (error) {
      console.error("Chat handler error:", error);

      // Mark user message as error
      await userMsgRef.update({ status: "error" });

      // Persist error response
      await messagesRef.add({
        role: "assistant",
        text: "Sorry, I had trouble processing that. Please try again.",
        status: "error",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      throw new HttpsError("internal", "Failed to process message");
    }
  }
);
