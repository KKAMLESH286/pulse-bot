"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.embedText = embedText;
const google_auth_library_1 = require("google-auth-library");
const PROJECT_ID = "gain-bot-4df1d";
const LOCATION = "us-central1";
const MODEL_ID = "text-embedding-004";
const ENDPOINT_URL = `https://${LOCATION}-aiplatform.googleapis.com/v1/projects/${PROJECT_ID}/locations/${LOCATION}/publishers/google/models/${MODEL_ID}:predict`;
const auth = new google_auth_library_1.GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
});
/**
 * Call Vertex AI text-embedding-004 to generate a 768-dim vector.
 * Uses REST API directly instead of the heavy @google-cloud/aiplatform SDK.
 */
async function embedText(text) {
    const client = await auth.getClient();
    const token = await client.getAccessToken();
    const response = await fetch(ENDPOINT_URL, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${token.token}`,
            "Content-Type": "application/json",
        },
        body: JSON.stringify({
            instances: [{ content: text }],
            parameters: { outputDimensionality: 768 },
        }),
    });
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Vertex AI API error (${response.status}): ${errorText}`);
    }
    const data = await response.json();
    const values = data?.predictions?.[0]?.embeddings?.values;
    if (!values || !Array.isArray(values)) {
        throw new Error("Could not extract embedding values from Vertex AI response");
    }
    return values;
}
//# sourceMappingURL=vertexClient.js.map