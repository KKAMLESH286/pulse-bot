"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.embedText = embedText;
const aiplatform_1 = require("@google-cloud/aiplatform");
const PROJECT_ID = "gain-bot-4df1d";
const LOCATION = "us-central1";
const MODEL_ID = "text-embedding-004";
const ENDPOINT = `projects/${PROJECT_ID}/locations/${LOCATION}/publishers/google/models/${MODEL_ID}`;
let predictionClient = null;
function getPredictionClient() {
    if (!predictionClient) {
        predictionClient = new aiplatform_1.PredictionServiceClient({
            apiEndpoint: `${LOCATION}-aiplatform.googleapis.com`,
        });
    }
    return predictionClient;
}
/**
 * Call Vertex AI text-embedding-004 to generate a 768-dim vector.
 */
async function embedText(text) {
    const client = getPredictionClient();
    const instance = aiplatform_1.helpers.toValue({ content: text });
    const parameters = aiplatform_1.helpers.toValue({
        outputDimensionality: 768,
    });
    const [response] = await client.predict({
        endpoint: ENDPOINT,
        instances: [instance],
        parameters,
    });
    const prediction = response.predictions?.[0];
    if (!prediction) {
        throw new Error("No prediction returned from Vertex AI");
    }
    const embeddings = prediction
        ?.structValue?.fields?.embeddings?.structValue?.fields?.values?.listValue?.values;
    if (!embeddings) {
        throw new Error("Could not extract embedding values from response");
    }
    return embeddings.map((v) => v.numberValue ?? 0);
}
//# sourceMappingURL=vertexClient.js.map