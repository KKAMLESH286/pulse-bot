import { PredictionServiceClient, helpers } from "@google-cloud/aiplatform";

const PROJECT_ID = "gain-bot-4df1d";
const LOCATION = "us-central1";
const MODEL_ID = "text-embedding-004";
const ENDPOINT = `projects/${PROJECT_ID}/locations/${LOCATION}/publishers/google/models/${MODEL_ID}`;

let predictionClient: PredictionServiceClient | null = null;

function getPredictionClient(): PredictionServiceClient {
  if (!predictionClient) {
    predictionClient = new PredictionServiceClient({
      apiEndpoint: `${LOCATION}-aiplatform.googleapis.com`,
    });
  }
  return predictionClient;
}

/**
 * Call Vertex AI text-embedding-004 to generate a 768-dim vector.
 */
export async function embedText(text: string): Promise<number[]> {
  const client = getPredictionClient();

  const instance = helpers.toValue({ content: text }) as protobuf.common.IValue;
  const parameters = helpers.toValue({
    outputDimensionality: 768,
  }) as protobuf.common.IValue;

  const [response] = await client.predict({
    endpoint: ENDPOINT,
    instances: [instance],
    parameters,
  });

  const prediction = response.predictions?.[0];
  if (!prediction) {
    throw new Error("No prediction returned from Vertex AI");
  }

  const embeddings = (prediction as { structValue?: { fields?: { embeddings?: { structValue?: { fields?: { values?: { listValue?: { values?: Array<{ numberValue?: number | null }> } } } } } } } })
    ?.structValue?.fields?.embeddings?.structValue?.fields?.values?.listValue?.values;

  if (!embeddings) {
    throw new Error("Could not extract embedding values from response");
  }

  return embeddings.map((v) => v.numberValue ?? 0);
}
