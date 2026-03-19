import Anthropic from "@anthropic-ai/sdk";
import { defineSecret } from "firebase-functions/params";

const anthropicSetupToken = defineSecret("ANTHROPIC_SETUP_TOKEN");

interface Message {
  role: "user" | "assistant";
  content: string;
}

export async function callClaude(
  systemPrompt: string,
  messages: Message[]
): Promise<string> {
  const token = anthropicSetupToken.value();

  // OAuth setup tokens require Claude Code identity headers
  // See: pi-ai v0.58.0 providers/anthropic.js createClient()
  const client = new Anthropic({
    apiKey: null,
    authToken: token,
    defaultHeaders: {
      "anthropic-beta":
        "claude-code-20250219,oauth-2025-04-20,fine-grained-tool-streaming-2025-05-14,interleaved-thinking-2025-05-14",
      "user-agent": "claude-cli/2.1.75",
      "x-app": "cli",
    },
  });

  // OAuth tokens require the Claude Code identity as the first system block
  const response = await client.messages.create({
    model: "claude-sonnet-4-6",
    max_tokens: 1024,
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
    messages: messages,
  });

  const textBlock = response.content.find((block) => block.type === "text");
  return textBlock ? textBlock.text : "I couldn't generate a response.";
}
