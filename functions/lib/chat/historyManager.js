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
exports.buildConversationHistory = buildConversationHistory;
const admin = __importStar(require("firebase-admin"));
const client_1 = require("../claude/client");
const firestore_1 = require("../utils/firestore");
const RECENT_MESSAGES_LIMIT = 20;
const SUMMARY_TRIGGER_THRESHOLD = 30;
/**
 * Build the message history for Claude, incorporating a rolling summary
 * if the conversation is long enough.
 *
 * Strategy:
 * - If total messages <= SUMMARY_TRIGGER_THRESHOLD: use all messages (no summary)
 * - If total messages > SUMMARY_TRIGGER_THRESHOLD:
 *   1. Check for existing summary in agent_config/conversation_summary
 *   2. If no summary or it's stale, generate one from older messages
 *   3. Return: [summary as first user/assistant pair] + [recent N messages]
 */
async function buildConversationHistory(db, userId) {
    const messagesRef = (0, firestore_1.getMessagesRef)(db, userId);
    // Fetch all messages ordered by time
    const allSnap = await messagesRef.orderBy("createdAt").get();
    const allMessages = allSnap.docs
        .map((doc) => ({
        id: doc.id,
        role: doc.data().role,
        content: doc.data().text || "",
        createdAt: doc.data().createdAt,
    }))
        .filter((m) => m.content.trim().length > 0);
    // If conversation is short, use everything directly
    if (allMessages.length <= SUMMARY_TRIGGER_THRESHOLD) {
        const messages = deduplicateAndAlternate(allMessages.map((m) => ({ role: m.role, content: m.content })));
        return { messages, summaryContext: "" };
    }
    // Conversation is long — check for existing summary
    const summaryRef = db
        .collection("users")
        .doc(userId)
        .collection("agent_config")
        .doc("conversation_summary");
    const summaryDoc = await summaryRef.get();
    let summary = null;
    if (summaryDoc.exists) {
        const data = summaryDoc.data();
        summary = {
            text: data.text,
            messageCount: data.messageCount,
            lastSummarizedAt: data.lastSummarizedAt?.toDate?.() || new Date(0),
        };
    }
    // Determine how many messages to keep as recent context
    const recentMessages = allMessages.slice(-RECENT_MESSAGES_LIMIT);
    const olderMessages = allMessages.slice(0, allMessages.length - RECENT_MESSAGES_LIMIT);
    // Generate or update summary if needed
    const olderCount = olderMessages.length;
    const needsSummaryUpdate = !summary || summary.messageCount < olderCount - 5; // Allow 5 message slack
    if (needsSummaryUpdate && olderCount > 0) {
        summary = await generateSummary(db, userId, olderMessages, summaryRef);
    }
    // Build final message array
    const recent = deduplicateAndAlternate(recentMessages.map((m) => ({ role: m.role, content: m.content })));
    const summaryContext = summary?.text || "";
    return { messages: recent, summaryContext };
}
/**
 * Generate a summary of older messages using Claude.
 */
async function generateSummary(db, userId, olderMessages, summaryRef) {
    // Build a condensed view of older messages for summarization
    const condensed = olderMessages
        .map((m) => `${m.role}: ${m.content}`)
        .join("\n");
    // Use Claude to generate the summary (no tools needed)
    const summaryPrompt = "You are a conversation summarizer. Summarize the following conversation between a user and their AI fitness coach. " +
        "Focus on: key workout details logged, fitness goals discussed, progress noted, and any preferences or patterns mentioned. " +
        "Keep the summary concise (under 500 words) but include specific details like exercises, weights, and dates. " +
        "Output only the summary, no preamble.";
    const summaryMessages = [
        {
            role: "user",
            content: `Summarize this conversation:\n\n${condensed}`,
        },
    ];
    try {
        const response = await (0, client_1.callClaudeWithTools)(summaryPrompt, summaryMessages, []);
        const textBlock = response.content.find((b) => b.type === "text");
        const summaryText = textBlock && "text" in textBlock ? textBlock.text : "";
        const summary = {
            text: summaryText,
            messageCount: olderMessages.length,
            lastSummarizedAt: new Date(),
        };
        // Persist summary to Firestore
        await summaryRef.set({
            text: summaryText,
            messageCount: olderMessages.length,
            lastSummarizedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`Generated conversation summary for user ${userId}: ${olderMessages.length} messages → ${summaryText.length} chars`);
        return summary;
    }
    catch (error) {
        console.error("Failed to generate conversation summary:", error);
        // Return empty summary on failure — conversation will still work with recent messages
        return {
            text: "",
            messageCount: 0,
            lastSummarizedAt: new Date(),
        };
    }
}
/**
 * Ensure messages alternate roles and first message is from user.
 */
function deduplicateAndAlternate(rawMessages) {
    const messages = [];
    for (const msg of rawMessages) {
        if (messages.length === 0 ||
            messages[messages.length - 1].role !== msg.role) {
            messages.push(msg);
        }
    }
    // Ensure first message is from user
    while (messages.length > 0 &&
        messages[0].role !== "user") {
        messages.shift();
    }
    return messages;
}
//# sourceMappingURL=historyManager.js.map