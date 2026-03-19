import { Firestore } from "firebase-admin/firestore";
import { getPRsRef } from "./firestore";

interface ExerciseSet {
  weight_kg: number;
  reps: number;
}

interface Exercise {
  name: string;
  sets: ExerciseSet[];
  note?: string;
}

interface WorkoutData {
  type: string;
  day?: string;
  date?: string;
  exercises: Exercise[];
}

export async function checkAndUpdatePRs(
  db: Firestore,
  userId: string,
  workoutData: WorkoutData
): Promise<void> {
  const prsRef = getPRsRef(db, userId);

  for (const exercise of workoutData.exercises) {
    // Find the heaviest set for this exercise
    let bestSet: ExerciseSet | null = null;
    for (const set of exercise.sets) {
      if (!bestSet || set.weight_kg > bestSet.weight_kg) {
        bestSet = set;
      } else if (
        set.weight_kg === bestSet.weight_kg &&
        set.reps > bestSet.reps
      ) {
        bestSet = set;
      }
    }

    if (!bestSet || bestSet.weight_kg <= 0) continue;

    // Normalize exercise name for doc ID (lowercase, underscores)
    const exerciseId = exercise.name
      .toLowerCase()
      .replace(/[^a-z0-9]/g, "_")
      .replace(/_+/g, "_")
      .replace(/^_|_$/g, "");

    const prDoc = prsRef.doc(exerciseId);
    const existing = await prDoc.get();

    if (existing.exists) {
      const currentPR = existing.data()!;
      // New PR if heavier weight, or same weight with more reps
      if (
        bestSet.weight_kg > currentPR.weight_kg ||
        (bestSet.weight_kg === currentPR.weight_kg &&
          bestSet.reps > currentPR.reps)
      ) {
        await prDoc.update({
          weight_kg: bestSet.weight_kg,
          reps: bestSet.reps,
          date: workoutData.date ? new Date(workoutData.date) : new Date(),
          note: exercise.note || null,
        });
      }
    } else {
      // First time logging this exercise - it's a PR by default
      await prDoc.set({
        weight_kg: bestSet.weight_kg,
        reps: bestSet.reps,
        date: workoutData.date ? new Date(workoutData.date) : new Date(),
        note: exercise.note || null,
      });
    }
  }
}
