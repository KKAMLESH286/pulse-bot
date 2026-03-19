import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { FieldValue } from "firebase-admin/firestore";
import { embedText } from "./vertexClient";

interface ExerciseSet {
  weight_kg: number;
  reps: number;
}

interface Exercise {
  name: string;
  sets: ExerciseSet[];
  note?: string;
}

/**
 * Build a text representation of a workout for embedding.
 */
export function workoutToText(data: Record<string, unknown>): string {
  const parts: string[] = [];

  const type = data.type as string | undefined;
  const day = data.day as string | undefined;
  const date = data.date as string | undefined;

  if (type) parts.push(`${type} workout`);
  if (day) parts.push(`(${day})`);
  if (date) parts.push(`on ${date}`);
  parts.push(":");

  const exercises = (data.exercises as Exercise[]) || [];
  for (const exercise of exercises) {
    const setsStr = exercise.sets
      .map((s) => `${s.weight_kg}kg x ${s.reps}`)
      .join(", ");
    parts.push(`${exercise.name}: ${setsStr}`);
    if (exercise.note) parts.push(`(${exercise.note})`);
  }

  const notes = data.notes as string | undefined;
  if (notes) parts.push(`Notes: ${notes}`);

  return parts.join(" ");
}

/**
 * Firestore trigger: when a new workout is created in users/{userId}/workouts/{workoutId},
 * generate a 768-dim embedding via Vertex AI and write it back to the document.
 */
export const onWorkoutCreated = onDocumentCreated(
  {
    document: "users/{userId}/workouts/{workoutId}",
    memory: "512MiB",
  },
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();

    // Skip if embedding already exists (avoid infinite loop)
    if (data.embedding) return;

    const text = workoutToText(data);

    try {
      const vector = await embedText(text);

      await snap.ref.update({
        embedding: FieldValue.vector(vector),
      });

      console.log(
        `Embedded workout ${event.params.workoutId} for user ${event.params.userId} (${vector.length} dims)`
      );
    } catch (error) {
      console.error(
        `Failed to embed workout ${event.params.workoutId}:`,
        error
      );
    }
  }
);
