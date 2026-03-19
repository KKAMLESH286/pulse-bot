import { Firestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import { callClaudeWithTools, Message } from "../claude/client";
import { getMessagesRef } from "../utils/firestore";

const RECENT_MESSAGES_LIMIT = 20;
const SUMMARY_TRIGGER_THRESHOLD = 30;

interface ConversationSummary {
  text: string;
  messageCount: number;
  lastSummarizedAt: Date;
}

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
export async function buildConversationHistory(
  db: Firestore,
  userId: string
): Promise<{ messages: Message[]; summaryContext: string }> {
  const messagesRef = getMessagesRef(db, userId);

  // Fetch all messages ordered by time
  const allSnap = await messagesRef.orderBy("createdAt").get();

  const allMessages = allSnap.docs
    .map((doc) => ({
      id: doc.id,
      role: doc.data().role as "user" | "assistant",
      content: (doc.data().text as string) || "",
      createdAt: doc.data().createdAt,
    }))
    .filter((m) => m.content.trim().length > 0);

  // If conversation is short, use everything directly
  if (allMessages.length <= SUMMARY_TRIGGER_THRESHOLD) {
    const messages = deduplicateAndAlternate(
      allMessages.map((m) => ({ role: m.role, content: m.content }))
    );
    return { messages, summaryContext: "" };
  }

  // Conversation is long — check for existing summary
  const summaryRef = db
    .collection("users")
    .doc(userId)
    .collection("agent_config")
    .doc("conversation_summary");

  const summaryDoc = await summaryRef.get();
  let summary: ConversationSummary | null = null;

  if (summaryDoc.exists) {
    const data = summaryDoc.data()!;
    summary = {
      text: data.text as string,
      messageCount: data.messageCount as number,
      lastSummarizedAt: data.lastSummarizedAt?.toDate?.() || new Date(0),
    };
  }

  // Determine how many messages to keep as recent context
  const recentMessages = allMessages.slice(-RECENT_MESSAGES_LIMIT);
  const olderMessages = allMessages.slice(
    0,
    allMessages.length - RECENT_MESSAGES_LIMIT
  );

  // Generate or update summary if needed
  const olderCount = olderMessages.length;
  const needsSummaryUpdate =
    !summary || summary.messageCount < olderCount - 5; // Allow 5 message slack

  if (needsSummaryUpdate && olderCount > 0) {
    summary = await generateSummary(db, userId, olderMessages, summaryRef);
  }

  // Build final message array
  const recent = deduplicateAndAlternate(
    recentMessages.map((m) => ({ role: m.role, content: m.content }))
  );

  const summaryContext = summary?.text || "";

  return { messages: recent, summaryContext };
}

/**
 * Generate a summary of older messages using Claude.
 */
async function generateSummary(
  db: Firestore,
  userId: string,
  olderMessages: Array<{ role: string; content: string }>,
  summaryRef: FirebaseFirestore.DocumentReference
): Promise<ConversationSummary> {
  // Build a condensed view of older messages for summarization
  const condensed = olderMessages
    .map((m) => `${m.role}: ${m.content}`)
    .join("\n");

  // Use Claude to generate the summary (no tools needed)
  const summaryPrompt =
    "You are a conversation summarizer. Summarize the following conversation between a user and their AI fitness coach. " +
    "Focus on: key workout details logged, fitness goals discussed, progress noted, and any preferences or patterns mentioned. " +
    "Keep the summary concise (under 500 words) but include specific details like exercises, weights, and dates. " +
    "Output only the summary, no preamble.";

  const summaryMessages: Message[] = [
    {
      role: "user",
      content: `Summarize this conversation:\n\n${condensed}`,
    },
  ];

  try {
    const response = await callClaudeWithTools(
      summaryPrompt,
      summaryMessages,
      []
    );

    const textBlock = response.content.find((b) => b.type === "text");
    const summaryText = textBlock && "text" in textBlock ? textBlock.text : "";

    const summary: ConversationSummary = {
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

    console.log(
      `Generated conversation summary for user ${userId}: ${olderMessages.length} messages → ${summaryText.length} chars`
    );

    return summary;
  } catch (error) {
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
function deduplicateAndAlternate(
  rawMessages: Array<{ role: string; content: string }>
): Message[] {
  const messages: Message[] = [];
  for (const msg of rawMessages) {
    if (
      messages.length === 0 ||
      (messages[messages.length - 1] as { role: string }).role !== msg.role
    ) {
      messages.push(msg as Message);
    }
  }

  // Ensure first message is from user
  while (
    messages.length > 0 &&
    (messages[0] as { role: string }).role !== "user"
  ) {
    messages.shift();
  }

  return messages;
}
