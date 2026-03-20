# CLAUDE.md — Pulse AI (AI-Powered Workout Tracker)

## Project Overview

AI-powered fitness coaching app built with Flutter. Users chat with an AI coach (Claude Sonnet 4.6) that logs workouts, tracks personal records, finds similar past workouts via vector search, sets training programs, and suggests next workouts. All AI processing happens server-side via Firebase Cloud Functions.

- **App Name:** Pulse AI
- **Package:** `com.example.track_me` (Android), `com.example.trackMe` (iOS)
- **Flutter SDK:** ^3.x
- **Dart:** ^3.11.1
- **Firebase Project:** `gain-bot-4df1d`
- **Backend:** Firebase Cloud Functions (TypeScript, Node 20)

## Architecture

### Pattern: Feature-First Clean Architecture with Riverpod

```
┌─────────────────────────────────────────────────────────────┐
│                       FEATURES                               │
│  Each feature has: presentation / domain / data layers      │
│  (Add layers only when complexity demands it)               │
├─────────────────────────────────────────────────────────────┤
│                        CORE                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │ Network  │ │ Firebase │ │ Routing  │ │  Theme   │       │
│  │(Firestore)│ │  (Auth)  │ │(GoRouter)│ │          │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
└─────────────────────────────────────────────────────────────┘
```

**Do NOT add all layers to every feature.** Simple display-only features (e.g., profile) don't need domain/data layers. Add them when the feature has real business logic or data-fetching needs.

### Service Architecture

| Service | Role | Location |
|---|---|---|
| Claude Sonnet 4.6 (Anthropic SDK) | Reasoning, coaching, tool call decisions | Cloud Function (server-side only) |
| Firebase Auth | Identity, JWT, session | Core |
| Firestore | Structured storage + vector field storage | Core + feature datasources |
| Vertex AI `text-embedding-004` | Convert workout text to 768-dim vector | Cloud Function (server-side only) |
| Cloud Functions | Chat proxy (Claude tool loop) + embedding pipeline | `functions/` directory |

### Two Request Paths

**Interactive coach session** (user sends a message):
```
Flutter → CoachNotifier → CoachRemoteDatasource
  → Cloud Function HTTP callable (chat proxy)
      → assemble: [system prompt (soul + identity + program + profile)] + [history from Firestore]
      → rolling summary if >30 messages (via historyManager)
      → Claude Sonnet 4.6 API call with 6 tool schemas
      → if tool_use: execute tool against Firestore or Vertex AI (max 5 iterations)
          → find_similar_workouts: embed query via Vertex → findNearest() Firestore
          → get_workout_history: Firestore structured query
          → log_workout: Firestore write (triggers embedding + PR check)
          → set_program: write markdown to agent_config/program
      → loop until no tool_use blocks
      → persist user message (status: processing → done) + assistant response to Firestore
      → return response to Flutter
```

**Workout saved** (background, not in the chat request path):
```
Firestore write → Cloud Function trigger (onWorkoutCreated)
  → Vertex AI text-embedding-004 (server-side, no API key in app)
  → 768-dim vector written back to same workout document
  → available for findNearest() next time Claude calls find_similar_workouts
```

### The 6 Claude Tools (all execute server-side in Cloud Functions)

```
log_workout           → Firestore write  (+ triggers embedding pipeline + PR check)
get_workout_history   → Firestore query  (structured, filtered, ordered)
find_similar_workouts → Vertex embed query → Firestore findNearest()
suggest_next_workout  → Firestore read history → Claude reasons over it
get_exercise_library  → Firestore static collection query (from PRs)
set_program           → Write markdown training program to agent_config/program
```

### Core Layer

```
core/
├── constants/           # Firestore constants, message status/roles
├── routing/             # GoRouter setup with auth redirects + StatefulShellRoute (5 tabs)
├── theme/               # Dark theme, gradients, colors, typography (Google Fonts)
└── widgets/             # Shared reusable UI components
    ├── scaffold_with_nav.dart       # Bottom nav shell (5 tabs)
    ├── section_header_widget.dart   # Reusable section header
    ├── gradient_icon_widget.dart    # Icon with gradient overlay
    ├── shimmer_loading_widget.dart  # Loading state shimmer
    └── empty_state_widget.dart      # Reusable empty state card
```

### Key Libraries

