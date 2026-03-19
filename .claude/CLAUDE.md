# CLAUDE.md — GainBot (AI-Powered Workout Tracker)

## Project Overview

AI-powered fitness coaching app built with Flutter. Users chat with an AI coach (Claude Sonnet) that logs workouts, tracks personal records, finds similar past workouts via vector search, and suggests training programs. All AI processing happens server-side via Firebase Cloud Functions.

- **App Name:** GainBot / Track Me
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
| Claude Sonnet (Anthropic SDK) | Reasoning, coaching, tool call decisions | Cloud Function (server-side only) |
| Firebase Auth | Identity, JWT, session | Core |
| Firestore | Structured storage + vector field storage | Core + feature datasources |
| Vertex AI `text-embedding-004` | Convert workout text to 768-dim vector | Cloud Function (server-side only) |
| Cloud Functions | Chat proxy (Claude tool loop) + embedding pipeline | `functions/` directory |

### Two Request Paths

**Interactive coach session** (user sends a message):
```
Flutter → CoachNotifier → CoachRepository → CoachRemoteDatasource
  → Cloud Function HTTP endpoint (chat proxy)
      → assemble: [system prompt(profile)] + [history from Firestore] + [user message]
      → Claude Sonnet API call with 5 tool schemas
      → if tool_use: execute tool against Firestore or Vertex AI
          → find_similar_workouts: embed query via Vertex → findNearest() Firestore
          → get_workout_history: Firestore structured query
          → log_workout: Firestore write (triggers embedding Cloud Function)
      → loop until no tool_use blocks
      → return response to Flutter
      → persist completed turn to Firestore
```

**Workout saved** (background, not in the chat request path):
```
Firestore write → Cloud Function trigger (onWorkoutCreated)
  → Vertex AI text-embedding-004 (server-side, no API key in app)
  → 768-dim vector written back to same workout document
  → available for findNearest() next time Claude calls find_similar_workouts
```

### The 5 Claude Tools (all execute server-side in Cloud Functions)

```
log_workout           → Firestore write  (+ triggers embedding pipeline)
get_workout_history   → Firestore query  (structured, filtered, ordered)
find_similar_workouts → Vertex embed query → Firestore findNearest()
suggest_next_workout  → Firestore read history → Claude reasons over it
get_exercise_library  → Firestore static collection query
```

### Core Layer

```
core/
├── config/              # AppConfig, environment variables
├── constants/           # Firestore constants, message status/roles
├── routing/             # GoRouter setup with auth redirects
├── errors/              # Typed failures (sealed: Server, Cache, Auth, Tool)
├── theme/               # Shared theme, colors, typography
└── widgets/             # Shared reusable UI components
```

### Key Libraries

| Purpose | Package | Notes |
|---|---|---|
| State management | `flutter_riverpod` + `riverpod_annotation` | Riverpod 3.x with codegen. Use `@riverpod` for feature providers, `@Riverpod(keepAlive: true)` for core only. |
| Navigation | `go_router` | Named routes with auth-aware redirects. `ShellRoute` for bottom nav tabs. |
| Firebase | `firebase_core` + `firebase_auth` + `cloud_firestore` | Auth via Google Sign-In. Firestore for all data. |
| Auth | `google_sign_in` | Google Sign-In with Firebase Auth. |
| Models | `freezed` + `json_serializable` | Use for all state classes and API models. |
| Code generation | `riverpod_generator` + `build_runner` | Run after adding/modifying providers. |
| Utilities | `intl` + `timeago` | Date formatting and relative timestamps. |

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── firebase_options.dart
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   └── firestore_constants.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── errors/
│   │   └── failure.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
└── features/
    ├── auth/
    │   └── presentation/
    │       ├── providers/auth_provider.dart
    │       └── screens/sign_in_screen.dart
    ├── ai_coach/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── coach_remote_datasource.dart   # calls Cloud Function HTTP endpoint
    │   │   ├── models/
    │   │   │   └── chat_message_model.dart         # Freezed DTO
    │   │   └── repositories/
    │   │       └── ai_coach_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/chat_message.dart
    │   │   └── repositories/i_ai_coach_repository.dart
    │   └── presentation/
    │       ├── providers/coach_notifier.dart
    │       ├── screens/ai_coach_screen.dart
    │       └── widgets/
    │           ├── chat_input_widget.dart
    │           ├── message_bubble_widget.dart
    │           ├── typing_indicator_widget.dart
    │           └── workout_card_widget.dart
    ├── workout/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── workout_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── workout_model.dart              # Freezed DTO
    │   │   └── repositories/
    │   │       └── workout_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/workout.dart
    │   │   └── repositories/i_workout_repository.dart
    │   └── presentation/
    │       ├── providers/workout_provider.dart
    │       ├── screens/
    │       │   ├── history_screen.dart
    │       │   └── workout_detail_screen.dart
    │       └── widgets/
    │           ├── session_tile_widget.dart
    │           └── exercise_tile_widget.dart
    ├── personal_records/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── pr_remote_datasource.dart
    │   │   ├── models/
    │   │   │   └── personal_record_model.dart
    │   │   └── repositories/
    │   │       └── pr_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/personal_record.dart
    │   │   └── repositories/i_pr_repository.dart
    │   └── presentation/
    │       ├── providers/pr_provider.dart
    │       └── screens/pr_screen.dart
    └── profile/
        └── presentation/
            ├── providers/user_profile_provider.dart
            └── screens/profile_screen.dart

