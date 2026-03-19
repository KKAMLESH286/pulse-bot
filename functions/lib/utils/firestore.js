"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMessagesRef = getMessagesRef;
exports.getWorkoutsRef = getWorkoutsRef;
exports.getWorkoutLogsRef = getWorkoutLogsRef;
exports.getPRsRef = getPRsRef;
function getMessagesRef(db, userId) {
    return db.collection("users").doc(userId).collection("messages");
}
function getWorkoutsRef(db, userId) {
    return db.collection("users").doc(userId).collection("workouts");
}
/** @deprecated Use getWorkoutsRef — kept for legacy migration only */
function getWorkoutLogsRef(db, userId) {
    return db.collection("users").doc(userId).collection("workout_logs");
}
function getPRsRef(db, userId) {
    return db.collection("users").doc(userId).collection("prs");
}
//# sourceMappingURL=firestore.js.map