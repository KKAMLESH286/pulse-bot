"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.callClaude = callClaude;
const sdk_1 = __importDefault(require("@anthropic-ai/sdk"));
const params_1 = require("firebase-functions/params");
const anthropicSetupToken = (0, params_1.defineSecret)("ANTHROPIC_SETUP_TOKEN");
async function callClaude(systemPrompt, messages) {
    const token = anthropicSetupToken.value();
    // OAuth setup tokens require Claude Code identity headers
    // See: pi-ai v0.58.0 providers/anthropic.js createClient()
    const client = new sdk_1.default({
        apiKey: null,
        authToken: token,
        defaultHeaders: {
            "anthropic-beta": "claude-code-20250219,oauth-2025-04-20,fine-grained-tool-streaming-2025-05-14,interleaved-thinking-2025-05-14",
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
//# sourceMappingURL=client.js.map