import * as admin from "firebase-admin";

admin.initializeApp();

export { onWorkoutCreated } from "./embeddings/embedWorkout";
export { chat } from "./chat/chatHandler";
