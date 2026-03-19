import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore } from "firebase-admin/firestore";
import * as admin from "firebase-admin";
import { callClaude, anthropicSetupToken } from "./claude/client";
import { assembleSystemPrompt } from "./claude/systemPrompt";
import { parseWorkoutData } from "./parsers/workoutParser";
import { checkAndUpdatePRs } from "./utils/prChecker";
import { getMessagesRef, getWorkoutsRef } from "./utils/firestore";

/**
 * Legacy Firestore trigger: processes user messages via Claude.
 * This is kept as a fallback while the new `chat` HTTP callable is being tested.
 * Will be removed once the Flutter app is fully migrated to the HTTP callable.
 *
 * Now writes to individual `workouts/{id}` docs instead of `workout_logs/{date}`.
 */
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

    await snap.ref.update({ status: "processing" });

    try {
      const systemPrompt = await assembleSystemPrompt(db, userId);

      const historySnap = await messagesRef
        .orderBy("createdAt")
        .limitToLast(50)
        .get();

      const rawMessages = historySnap.docs
        .map((doc) => {
          const d = doc.data();
          return {
            role: d.role as "user" | "assistant",
            content: (d.text as string) || "",
          };
        })
        .filter((m) => m.content.trim().length > 0);

      const messages: { role: "user" | "assistant"; content: string }[] = [];
      for (const msg of rawMessages) {
        if (messages.length === 0 || messages[messages.length - 1].role !== msg.role) {
          messages.push(msg);
        }
      }

      while (messages.length > 0 && messages[0].role !== "user") {
        messages.shift();
      }

      const response = await callClaude(systemPrompt, messages);
      const workoutData = parseWorkoutData(response);

      // Save as individual workout document (new schema)
      if (workoutData) {
        const today = new Date().toISOString().split("T")[0];
        const targetDate = workoutData.date || today;
        const workoutsRef = getWorkoutsRef(db, userId);

        await workoutsRef.add({
          date: targetDate,
          type: workoutData.type,
          ...(workoutData.day && { day: workoutData.day }),
          exercises: workoutData.exercises,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        await checkAndUpdatePRs(db, userId, workoutData);
      }

      await messagesRef.add({
        role: "assistant",
        text: response,
        workoutData: workoutData || null,
        status: "done",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      await snap.ref.update({ status: "done" });
    } catch (error) {
      console.error("Error processing message:", error);

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
