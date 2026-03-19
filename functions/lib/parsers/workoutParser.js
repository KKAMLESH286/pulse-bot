"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.parseWorkoutData = parseWorkoutData;
function parseWorkoutData(response) {
    // Look for ```workout_data ... ``` block in response
    const regex = /```workout_data\s*\n([\s\S]*?)```/;
    const match = response.match(regex);
    if (!match)
        return null;
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
            exercises: parsed.exercises,
        };
    }
    catch {
        console.error("Failed to parse workout data:", match[1]);
        return null;
    }
}
//# sourceMappingURL=workoutParser.js.map