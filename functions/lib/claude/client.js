"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.anthropicSetupToken = void 0;
exports.callClaudeWithTools = callClaudeWithTools;
exports.callClaude = callClaude;
const sdk_1 = __importDefault(require("@anthropic-ai/sdk"));
const params_1 = require("firebase-functions/params");
exports.anthropicSetupToken = (0, params_1.defineSecret)("ANTHROPIC_SETUP_TOKEN");
function createClient() {
    const token = exports.anthropicSetupToken.value();
    return new sdk_1.default({
        apiKey: null,
        authToken: token,
        defaultHeaders: {
            "anthropic-beta": "claude-code-20250219,oauth-2025-04-20,fine-grained-tool-streaming-2025-05-14,interleaved-thinking-2025-05-14",
            "user-agent": "claude-cli/2.1.75",
            "x-app": "cli",
        },
    });
}
/**
 * Call Claude with tools. Returns the full response (may contain tool_use blocks).
 */
async function callClaudeWithTools(systemPrompt, messages, tools) {
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
async function callClaude(systemPrompt, messages) {
    const response = await callClaudeWithTools(systemPrompt, messages, []);
    const textBlock = response.content.find((block) => block.type === "text");
    return textBlock ? textBlock.text : "I couldn't generate a response.";
}
//# sourceMappingURL=client.js.map