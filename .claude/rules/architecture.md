# Architecture Rules: Feature-First Clean Architecture with Riverpod

This project follows a **Feature-First Clean Architecture** pattern with Riverpod for state management and dependency injection. All AI processing happens server-side via Firebase Cloud Functions.

## Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│                       FEATURES                               │
│  Each feature has: presentation / domain / data layers      │
│  (Add layers only when complexity demands it)               │
├─────────────────────────────────────────────────────────────┤
│                        CORE                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │Firestore │ │Firebase  │ │ Routing  │ │  Theme   │       │
│  │          │ │  Auth    │ │(GoRouter)│ │          │       │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘       │
└─────────────────────────────────────────────────────────────┘
```

## Dependency Flow

```
Features → Core
   ↓
presentation → domain → data → Core
```

**Rules:**
- Features can depend on Core
- Within a feature: presentation → domain → data
- Domain layer has NO dependencies on data or presentation
- Core has no dependencies on features
- Never import from one feature into another (use Core for shared state)

## Folder Structure

### 1. Core (`lib/core/`)

Shared infrastructure used across all features.

```
core/
├── config/
│   └── app_config.dart              # Environment variables
├── constants/
│   └── firestore_constants.dart     # Collection names, status values, roles
├── routing/
│   ├── app_router.dart              # GoRouter setup with auth redirects
│   └── route_names.dart             # Route path constants
├── errors/
│   └── failure.dart                 # Sealed failure types (Server, Cache, Auth, Tool)
├── theme/
│   └── app_theme.dart               # Shared theme, colors, typography
└── widgets/                         # Shared reusable UI components
```

### 2. Features (`lib/features/`)

Each feature follows a layered structure. **Add layers only when complexity demands it.**

```
features/{feature}/
├── data/
│   ├── models/                      # DTOs with freezed serialization
│   │   └── {name}_model.dart
│   ├── datasources/                 # Firestore queries / Cloud Function calls
│   │   └── {feature}_remote_datasource.dart
│   └── repositories/                # Repository implementations
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/                    # Core business objects
│   │   └── {name}.dart
│   ├── repositories/                # Abstract repository interfaces
│   │   └── i_{feature}_repository.dart
│   └── usecases/                    # Complex flows only
│       └── {usecase_name}.dart
└── presentation/
    ├── providers/                   # Riverpod providers
    │   └── {feature}_provider.dart
    ├── screens/
    │   └── {feature}_screen.dart
    └── widgets/
        └── {widget_name}_widget.dart
```

### 3. Cloud Functions (`functions/src/`)

All AI processing happens server-side. The Flutter app never calls Claude or Vertex AI directly.

```
functions/src/
├── index.ts                         # Exports all functions
├── chat/
│   ├── chatHandler.ts               # HTTP callable: receives message, runs Claude tool loop
│   ├── toolExecutor.ts              # Dispatches and executes Claude tool calls
│   └── systemPrompt.ts             # Assembles system prompt from agent_config + user profile
├── embeddings/
│   └── embedWorkout.ts              # Firestore trigger: workout write → Vertex AI → vector
├── claude/
│   └── client.ts                    # Anthropic SDK client (OAuth setup token)
├── parsers/
│   └── workoutParser.ts             # Parse structured workout data
└── utils/
    ├── firestore.ts                 # Firestore reference helpers
    └── prChecker.ts                 # Personal record update logic
```

## Component Patterns

### Datasource Pattern (Firestore)

Most datasources interact with Firestore directly:

```dart
// lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart

@riverpod
{Feature}RemoteDatasource {feature}RemoteDatasource(Ref ref) {
  return {Feature}RemoteDatasource(FirebaseFirestore.instance);
}

class {Feature}RemoteDatasource {
  {Feature}RemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  Stream<List<{Model}>> watchAll(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('{collection}')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => {Model}.fromFirestore(doc))
            .toList());
  }
}
```

### Datasource Pattern (Cloud Function Call)

The `ai_coach` datasource calls a Cloud Function HTTP endpoint:

```dart
// lib/features/ai_coach/data/datasources/coach_remote_datasource.dart

@riverpod
CoachRemoteDatasource coachRemoteDatasource(Ref ref) {
  return CoachRemoteDatasource(FirebaseFunctions.instance);
}

class CoachRemoteDatasource {
  CoachRemoteDatasource(this._functions);
  final FirebaseFunctions _functions;

  Future<ChatMessageModel> sendMessage(String userId, String text) async {
    final callable = _functions.httpsCallable('chat');
    final result = await callable.call<Map<String, dynamic>>({
      'userId': userId,
      'message': text,
    });
    return ChatMessageModel.fromJson(result.data);
  }
}
```

### Repository Pattern

```dart
// Domain layer: abstract interface
// lib/features/{feature}/domain/repositories/i_{feature}_repository.dart

abstract class I{Feature}Repository {
  Stream<List<{Entity}>> watchAll(String userId);
  Future<{Entity}> getById(String userId, String id);
}

// Data layer: implementation
// lib/features/{feature}/data/repositories/{feature}_repository_impl.dart

@riverpod
I{Feature}Repository {feature}Repository(Ref ref) {
  return {Feature}RepositoryImpl(ref.watch({feature}RemoteDatasourceProvider));
}