| Purpose | Package | Notes |
|---|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation` | Riverpod 3.x with codegen. Use `@riverpod` for feature providers, `@Riverpod(keepAlive: true)` for core only. |
| Navigation | `go_router` | Named routes with auth-aware redirects. `StatefulShellRoute` for 5 bottom nav tabs. |
| Firebase | `firebase_core` + `firebase_auth` + `cloud_firestore` + `cloud_functions` | Auth via Google Sign-In. Firestore for all data. Cloud Functions for AI chat proxy. |
| Auth | `google_sign_in` | Google Sign-In with Firebase Auth. |
| Models | `freezed` + `json_serializable` | Use for all state classes and API models. |
| Code generation | `riverpod_generator` + `build_runner` | Run after adding/modifying providers. |
| UI / Styling | `google_fonts` + `flutter_animate` + `shimmer` | Inter + Space Grotesk fonts. Fade/slide animations. Shimmer loading states. |
| Markdown | `flutter_markdown` | Renders training program content from agent_config. |
| Utilities | `intl` + `timeago` | Date formatting and relative timestamps. |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
├── core/
│   ├── constants/
│   │   └── firestore_constants.dart
│   ├── routing/
│   │   ├── app_router.dart              # GoRouter with StatefulShellRoute (5 tabs)
│   │   └── route_names.dart
│   ├── theme/
│   │   └── app_theme.dart               # Dark theme, gradients, Google Fonts
│   └── widgets/
│       ├── scaffold_with_nav.dart       # Bottom nav shell
│       ├── section_header_widget.dart
│       ├── gradient_icon_widget.dart
│       ├── shimmer_loading_widget.dart
│       └── empty_state_widget.dart
└── features/
    ├── auth/
    │   ├── data/services/
    │   │   └── auth_service.dart          # Google Sign-In + new user seed
    │   └── presentation/
    │       ├── providers/auth_provider.dart
    │       └── screens/sign_in_screen.dart
    ├── ai_coach/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── coach_remote_datasource.dart   # Cloud Function callable + Firestore message stream
    │   │   └── models/
    │   │       └── chat_message_model.dart         # Freezed DTO with fromFirestore
    │   └── presentation/
    │       ├── providers/chat_provider.dart        # chatMessages stream, CoachNotifier, isChatProcessing
    │       ├── screens/ai_coach_screen.dart
    │       └── widgets/
    │           ├── chat_input_widget.dart
    │           ├── message_bubble_widget.dart
    │           ├── typing_indicator_widget.dart
    │           └── workout_card_widget.dart
    ├── workout/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── workout_log_model.dart          # WorkoutEntry, Exercise, ExerciseSet (Freezed)
    │   │   └── services/
    │   │       └── workout_service.dart             # Firestore collection refs (read/delete)
    │   └── presentation/
    │       ├── providers/workout_provider.dart       # workoutEntries stream provider
    │       ├── screens/
    │       │   ├── history_screen.dart
    │       │   └── workout_detail_screen.dart
    │       └── widgets/
    │           ├── session_tile_widget.dart
    │           └── exercise_tile_widget.dart
    ├── personal_records/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── personal_record_model.dart       # PersonalRecord (Freezed)
    │   │   └── services/
    │   │       └── pr_service.dart                   # Firestore PR collection refs
    │   └── presentation/
    │       ├── providers/pr_provider.dart            # personalRecords stream provider
    │       └── screens/pr_screen.dart
    ├── program/
    │   └── presentation/
    │       ├── providers/program_provider.dart       # programContent stream provider
    │       └── screens/program_screen.dart           # Markdown renderer for training program
    └── profile/
        ├── data/models/
        │   └── user_profile_model.dart               # UserProfile (Freezed)
        └── presentation/
            ├── providers/user_profile_provider.dart   # userProfile stream provider
            └── screens/profile_screen.dart            # Name, goals, weight, height, level form

functions/                             # Firebase Cloud Functions (TypeScript)
└── src/
    ├── index.ts                       # Exports: chat (HTTP callable), onWorkoutCreated (trigger)
    ├── chat/
    │   ├── chatHandler.ts             # HTTP callable: chat proxy with Claude tool loop (max 5 iterations)
    │   ├── historyManager.ts          # Rolling conversation summary (>30 messages → summarize)
    │   ├── toolExecutor.ts            # Dispatches and executes Claude tool calls
    │   ├── tools.ts                   # 6 Claude tool schema definitions
    │   └── systemPrompt.ts            # Assembles system prompt from soul + identity + program + profile
    ├── embeddings/
    │   ├── embedWorkout.ts            # Firestore trigger: workout → Vertex AI → 768-dim vector
    │   └── vertexClient.ts            # Vertex AI text-embedding-004 REST client
    ├── claude/
    │   └── client.ts                  # Anthropic SDK client + callClaudeWithTools helper
    ├── parsers/
    │   └── workoutParser.ts           # Parse workout data from Claude response
    ├── seed.ts                        # Seed data utility for new users
    └── utils/
        ├── firestore.ts               # Firestore collection/doc reference helpers
        └── prChecker.ts               # PR update logic (weight_kg/reps comparison)
```

## Firestore Schema

```
users/{userId}
  ├── name, email, photoUrl, timezone, level, goals, weight, height, createdAt, updatedAt
  ├── messages/{messageId}
  │   ├── role (user/assistant)
  │   ├── text
  │   ├── workoutData (optional)
  │   ├── status (sent/processing/done/error)
  │   └── createdAt
  ├── workouts/{workoutId}                    # Individual workout documents (not per-date)
  │   ├── date
  │   ├── type (strength/cardio/etc)
  │   ├── day (optional)
  │   ├── exercises: [{name, sets: [{weight_kg, reps}], note}]
  │   ├── embedding: FieldValue.vector(768-dim)  # Written by Cloud Function
  │   └── createdAt
  ├── prs/{exerciseId}
  │   ├── weight_kg, reps, date, note
  └── agent_config/{configId}              # configId: soul, identity, program
      └── content (text)                    # soul = personality, identity = tone, program = markdown training plan
```

