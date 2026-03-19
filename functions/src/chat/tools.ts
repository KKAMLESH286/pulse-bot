import { Tool } from "../claude/client";

export const COACH_TOOLS: Tool[] = [
  {
    name: "get_workout_history",
    description:
      "Retrieve the user's workout history from Firestore. " +
      "Returns recent workouts ordered by date descending. " +
      "Use this when the user asks about past workouts, progress, or training patterns.",
    input_schema: {
      type: "object" as const,
      properties: {
        limit: {
          type: "number",
          description:
            "Maximum number of workouts to return. Defaults to 10.",
        },
        exercise_name: {
          type: "string",
          description:
            "Filter by exercise name (case-insensitive substring match). " +
            "If omitted, returns all exercises.",
        },
      },
      required: [],
    },
  },
  {
    name: "log_workout",
    description:
      "Save a structured workout to Firestore. " +
      "Use this when the user describes a workout they did. " +
      "Extract exercises, sets, weights, and reps from their description. " +
      "This triggers the embedding pipeline automatically.",
    input_schema: {
      type: "object" as const,
      properties: {
        date: {
          type: "string",
          description:
            "Workout date in YYYY-MM-DD format. Defaults to today if not specified.",
        },
        type: {
          type: "string",
          description:
            'Workout type: "strength", "cardio", "flexibility", etc. Defaults to "strength".',
        },
        day: {
          type: "string",
          description:
            'Optional training day label, e.g. "Push Day", "Leg Day", "Upper Body".',
        },
        exercises: {
          type: "array",
          items: {
            type: "object",
            properties: {
              name: { type: "string", description: "Exercise name" },
              sets: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    weight_kg: {
                      type: "number",
                      description: "Weight in kilograms",
                    },
                    reps: { type: "number", description: "Number of reps" },
                  },
                  required: ["weight_kg", "reps"],
                },
              },
              note: {
                type: "string",
                description: "Optional note about the exercise",
              },
            },
            required: ["name", "sets"],
          },
          description: "List of exercises performed",
        },
        notes: {
          type: "string",
          description: "Optional general notes about the workout",
        },
      },
      required: ["exercises"],
    },
  },
  {
    name: "find_similar_workouts",
    description:
      "Find workouts similar to a query using vector search. " +
      "Embeds the query text via Vertex AI and uses Firestore findNearest() to find the closest matches. " +
      "Use this when the user asks things like 'have I done a workout like this before?' or " +
      "'find workouts similar to my push day' or 'when did I last do heavy squats?'.",
    input_schema: {
      type: "object" as const,
      properties: {
        query: {
          type: "string",
          description:
            "Natural language description of the workout to search for. " +
            "E.g. 'heavy bench press and triceps' or 'leg day with squats and lunges'.",
        },
        limit: {
          type: "number",
          description:
            "Maximum number of similar workouts to return. Defaults to 5.",
        },
      },
      required: ["query"],
    },
  },
  {
    name: "suggest_next_workout",
    description:
      "Analyze the user's recent workout history and suggest what they should do next. " +
      "Use this when the user asks 'what should I do today?' or 'suggest a workout'. " +
      "The tool retrieves recent history — you then reason over it to make a suggestion.",
    input_schema: {
      type: "object" as const,
      properties: {
        days_lookback: {
          type: "number",
          description:
            "How many days of history to consider. Defaults to 14.",
        },
      },
      required: [],
    },
  },
  {
    name: "get_exercise_library",
    description:
      "Retrieve the list of exercises the user has ever performed, with their best stats. " +
      "Use this when the user asks about their exercise catalog, personal records, or " +
      "wants to see all exercises they've tracked.",
    input_schema: {
      type: "object" as const,
      properties: {
        muscle_group: {
          type: "string",
          description:
            "Optional filter by muscle group keyword (e.g. 'chest', 'legs', 'back'). " +
            "Matches against exercise names.",
        },
      },
      required: [],
    },
  },
  {
    name: "set_program",
    description:
      "Update the user's training program stored in agent_config/program. " +
      "Use this when the user asks to create, change, or modify their workout program " +
      "(e.g. 'switch me to PPL', 'add a rest day', 'create a 12-week plan'). " +
      "The content should be the full updated program in markdown format. " +
      "Always include the complete program — this overwrites the existing one.",
    input_schema: {
      type: "object" as const,
      properties: {
        content: {
          type: "string",
          description:
            "The full training program content in markdown format. " +
            "Include structure, days, exercises, sets, reps, and any notes.",
        },
      },
      required: ["content"],
    },
  },
];
