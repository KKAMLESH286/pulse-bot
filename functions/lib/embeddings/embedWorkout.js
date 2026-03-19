"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onWorkoutCreated = void 0;
exports.workoutToText = workoutToText;
const firestore_1 = require("firebase-functions/v2/firestore");
const firestore_2 = require("firebase-admin/firestore");
const vertexClient_1 = require("./vertexClient");
/**
 * Build a text representation of a workout for embedding.
 */
function workoutToText(data) {
    const parts = [];
    const type = data.type;
    const day = data.day;
    const date = data.date;
    if (type)
        parts.push(`${type} workout`);
    if (day)
        parts.push(`(${day})`);
    if (date)
        parts.push(`on ${date}`);
    parts.push(":");
    const exercises = data.exercises || [];
    for (const exercise of exercises) {
        const setsStr = exercise.sets
            .map((s) => `${s.weight_kg}kg x ${s.reps}`)
            .join(", ");
        parts.push(`${exercise.name}: ${setsStr}`);
        if (exercise.note)
            parts.push(`(${exercise.note})`);
    }
    const notes = data.notes;
    if (notes)
        parts.push(`Notes: ${notes}`);
    return parts.join(" ");
}
/**
 * Firestore trigger: when a new workout is created in users/{userId}/workouts/{workoutId},
 * generate a 768-dim embedding via Vertex AI and write it back to the document.
 */
exports.onWorkoutCreated = (0, firestore_1.onDocumentCreated)({ document: "users/{userId}/workouts/{workoutId}" }, async (event) => {
    const snap = event.data;
    if (!snap)
        return;
    const data = snap.data();
    // Skip if embedding already exists (avoid infinite loop)
    if (data.embedding)
        return;
    const text = workoutToText(data);
    try {
        const vector = await (0, vertexClient_1.embedText)(text);
        await snap.ref.update({
            embedding: firestore_2.FieldValue.vector(vector),
        });
        console.log(`Embedded workout ${event.params.workoutId} for user ${event.params.userId} (${vector.length} dims)`);
    }
    catch (error) {
        console.error(`Failed to embed workout ${event.params.workoutId}:`, error);
    }
});
//# sourceMappingURL=embedWorkout.js.map