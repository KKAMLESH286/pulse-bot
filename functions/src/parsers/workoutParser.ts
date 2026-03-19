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

export function parseWorkoutData(response: string): WorkoutData | null {
  // Look for ```workout_data ... ``` block in response
  const regex = /```workout_data\s*\n([\s\S]*?)```/;
  const match = response.match(regex);

  if (!match) return null;

  try {
    const parsed = JSON.parse(match[1].trim());

    // Validate structure
    if (!parsed.exercises || !Array.isArray(parsed.exercises)) {
      return null;
    }

    // Validate each exercise has required fields
    for (const exercise of parsed.exercises) {
      if (!exercise.name || !exercise.sets || !Array.isArray(exercise.sets)) {
        return null;
      }
      for (const set of exercise.sets) {
        if (typeof set.weight_kg !== "number" || typeof set.reps !== "number") {
          return null;
        }
      }
    }

    return {
      type: parsed.type || "strength",
      day: parsed.day,
      date:
        typeof parsed.date === "string" &&
        /^\d{4}-\d{2}-\d{2}$/.test(parsed.date)
          ? parsed.date
          : undefined,
      exercises: parsed.exercises,
    };
  } catch {
    console.error("Failed to parse workout data:", match[1]);
    return null;
  }
}
