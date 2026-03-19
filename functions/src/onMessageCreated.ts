import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { defineSecret } from "firebase-functions/params";
import { getFirestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import { callClaude } from "./claude/client";
import { assembleSystemPrompt } from "./claude/systemPrompt";
import { parseWorkoutData } from "./parsers/workoutParser";
import { checkAndUpdatePRs } from "./utils/prChecker";
import { getMessagesRef, getWorkoutLogsRef } from "./utils/firestore";

admin.initializeApp();

const anthropicSetupToken = defineSecret("ANTHROPIC_SETUP_TOKEN");

export const onMessageCreated = onDocumentCreated(
  { document: "users/{userId}/messages/{messageId}", secrets: [anthropicSetupToken] },
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();
    if (data.role !== "user") return;

    const { userId } = event.params;
    const db = getFirestore();
    const messagesRef = getMessagesRef(db, userId);

    // Set status to processing
    await snap.ref.update({ status: "processing" });

    try {
      // Get agent config
      const systemPrompt = await assembleSystemPrompt(db, userId);

      // Get conversation history (last 50 messages)
      const historySnap = await messagesRef
        .orderBy("createdAt")
        .limitToLast(50)
        .get();

      // Filter out messages with empty content and ensure alternating roles
      const rawMessages = historySnap.docs
        .map((doc) => {
          const d = doc.data();
          return {
            role: d.role as "user" | "assistant",
            content: (d.text as string) || "",
          };
        })
        .filter((m) => m.content.trim().length > 0);

      // Ensure messages alternate roles (Claude API requirement)
      const messages: { role: "user" | "assistant"; content: string }[] = [];
      for (const msg of rawMessages) {
        if (messages.length === 0 || messages[messages.length - 1].role !== msg.role) {
          messages.push(msg);
        }
      }

      // Ensure first message is from user
      while (messages.length > 0 && messages[0].role !== "user") {
        messages.shift();
      }

      // Call Claude
      const response = await callClaude(systemPrompt, messages);

      // Parse workout data from response
      const workoutData = parseWorkoutData(response);

      // If workout data found, save to workout_logs and check PRs
      if (workoutData) {
        const today = new Date().toISOString().split("T")[0];
        const targetDate = workoutData.date || today;
        const workoutLogsRef = getWorkoutLogsRef(db, userId);
        const targetDoc = workoutLogsRef.doc(targetDate);
        const existing = await targetDoc.get();

        if (existing.exists) {
          // Append to existing day's workouts
          const existingData = existing.data()!;
          const workouts = existingData.workouts || [];
          workouts.push(workoutData);
          await targetDoc.update({ workouts });
        } else {
          await targetDoc.set({
            date: targetDate,
            workouts: [workoutData],
          });
        }

        // Check and update PRs
        await checkAndUpdatePRs(db, userId, workoutData);
      }

      // Write assistant message
      await messagesRef.add({
        role: "assistant",
        text: response,
        workoutData: workoutData || null,
        status: "done",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Mark original message as done
      await snap.ref.update({ status: "done" });
    } catch (error) {
      console.error("Error processing message:", error);

      // Write error response
      await messagesRef.add({
        role: "assistant",
        text: "Sorry, I had trouble processing that. Please try again.",
        status: "error",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      await snap.ref.update({ status: "error" });
    }
  }
);
