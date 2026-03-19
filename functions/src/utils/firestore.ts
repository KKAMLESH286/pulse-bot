import { Firestore, CollectionReference } from "firebase-admin/firestore";

export function getMessagesRef(
  db: Firestore,
  userId: string
): CollectionReference {
  return db.collection("users").doc(userId).collection("messages");
}

export function getWorkoutLogsRef(
  db: Firestore,
  userId: string
): CollectionReference {
  return db.collection("users").doc(userId).collection("workout_logs");
}

export function getPRsRef(
  db: Firestore,
  userId: string
): CollectionReference {
  return db.collection("users").doc(userId).collection("prs");
}
