"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.onMessageCreated = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const params_1 = require("firebase-functions/params");
const firestore_2 = require("firebase-admin/firestore");
const admin = __importStar(require("firebase-admin"));
const client_1 = require("./claude/client");
const systemPrompt_1 = require("./claude/systemPrompt");
const workoutParser_1 = require("./parsers/workoutParser");
const prChecker_1 = require("./utils/prChecker");
const firestore_3 = require("./utils/firestore");
admin.initializeApp();
const anthropicSetupToken = (0, params_1.defineSecret)("ANTHROPIC_SETUP_TOKEN");
exports.onMessageCreated = (0, firestore_1.onDocumentCreated)({ document: "users/{userId}/messages/{messageId}", secrets: [anthropicSetupToken] }, async (event) => {
    const snap = event.data;
    if (!snap)
        return;
    const data = snap.data();
    if (data.role !== "user")
        return;
    const { userId } = event.params;
    const db = (0, firestore_2.getFirestore)();
    const messagesRef = (0, firestore_3.getMessagesRef)(db, userId);
    // Set status to processing
    await snap.ref.update({ status: "processing" });
    try {
        // Get agent config
        const systemPrompt = await (0, systemPrompt_1.assembleSystemPrompt)(db, userId);
        // Get conversation history (last 50 messages)
        const historySnap = await messagesRef
            .orderBy("createdAt")
            .limitToLast(50)
            .get();
        // Filter out messages with empty content and ensure alternating roles
        const rawMessages = historySnap.docs
            .map((doc) => {
            const d = doc.data();
            return {
                role: d.role,
                content: d.text || "",
            };
        })
            .filter((m) => m.content.trim().length > 0);
        // Ensure messages alternate roles (Claude API requirement)
        const messages = [];
        for (const msg of rawMessages) {
            if (messages.length === 0 || messages[messages.length - 1].role !== msg.role) {
                messages.push(msg);
            }
        }
        // Ensure first message is from user
        while (messages.length > 0 && messages[0].role !== "user") {
            messages.shift();
        }
        // Call Claude
        const response = await (0, client_1.callClaude)(systemPrompt, messages);
        // Parse workout data from response
        const workoutData = (0, workoutParser_1.parseWorkoutData)(response);
        // If workout data found, save to workout_logs and check PRs
        if (workoutData) {
            const today = new Date().toISOString().split("T")[0];
            const workoutLogsRef = (0, firestore_3.getWorkoutLogsRef)(db, userId);
            const todayDoc = workoutLogsRef.doc(today);
            const existing = await todayDoc.get();
            if (existing.exists) {
                // Append to existing day's workouts
                const existingData = existing.data();
                const workouts = existingData.workouts || [];
                workouts.push(workoutData);
                await todayDoc.update({ workouts });
            }
            else {
                await todayDoc.set({
                    date: today,
                    workouts: [workoutData],
                });
            }
            // Check and update PRs
            await (0, prChecker_1.checkAndUpdatePRs)(db, userId, workoutData);
        }
        // Write assistant message
        await messagesRef.add({
            role: "assistant",
            text: response,
            workoutData: workoutData || null,
            status: "done",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        // Mark original message as done
        await snap.ref.update({ status: "done" });
    }
    catch (error) {
        console.error("Error processing message:", error);
        // Write error response
        await messagesRef.add({
            role: "assistant",
            text: "Sorry, I had trouble processing that. Please try again.",
            status: "error",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        await snap.ref.update({ status: "error" });
    }
});
//# sourceMappingURL=onMessageCreated.js.map