class {Feature}RepositoryImpl implements I{Feature}Repository {
  {Feature}RepositoryImpl(this._datasource);
  final {Feature}RemoteDatasource _datasource;

  @override
  Stream<List<{Entity}>> watchAll(String userId) {
    return _datasource.watchAll(userId).map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
```

### Models (Freezed DTOs with Firestore)

```dart
// lib/features/{feature}/data/models/{name}_model.dart

@freezed
abstract class {Name}Model with _${Name}Model {
  const factory {Name}Model({
    required String id,
    required String name,
    DateTime? createdAt,
  }) = _{Name}Model;

  factory {Name}Model.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return {Name}Model(
      id: doc.id,
      name: data['name'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      _${Name}ModelFromJson(json);
}

extension {Name}ModelX on {Name}Model {
  {Name} toEntity() => {Name}(id: id, name: name, createdAt: createdAt);
}
```

### Use Cases (Only for Complex Flows)

```dart
// lib/features/ai_coach/domain/usecases/send_coach_message.dart
// Only create when business logic spans multiple repositories

class SendCoachMessage {
  SendCoachMessage(this._coachRepo, this._messageRepo);

  final IAiCoachRepository _coachRepo;
  final IMessageRepository _messageRepo;

  Future<ChatMessage> execute(String userId, String text) async {
    await _messageRepo.persistUserMessage(userId, text);
    final response = await _coachRepo.sendMessage(userId, text);
    await _messageRepo.persistAssistantMessage(userId, response);
    return response;
  }
}
```

## Cloud Function Architecture

### Chat Handler (HTTP Callable)

Replaces the current `onMessageCreated` Firestore trigger. Now an HTTP callable that the Flutter app calls directly:

```typescript
// functions/src/chat/chatHandler.ts

export const chat = onCall(async (request) => {
  const { userId, message } = request.data;

  // 1. Assemble system prompt from agent_config + user profile
  // 2. Fetch conversation history from Firestore
  // 3. Call Claude with tool schemas
  // 4. Tool loop: execute tools, feed results back to Claude
  // 5. Persist conversation turn to Firestore
  // 6. Return response to Flutter
});
```

### Embedding Pipeline (Firestore Trigger)

Triggers when a workout document is created/updated:

```typescript
// functions/src/embeddings/embedWorkout.ts

export const onWorkoutCreated = onDocumentCreated(
  "users/{userId}/workouts/{workoutId}",
  async (event) => {
    // 1. Build text representation of workout
    // 2. Call Vertex AI text-embedding-004
    // 3. Write 768-dim vector back to workout document
  }
);
```

## Anti-Patterns to Avoid

### DO NOT:

1. **Call Claude or Vertex AI from Flutter**
   ```dart
   // WRONG - API call from app
   final response = await anthropicClient.messages.create(...);

   // CORRECT - Go through Cloud Function
   final response = await functions.httpsCallable('chat').call(data);
   ```

2. **Import between features**
   ```dart
   // WRONG
   import 'package:track_me/features/workout/presentation/providers/workout_provider.dart';

   // CORRECT - Use core for shared state or pass data via navigation
   import 'package:track_me/core/constants/firestore_constants.dart';
   ```

3. **Access Firestore directly from screens or providers**
   ```dart
   // WRONG - Firestore in screen
   final snap = await FirebaseFirestore.instance.collection('users').get();

   // CORRECT - Go through datasource → repository → provider
   final data = await ref.read(workoutRepositoryProvider).getAll(userId);
   ```

4. **Add all layers to simple features**
   ```dart
   // WRONG - Profile just displays/edits data, doesn't need full domain layer
   features/profile/domain/usecases/...

   // CORRECT - Simple features skip unnecessary layers
   features/profile/presentation/screens/profile_screen.dart
   features/profile/presentation/providers/user_profile_provider.dart
   ```

5. **Create use cases for simple CRUD**
   ```dart
   // WRONG - Pass-through use case
   class GetWorkoutsUseCase {
     Future<List<Workout>> execute() => repository.getAll();
   }

   // CORRECT - Provider calls repository directly for simple operations
   final workouts = await ref.read(workoutRepositoryProvider).getAll(userId);
   ```

## Provider Lifetime Policy (keepAlive)

### Use `@Riverpod(keepAlive: true)` ONLY for core infrastructure:

| Provider | keepAlive | Reason |
|----------|-----------|--------|
| AuthService | Yes | Auth state must persist across navigation |
| FirebaseFirestore instance | Yes | Singleton |

### Use `@riverpod` (default) for everything else:

| Provider | keepAlive | Reason |
|----------|-----------|--------|
| Feature providers/notifiers | No | Should reload fresh data on navigation |
| Repositories | No | Stateless, created per-use |
| Datasources | No | Stateless, created per-use |

## Testing Strategy

### Unit Tests
- Test repositories with mocked datasources
- Test use cases with mocked repositories
- Test providers with mocked repositories

### Widget Tests
- Test screens with mocked providers
- Use ProviderScope overrides

### Integration Tests
- Test full feature flows with patrol
- Use ProviderScope with test overrides
