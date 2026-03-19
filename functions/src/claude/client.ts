import Anthropic from "@anthropic-ai/sdk";
import { defineSecret } from "firebase-functions/params";

export const anthropicSetupToken = defineSecret("ANTHROPIC_SETUP_TOKEN");

export type Message = Anthropic.MessageParam;
export type Tool = Anthropic.Tool;
export type ContentBlock = Anthropic.ContentBlock;
export type ToolUseBlock = Anthropic.ToolUseBlock;
export type TextBlock = Anthropic.TextBlock;
export type ToolResultBlockParam = Anthropic.ToolResultBlockParam;

function createClient(): Anthropic {
  const token = anthropicSetupToken.value();

  return new Anthropic({
    apiKey: null,
    authToken: token,
    defaultHeaders: {
      "anthropic-beta":
        "claude-code-20250219,oauth-2025-04-20,fine-grained-tool-streaming-2025-05-14,interleaved-thinking-2025-05-14",
      "user-agent": "claude-cli/2.1.75",
      "x-app": "cli",
    },
  });
}

/**
 * Call Claude with tools. Returns the full response (may contain tool_use blocks).
 */
export async function callClaudeWithTools(
  systemPrompt: string,
  messages: Message[],
  tools: Tool[]
): Promise<Anthropic.Message> {
  const client = createClient();

  return client.messages.create({
    model: "claude-sonnet-4-6",
    max_tokens: 2048,
    system: [
      {
        type: "text",
        text: "You are Claude Code, Anthropic's official CLI for Claude.",
        cache_control: { type: "ephemeral" },
      },
      {
        type: "text",
        text: systemPrompt,
        cache_control: { type: "ephemeral" },
      },
    ],
    messages,
    tools,
  });
}

/**
 * Legacy: Call Claude without tools (simple text response).
 */
export async function callClaude(
  systemPrompt: string,
  messages: { role: "user" | "assistant"; content: string }[]
): Promise<string> {
  const response = await callClaudeWithTools(systemPrompt, messages, []);

  const textBlock = response.content.find(
    (block): block is TextBlock => block.type === "text"
  );
  return textBlock ? textBlock.text : "I couldn't generate a response.";
}
