"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.executeTool = executeTool;
const firestore_1 = require("firebase-admin/firestore");
const firestore_2 = require("../utils/firestore");
const prChecker_1 = require("../utils/prChecker");
const vertexClient_1 = require("../embeddings/vertexClient");
/**
 * Execute a Claude tool call and return the result.
 */
async function executeTool(db, userId, toolName, toolInput) {
    try {
        switch (toolName) {
            case "get_workout_history":
                return await handleGetWorkoutHistory(db, userId, toolInput);
            case "log_workout":
                return await handleLogWorkout(db, userId, toolInput);
            case "find_similar_workouts":
                return await handleFindSimilarWorkouts(db, userId, toolInput);
            case "suggest_next_workout":
                return await handleSuggestNextWorkout(db, userId, toolInput);
            case "get_exercise_library":
                return await handleGetExerciseLibrary(db, userId, toolInput);
            case "set_program":
                return await handleSetProgram(db, userId, toolInput);
            default:
                return { content: `Unknown tool: ${toolName}`, is_error: true };
        }
    }
    catch (error) {
        console.error(`Tool ${toolName} failed:`, error);
        return {
            content: `Tool execution failed: ${error instanceof Error ? error.message : String(error)}`,
            is_error: true,
        };
    }
}
// ─── get_workout_history ────────────────────────────────────────────
async function handleGetWorkoutHistory(db, userId, input) {
    const limit = input.limit || 10;
    const exerciseFilter = input.exercise_name;
    const workoutsRef = (0, firestore_2.getWorkoutsRef)(db, userId);
    const query = workoutsRef.orderBy("date", "desc").limit(limit);
    const snap = await query.get();
    if (snap.empty) {
        return { content: "No workouts found." };
    }
    const workouts = snap.docs.map((doc) => {
        const data = doc.data();
        return {
            id: doc.id,
            date: data.date,
            type: data.type,
            day: data.day,
            exercises: data.exercises,
            notes: data.notes,
        };
    });
    // Client-side filter by exercise name if specified
    const filtered = exerciseFilter
        ? workouts.filter((w) => w.exercises?.some((e) => e.name.toLowerCase().includes(exerciseFilter.toLowerCase())))
        : workouts;
    return {
        content: JSON.stringify(filtered, null, 2),
    };
}
// ─── log_workout ────────────────────────────────────────────────────
async function handleLogWorkout(db, userId, input) {
    const today = new Date().toISOString().split("T")[0];
    const date = input.date || today;
    const type = input.type || "strength";
    const day = input.day;
    const exercises = input.exercises;
    const notes = input.notes;
    if (!exercises || exercises.length === 0) {
        return { content: "No exercises provided.", is_error: true };
    }
    const workoutsRef = (0, firestore_2.getWorkoutsRef)(db, userId);
    const workoutData = {
        date,
        type,
        ...(day && { day }),
        exercises: exercises.map((e) => ({
            name: e.name,
            sets: e.sets.map((s) => ({
                weight_kg: s.weight_kg,
                reps: s.reps,
            })),
            ...(e.note && { note: e.note }),
        })),
        ...(notes && { notes }),
        createdAt: firestore_1.FieldValue.serverTimestamp(),
    };
    const docRef = await workoutsRef.add(workoutData);
    // Check and update PRs
    await (0, prChecker_1.checkAndUpdatePRs)(db, userId, {
        type,
        day,
        date,
        exercises,
    });
    const exerciseNames = exercises.map((e) => e.name).join(", ");
    const totalSets = exercises.reduce((acc, e) => acc + e.sets.length, 0);
    return {
        content: `Workout logged successfully (ID: ${docRef.id}). Date: ${date}, ${exercises.length} exercises (${exerciseNames}), ${totalSets} total sets.`,
    };
}
// ─── find_similar_workouts ──────────────────────────────────────────
async function handleFindSimilarWorkouts(db, userId, input) {
    const query = input.query;
    const limit = input.limit || 5;
    if (!query || query.trim().length === 0) {
        return { content: "Query text is required.", is_error: true };
    }
    // Embed the query text via Vertex AI
    const queryVector = await (0, vertexClient_1.embedText)(query);
    // Use Firestore findNearest() for vector search
    const workoutsRef = (0, firestore_2.getWorkoutsRef)(db, userId);
    const vectorQuery = workoutsRef.findNearest({
        vectorField: "embedding",
        queryVector: firestore_1.FieldValue.vector(queryVector),
        limit,
        distanceMeasure: "COSINE",
    });
    const snap = await vectorQuery.get();
    if (snap.empty) {
        return {
            content: "No similar workouts found. The user may not have enough workout history with embeddings yet.",
        };
    }
    const results = snap.docs.map((doc) => {
        const data = doc.data();
        return {
            id: doc.id,
            date: data.date,
            type: data.type,
            day: data.day,
            exercises: data.exercises,
            notes: data.notes,
        };
    });
    return {
        content: JSON.stringify(results, null, 2),
    };
}
// ─── suggest_next_workout ───────────────────────────────────────────
async function handleSuggestNextWorkout(db, userId, input) {
    const daysLookback = input.days_lookback || 14;
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysLookback);
    const cutoffStr = cutoffDate.toISOString().split("T")[0];
    const workoutsRef = (0, firestore_2.getWorkoutsRef)(db, userId);
    const snap = await workoutsRef
        .where("date", ">=", cutoffStr)
        .orderBy("date", "desc")
        .get();
    if (snap.empty) {
        return {
            content: `No workouts found in the last ${daysLookback} days. The user hasn't been training recently.`,
        };
    }
    const recentWorkouts = snap.docs.map((doc) => {
        const data = doc.data();
        return {
            date: data.date,
            type: data.type,
            day: data.day,
            exercises: data.exercises?.map((e) => e.name),
        };
    });
    // Build a summary for Claude to reason over
    const summary = {
        total_workouts: recentWorkouts.length,
        lookback_days: daysLookback,
        workouts: recentWorkouts,
        muscle_groups_trained: extractMuscleGroups(recentWorkouts),
    };
    return {
        content: JSON.stringify(summary, null, 2),
    };
}
/**
 * Simple heuristic to categorize exercises into muscle groups.
 */