functions/                             # Firebase Cloud Functions (TypeScript)
└── src/
    ├── index.ts                       # Exports all functions
    ├── chat/
    │   ├── chatHandler.ts             # HTTP callable: chat proxy with Claude tool loop
    │   ├── toolExecutor.ts            # Execute Claude tool calls against Firestore/Vertex
    │   └── systemPrompt.ts            # Dynamic system prompt assembly
    ├── embeddings/
    │   └── embedWorkout.ts            # Firestore trigger: workout → Vertex AI → vector
    ├── claude/
    │   └── client.ts                  # Anthropic SDK client (OAuth token)
    ├── parsers/
    │   └── workoutParser.ts           # Parse workout data from Claude response
    └── utils/
        ├── firestore.ts               # Firestore reference helpers
        └── prChecker.ts               # PR update logic
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
  └── agent_config/{configId}
      └── content (soul, identity, program prompts)
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

- All Firestore calls go through datasource classes, never called directly from providers or screens.
- Datasources use `cloud_firestore` SDK directly (no Dio — this app uses Firestore, not REST APIs).
- Exception: `CoachRemoteDatasource` calls Cloud Function HTTP endpoint (uses `cloud_functions` package or `http`).
- Repository interfaces live in `domain/repositories/`; implementations in `data/repositories/`.

### Use Cases

- Create a use case only when business logic spans multiple repositories or requires orchestration.
- Example: `SendCoachMessage` (calls coach endpoint → persists turn → may trigger workout save).
- Do NOT create use cases for simple pass-through CRUD operations.

### Navigation

- All route paths defined in `RouteNames` constants.
- Auth redirect logic lives in the router, not in individual screens.
- Protected routes redirect to `/sign-in` when user is not authenticated.
- Use `ShellRoute` for bottom navigation tabs (Chat, History, PRs, Profile).

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

## Implementation Phases

| Phase | Focus | Status |
|---|---|---|
| 0 | Restructure to clean architecture (move existing flat code into feature folders) | Next |
| 1 | Add Freezed models, migrate plain classes | Next |
| 2 | Auth + Firestore schema migration (individual workout docs) + Security Rules | Planned |
| 3 | Workout CRUD (log, read, delete) — no AI yet | Planned |
| 4 | Cloud Function: embedding pipeline (Vertex AI trigger on workout write) | Planned |
| 5 | Cloud Function: chat HTTP endpoint with Claude tool loop (`get_workout_history` only) | Planned |
| 6 | Wire Flutter ai_coach feature to new chat endpoint | Planned |
| 7 | Add remaining tools: `find_similar_workouts`, `log_workout`, `suggest_next_workout`, `get_exercise_library` | Planned |
| 8 | Conversation history persistence + rolling summary truncation | Planned |
