"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.chat = void 0;
const https_1 = require("firebase-functions/v2/https");
const firestore_1 = require("firebase-admin/firestore");
const admin = __importStar(require("firebase-admin"));
const client_1 = require("../claude/client");
const systemPrompt_1 = require("../claude/systemPrompt");
const firestore_2 = require("../utils/firestore");
const tools_1 = require("./tools");
const toolExecutor_1 = require("./toolExecutor");
const historyManager_1 = require("./historyManager");
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
exports.chat = (0, https_1.onCall)({
    secrets: [client_1.anthropicSetupToken],
    timeoutSeconds: 120,
    memory: "512MiB",
}, async (request) => {
    // Auth check
    if (!request.auth) {
        throw new https_1.HttpsError("unauthenticated", "Must be authenticated");
    }
    const userId = request.auth.uid;
    const userMessage = request.data?.message;
    if (!userMessage || userMessage.trim().length === 0) {
        throw new https_1.HttpsError("invalid-argument", "Message is required");
    }
    const db = (0, firestore_1.getFirestore)();
    const messagesRef = (0, firestore_2.getMessagesRef)(db, userId);
    // 1. Persist user message to Firestore
    const userMsgRef = await messagesRef.add({
        role: "user",
        text: userMessage.trim(),
        status: "processing",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    try {
        // 2. Assemble system prompt
        let systemPrompt = await (0, systemPrompt_1.assembleSystemPrompt)(db, userId);
        // 3. Build conversation history with rolling summary
        const { messages, summaryContext } = await (0, historyManager_1.buildConversationHistory)(db, userId);
        // Inject summary into system prompt if available
        if (summaryContext) {
            systemPrompt += `\n\nConversation Summary (older messages):\n${summaryContext}`;
        }
        // 4. Tool loop: call Claude, execute tools, repeat
        let loopCount = 0;
        let finalText = "";
        while (loopCount < MAX_TOOL_LOOPS) {
            loopCount++;
            const response = await (0, client_1.callClaudeWithTools)(systemPrompt, messages, tools_1.COACH_TOOLS);
            // Extract text blocks
            const textBlocks = response.content.filter((b) => b.type === "text");
            if (textBlocks.length > 0) {
                finalText = textBlocks.map((b) => b.text).join("\n");
            }
            // Check if there are tool_use blocks
            const toolUseBlocks = response.content.filter((b) => b.type === "tool_use");
            if (toolUseBlocks.length === 0 || response.stop_reason === "end_turn") {
                break;
            }
            // Add assistant's response (with tool_use blocks) to messages
            messages.push({
                role: "assistant",
                content: response.content,
            });
            // Execute each tool and build tool_result messages
            const toolResults = [];
            for (const toolUse of toolUseBlocks) {
                console.log(`Executing tool: ${toolUse.name}`, toolUse.input);
                const result = await (0, toolExecutor_1.executeTool)(db, userId, toolUse.name, toolUse.input);
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
    }
    catch (error) {
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
        throw new https_1.HttpsError("internal", "Failed to process message");
    }
});
//# sourceMappingURL=chatHandler.js.map