function extractMuscleGroups(workouts) {
    const groups = {};
    const mappings = {
        bench: "chest",
        chest: "chest",
        fly: "chest",
        "push up": "chest",
        squat: "legs",
        leg: "legs",
        lunge: "legs",
        deadlift: "legs",
        "leg press": "legs",
        calf: "legs",
        row: "back",
        "pull up": "back",
        pullup: "back",
        "lat pulldown": "back",
        back: "back",
        shoulder: "shoulders",
        "overhead press": "shoulders",
        lateral: "shoulders",
        curl: "biceps",
        bicep: "biceps",
        tricep: "triceps",
        pushdown: "triceps",
        extension: "triceps",
        crunch: "core",
        plank: "core",
        ab: "core",
    };
    for (const workout of workouts) {
        for (const exercise of workout.exercises || []) {
            const lower = exercise.toLowerCase();
            for (const [keyword, group] of Object.entries(mappings)) {
                if (lower.includes(keyword)) {
                    groups[group] = (groups[group] || 0) + 1;
                    break;
                }
            }
        }
    }
    return groups;
}
// ─── set_program ────────────────────────────────────────────────────
async function handleSetProgram(db, userId, input) {
    const content = input.content;
    if (!content || content.trim().length === 0) {
        return { content: "Program content is required.", is_error: true };
    }
    await db
        .collection("users")
        .doc(userId)
        .collection("agent_config")
        .doc("program")
        .set({ content: content.trim() }, { merge: false });
    return {
        content: "Training program updated successfully.",
    };
}
// ─── get_exercise_library ───────────────────────────────────────────
async function handleGetExerciseLibrary(db, userId, input) {
    const muscleGroupFilter = input.muscle_group;
    // Get all PRs (each PR doc = one exercise the user has done)
    const prsRef = (0, firestore_2.getPRsRef)(db, userId);
    const snap = await prsRef.get();
    if (snap.empty) {
        return { content: "No exercises found. The user hasn't logged any workouts yet." };
    }
    const exercises = snap.docs.map((doc) => {
        const data = doc.data();
        return {
            name: doc.id.replace(/_/g, " "),
            best_weight_kg: data.weight_kg,
            best_reps: data.reps,
            pr_date: data.date?.toDate?.()
                ? data.date.toDate().toISOString().split("T")[0]
                : undefined,
            note: data.note,
        };
    });
    // Filter by muscle group keyword if provided
    const filtered = muscleGroupFilter
        ? exercises.filter((e) => e.name.toLowerCase().includes(muscleGroupFilter.toLowerCase()))
        : exercises;
    return {
        content: JSON.stringify({
            total_exercises: filtered.length,
            exercises: filtered,
        }, null, 2),
    };
}
//# sourceMappingURL=toolExecutor.js.map