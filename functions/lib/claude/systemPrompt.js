"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.assembleSystemPrompt = assembleSystemPrompt;
async function assembleSystemPrompt(db, userId) {
    const agentConfigRef = db
        .collection("users")
        .doc(userId)
        .collection("agent_config");
    const [soulDoc, identityDoc, programDoc] = await Promise.all([
        agentConfigRef.doc("soul").get(),
        agentConfigRef.doc("identity").get(),
        agentConfigRef.doc("program").get(),
    ]);
    const soul = soulDoc.exists ? soulDoc.data()?.content || "" : "";
    const identity = identityDoc.exists ? identityDoc.data()?.content || "" : "";
    const program = programDoc.exists ? programDoc.data()?.content || "" : "";
    // Get user profile for context
    const userDoc = await db.collection("users").doc(userId).get();
    const userData = userDoc.exists ? userDoc.data() : {};
    const userContext = userData
        ? `\n\nUser Profile:\n- Name: ${userData.name || "Unknown"}\n- Level: ${userData.level || "intermediate"}\n- Goals: ${userData.goals || "General fitness"}\n- Weight: ${userData.weight_kg ? userData.weight_kg + "kg" : "Not set"}\n- Height: ${userData.height_cm ? userData.height_cm + "cm" : "Not set"}`
        : "";
    const today = new Date().toISOString().split("T")[0];
    return `${soul}\n\n${identity}\n\n${program}\n\nToday's date: ${today}${userContext}`;
}
//# sourceMappingURL=systemPrompt.js.map