**Note:** Workouts are stored as **individual documents** (not grouped by date) to support per-workout vector embeddings and `findNearest()` queries.

## Coding Conventions

### State Management (Riverpod)

- Use `AsyncNotifierProvider` for any provider that fetches data (handles loading/error/data).
- Use `Provider` for computed/derived state.
- Use `StateProvider` only for trivial single-value state.
- Never put API calls directly in screens — always go through a provider → repository → datasource.
- Keep providers scoped to their feature; shared state lives in `core/`.

### Data Layer

- All Firestore calls go through datasource or service classes, never called directly from providers or screens.
- Datasources/services use `cloud_firestore` SDK directly (no Dio — this app uses Firestore, not REST APIs).
- `CoachRemoteDatasource` calls Cloud Function HTTP callable (uses `cloud_functions` package) and streams messages from Firestore.
- Simple features (workout, personal_records) use a service class pattern (`data/services/`) instead of full repository + datasource layers.
- Complex features (ai_coach) use a datasource class pattern (`data/datasources/`).

### Use Cases

- Create a use case only when business logic spans multiple repositories or requires orchestration.
- Example: `SendCoachMessage` (calls coach endpoint → persists turn → may trigger workout save).
- Do NOT create use cases for simple pass-through CRUD operations.

### Navigation

- All route paths defined in `RouteNames` constants.
- Auth redirect logic lives in the router, not in individual screens.
- Protected routes redirect to `/sign-in` when user is not authenticated.
- Use `StatefulShellRoute` for bottom navigation tabs (Chat, History, PRs, Program, Profile).

### Error Handling

- Define sealed failure classes (e.g., `ServerFailure`, `CacheFailure`, `AuthFailure`, `ToolFailure`).
- Catch and map errors at the repository layer.
- Providers expose error state via `AsyncValue.error` or state class error fields.
- Show user-facing errors via SnackBar or dialog — never raw exception messages.

### Models & Serialization

- Use `freezed` for all state and entity classes.
- Use `json_serializable` (via freezed) for API response models.
- Keep DTOs (data layer) separate from entities (domain layer) when they diverge.
- Name model files: `<name>_model.dart` (data), `<name>.dart` (domain entity).
- Firestore models use `fromFirestore()` / `toFirestore()` factory methods.

## Build & Run

```bash
# Install dependencies
flutter pub get

# Run code generation (freezed + riverpod_generator)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run

# Run tests
flutter test

# Deploy Cloud Functions
cd functions && npm run deploy
```

## Environment & Secrets

- **Flutter side:** No API keys needed — all AI calls proxied through Cloud Functions.
- **Cloud Functions secrets:**
  - `ANTHROPIC_SETUP_TOKEN` — OAuth token for Claude API (stored in Secret Manager).
  - GCP default credentials for Vertex AI (implicit in Cloud Functions runtime).
- `.env` files never committed to version control.
- Firebase config files (`google-services.json`, `GoogleService-Info.plist`) are platform-specific and auto-generated.

## Things to Avoid

- Do not call Claude API or Vertex AI from Flutter — all AI processing is server-side via Cloud Functions.
- Do not use BLoC alongside Riverpod — stick with Riverpod only.
- Do not create abstract interfaces for everything — only abstract repositories (for testability).
- Do not add domain/data layers to simple features that are just displaying static UI.
- Do not store sensitive data in SharedPreferences.
- Do not put business logic in widgets or screens — it belongs in providers or use cases.
- Do not create helper/utility classes for one-time operations.
- Do not add error handling for impossible scenarios — trust internal code, validate at boundaries.
- Do not use floating-point for weight values in arithmetic — use `num` from Firestore, display with proper formatting.
- Do not expose raw Anthropic API keys or OAuth tokens in client code.

## Implementation Status

| Feature | Status |
|---|---|
| Clean architecture restructure (feature folders) | Done |
| Freezed models for all entities | Done |
| Auth (Google Sign-In + user seeding) | Done |
| Firestore schema (individual workout docs) | Done |
| Workout CRUD (log via AI, read, delete) | Done |
| Cloud Function: embedding pipeline (Vertex AI trigger) | Done |
| Cloud Function: chat HTTP callable with Claude tool loop (6 tools) | Done |
| Flutter ai_coach wired to chat endpoint | Done |
| All tools: log_workout, get_workout_history, find_similar_workouts, suggest_next_workout, get_exercise_library, set_program | Done |
| Conversation history persistence + rolling summary truncation | Done |
| Personal records auto-tracking | Done |
| Training program (markdown via set_program tool) | Done |
| Profile editing (name, goals, weight, height, level) | Done |
