"use strict";
/**
 * One-time seed script: pushes .openclaw workspace data into Firestore.
 *
 * Usage:
 *   npx ts-node src/seed.ts <userId>
 *
 * Requires GOOGLE_APPLICATION_CREDENTIALS or firebase-admin default credentials.
 */
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
const admin = __importStar(require("firebase-admin"));
const fs = __importStar(require("fs"));
const path = __importStar(require("path"));
admin.initializeApp();
const db = admin.firestore();
const OPENCLAW_DIR = path.resolve(__dirname, "../../../.openclaw/workspace");
const WORKOUTS_DIR = path.join(OPENCLAW_DIR, "memory/workouts");
async function seed(userId) {
    const userRef = db.collection("users").doc(userId);
    // 1. Seed agent_config: soul, identity, program
    const configFiles = {
        soul: "SOUL.md",
        identity: "IDENTITY.md",
        program: "PROGRAM.md",
    };
    for (const [docId, fileName] of Object.entries(configFiles)) {
        const filePath = path.join(OPENCLAW_DIR, fileName);
        if (fs.existsSync(filePath)) {
            const content = fs.readFileSync(filePath, "utf-8");
            await userRef.collection("agent_config").doc(docId).set({ content });
            console.log(`✓ agent_config/${docId} seeded from ${fileName}`);
        }
        else {
            console.log(`✗ ${fileName} not found, skipping`);
        }
    }
    // 2. Seed user profile from USER.md
    const userMdPath = path.join(OPENCLAW_DIR, "USER.md");
    if (fs.existsSync(userMdPath)) {
        const userMd = fs.readFileSync(userMdPath, "utf-8");
        const name = userMd.match(/\*\*Name:\*\*\s*(.+)/)?.[1]?.trim() || "";
        const weightMatch = userMd.match(/\*\*Weight:\*\*\s*(\d+)/);
        const heightMatch = userMd.match(/\*\*Height:\*\*.*?(\d+)\s*cm/);
        const level = userMd.match(/\*\*Level:\*\*\s*(.+)/)?.[1]?.trim() || "";
        const goals = userMd.match(/\*\*Goals:\*\*\s*(.+)/)?.[1]?.trim() || "";
        await userRef.set({
            name,
            level,
            goals,
            weight_kg: weightMatch ? Number(weightMatch[1]) : null,
            height_cm: heightMatch ? Number(heightMatch[1]) : null,
        }, { merge: true });
        console.log(`✓ user profile seeded (${name})`);
    }
    // 3. Seed workout logs
    if (fs.existsSync(WORKOUTS_DIR)) {
        const files = fs.readdirSync(WORKOUTS_DIR).filter((f) => /^\d{4}-\d{2}-\d{2}\.json$/.test(f));
        for (const file of files) {
            const date = file.replace(".json", "");
            const data = JSON.parse(fs.readFileSync(path.join(WORKOUTS_DIR, file), "utf-8"));
            await userRef.collection("workout_logs").doc(date).set(data);
            console.log(`✓ workout_logs/${date} seeded`);
        }
    }
    // 4. Seed PRs
    const prsPath = path.join(WORKOUTS_DIR, "prs.json");
    if (fs.existsSync(prsPath)) {
        const prsData = JSON.parse(fs.readFileSync(prsPath, "utf-8"));
        const prs = prsData.prs || prsData;
        for (const [exercise, prData] of Object.entries(prs)) {
            const docId = exercise.toLowerCase().replace(/\s+/g, "_");
            await userRef.collection("prs").doc(docId).set(prData);
            console.log(`✓ prs/${docId} seeded`);
        }
    }
    console.log("\nDone! All .openclaw data seeded into Firestore.");
}
// Get userId from CLI args
const userId = process.argv[2];
if (!userId) {
    console.error("Usage: npx ts-node src/seed.ts <userId>");
    process.exit(1);
}
seed(userId).catch((err) => {
    console.error("Seed failed:", err);
    process.exit(1);
});
//# sourceMappingURL=seed.js.map