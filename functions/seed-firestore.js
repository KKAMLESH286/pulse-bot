/**
 * Seed script using firebase-tools credentials to write .openclaw data to Firestore.
 * Usage: node seed-firestore.js
 */

const fs = require("fs");
const path = require("path");
const https = require("https");

const PROJECT_ID = "gain-bot-4df1d";
const USER_ID = "xk4Jq5rZn1eM2mYjKjiqCeYvDuh2";
const OPENCLAW_DIR = path.resolve(__dirname, "../../.openclaw/workspace");
const WORKOUTS_DIR = path.join(OPENCLAW_DIR, "memory/workouts");

// Get access token from firebase-tools stored credentials
function getAccessToken() {
  const configPath = path.join(
    require("os").homedir(),
    ".config/configstore/firebase-tools.json"
  );
  const config = JSON.parse(fs.readFileSync(configPath, "utf-8"));
  const refreshToken = config.tokens.refresh_token;

  return new Promise((resolve, reject) => {
    const postData = new URLSearchParams({
      grant_type: "refresh_token",
      refresh_token: refreshToken,
      client_id: "563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com",
      client_secret: "j9iVZfS8kkCEFUPaAeJV0sAi",
    }).toString();

    const req = https.request(
      {
        hostname: "oauth2.googleapis.com",
        path: "/token",
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Content-Length": Buffer.byteLength(postData),
        },
      },
      (res) => {
        let data = "";
        res.on("data", (chunk) => (data += chunk));
        res.on("end", () => {
          const parsed = JSON.parse(data);
          if (parsed.access_token) resolve(parsed.access_token);
          else reject(new Error("Token refresh failed: " + data));
        });
      }
    );
    req.on("error", reject);
    req.write(postData);
    req.end();
  });
}

// Write a Firestore document via REST API
function firestoreSet(accessToken, docPath, fields) {
  const firestoreFields = {};
  for (const [key, value] of Object.entries(fields)) {
    if (value === null || value === undefined) {
      firestoreFields[key] = { nullValue: null };
    } else if (typeof value === "number") {
      if (Number.isInteger(value)) {
        firestoreFields[key] = { integerValue: value.toString() };
      } else {
        firestoreFields[key] = { doubleValue: value };
      }
    } else if (typeof value === "string") {
      firestoreFields[key] = { stringValue: value };
    } else if (typeof value === "boolean") {
      firestoreFields[key] = { booleanValue: value };
    } else if (Array.isArray(value)) {
      firestoreFields[key] = {
        arrayValue: { values: value.map((v) => toFirestoreValue(v)) },
      };
    } else if (typeof value === "object") {
      firestoreFields[key] = {
        mapValue: { fields: toFirestoreFields(value) },
      };
    }
  }

  const body = JSON.stringify({ fields: firestoreFields });

  return new Promise((resolve, reject) => {
    const req = https.request(
      {
        hostname: "firestore.googleapis.com",
        path: `/v1/projects/${PROJECT_ID}/databases/(default)/documents/${docPath}`,
        method: "PATCH",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
          "Content-Length": Buffer.byteLength(body),
        },
      },
      (res) => {
        let data = "";
        res.on("data", (chunk) => (data += chunk));
        res.on("end", () => {
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(JSON.parse(data));
          } else {
            reject(new Error(`Firestore error ${res.statusCode}: ${data}`));
          }
        });
      }
    );
    req.on("error", reject);
    req.write(body);
    req.end();
  });
}

function toFirestoreValue(v) {
  if (v === null || v === undefined) return { nullValue: null };
  if (typeof v === "number")
    return Number.isInteger(v)
      ? { integerValue: v.toString() }
      : { doubleValue: v };
  if (typeof v === "string") return { stringValue: v };
  if (typeof v === "boolean") return { booleanValue: v };
  if (Array.isArray(v))
    return { arrayValue: { values: v.map(toFirestoreValue) } };
  if (typeof v === "object")
    return { mapValue: { fields: toFirestoreFields(v) } };
  return { stringValue: String(v) };
}

function toFirestoreFields(obj) {
  const fields = {};
  for (const [k, v] of Object.entries(obj)) {
    fields[k] = toFirestoreValue(v);
  }
  return fields;
}

async function main() {
  console.log("Getting access token...");
  const token = await getAccessToken();
  console.log("Authenticated.\n");

  const userDocPath = `users/${USER_ID}`;

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
      await firestoreSet(token, `${userDocPath}/agent_config/${docId}`, {
        content,
      });
      console.log(`  ✓ agent_config/${docId} seeded from ${fileName}`);
    } else {
      console.log(`  ✗ ${fileName} not found, skipping`);
    }
  }

  // 2. Seed user profile from USER.md
  const userMdPath = path.join(OPENCLAW_DIR, "USER.md");
  if (fs.existsSync(userMdPath)) {
    const userMd = fs.readFileSync(userMdPath, "utf-8");

    const name = userMd.match(/\*\*Name:\*\*\s*(.+)/)?.[1]?.trim() || "";
    const weightMatch = userMd.match(/\*\*Weight:\*\*\s*(\d+)/);
    const heightMatch = userMd.match(/\*\*Height:\*\*.*?(\d+)\s*cm/);
    const level =
      userMd.match(/\*\*Level:\*\*\s*(.+)/)?.[1]?.trim() || "";
    const goals = userMd.match(/\*\*Goals:\*\*\s*(.+)/)?.[1]?.trim() || "";

    await firestoreSet(token, userDocPath, {
      name,
      level,
      goals,
      weight_kg: weightMatch ? Number(weightMatch[1]) : null,
      height_cm: heightMatch ? Number(heightMatch[1]) : null,
    });
    console.log(`  ✓ user profile seeded (${name})`);
  }

  // 3. Seed workout logs
  if (fs.existsSync(WORKOUTS_DIR)) {
    const files = fs
      .readdirSync(WORKOUTS_DIR)
      .filter((f) => /^\d{4}-\d{2}-\d{2}\.json$/.test(f));
    for (const file of files) {
      const date = file.replace(".json", "");
      const data = JSON.parse(
        fs.readFileSync(path.join(WORKOUTS_DIR, file), "utf-8")
      );
      await firestoreSet(token, `${userDocPath}/workout_logs/${date}`, data);
      console.log(`  ✓ workout_logs/${date} seeded`);
    }
  }

  // 4. Seed PRs
  const prsPath = path.join(WORKOUTS_DIR, "prs.json");
  if (fs.existsSync(prsPath)) {
    const prsData = JSON.parse(fs.readFileSync(prsPath, "utf-8"));
    const prs = prsData.prs || prsData;
    for (const [exercise, prData] of Object.entries(prs)) {
      const docId = exercise.toLowerCase().replace(/\s+/g, "_");
      await firestoreSet(token, `${userDocPath}/prs/${docId}`, prData);
      console.log(`  ✓ prs/${docId} seeded`);
    }
  }

  console.log("\nDone! All .openclaw data seeded into Firestore.");
}

main().catch((err) => {
  console.error("Seed failed:", err);
  process.exit(1);
});
