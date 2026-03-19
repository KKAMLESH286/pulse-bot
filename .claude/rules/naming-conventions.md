# Naming Conventions

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{name}_screen.dart` | `ai_coach_screen.dart` |
| Provider/Notifier | `{name}_provider.dart` | `coach_provider.dart` |
| State | `{name}_state.dart` | `coach_state.dart` |
| Widget | `{name}_widget.dart` | `message_bubble_widget.dart` |
| Repository (interface) | `i_{name}_repository.dart` | `i_ai_coach_repository.dart` |
| Repository (impl) | `{name}_repository_impl.dart` | `ai_coach_repository_impl.dart` |
| Datasource | `{name}_remote_datasource.dart` | `coach_remote_datasource.dart` |
| Model (DTO) | `{name}_model.dart` | `chat_message_model.dart` |
| Entity (domain) | `{name}.dart` | `chat_message.dart` |
| Use Case | `{name}_usecase.dart` | `send_coach_message_usecase.dart` |
| Service | `{name}_service.dart` | `auth_service.dart` |
| Constants | `{name}_constants.dart` | `firestore_constants.dart` |

## Class Naming

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{Name}Screen` | `AiCoachScreen` |
| Notifier | `{Name}Notifier` | `CoachNotifier` |
| State (Freezed) | `{Name}State` | `CoachState` |
| Widget | `{Name}Widget` | `MessageBubbleWidget` |
| Repository (interface) | `I{Name}Repository` | `IAiCoachRepository` |
| Repository (impl) | `{Name}RepositoryImpl` | `AiCoachRepositoryImpl` |
| Datasource | `{Name}RemoteDatasource` | `CoachRemoteDatasource` |
| Use Case | `{Name}UseCase` | `SendCoachMessageUseCase` |
| Service | `{Name}Service` | `AuthService` |
| Model (Freezed DTO) | `{Name}Model` | `ChatMessageModel` |
| Entity (domain) | `{Name}` | `ChatMessage` |

## Folder Naming

Use **snake_case** for all folders:

```
features/
├── auth/
├── ai_coach/
├── workout/
├── personal_records/
└── profile/

core/
├── config/
├── constants/
├── routing/
├── errors/
├── theme/
└── widgets/
```

## Variable Naming

### Private Fields
```dart
class MyClass {
  final FirebaseFirestore _firestore;
  final AuthService _authService;
}
```

### Providers
```dart
// Generated provider naming (automatic from @riverpod)
coachNotifierProvider               // From CoachNotifier class
workoutRepositoryProvider           // From workoutRepository function
coachRemoteDatasourceProvider       // From coachRemoteDatasource function

// Accessing
ref.watch(coachNotifierProvider);
ref.read(coachNotifierProvider.notifier);
```

### Riverpod Provider Access
```dart
// Use ref.read() in action methods
final repo = ref.read(workoutRepositoryProvider);

// Use ref.watch() in build methods and for reactive dependencies
final authState = ref.watch(authStateProvider);
```

### State Variables
```dart
class CoachState {
  final bool isLoading;            // Boolean: is{Action}
  final bool isSending;            // Boolean: is{Action}
  final bool hasError;             // Boolean: has{Something}
  final String? error;             // Nullable with ?
  final List<ChatMessage> messages; // List type plural
}
```

## Method Naming

### Provider/Notifier Methods
```dart
class CoachNotifier {
  Future<bool> sendMessage() async { }     // send{Something}
  Future<bool> fetchHistory() async { }    // fetch{Data}
  void clearError() { }                     // clear{Something}
  void reset() { }                          // reset
}
```

### Repository Methods
```dart
class WorkoutRepository {
  Stream<List<Workout>> watchAll(String userId) { }     // watch{Plural}
  Future<Workout> getById(String userId, String id) { } // get{Single}ById
  Future<void> create(String userId, Workout w) { }     // create
  Future<void> delete(String userId, String id) { }     // delete
}
```

### Datasource Methods
```dart
class WorkoutRemoteDatasource {
  Stream<List<WorkoutModel>> watchAll(String userId) { }     // watch{Plural}
  Future<WorkoutModel> fetchById(String userId, String id) { } // fetch{Single}ById
  Future<void> create(String userId, WorkoutModel m) { }      // create
}
```

### Screen Handler Methods
```dart
class _AiCoachScreenState {
  void _handleSend() { }                // _handle{Action}
  void _onMessageChanged(String) { }    // _on{Field}Changed
  void _showError(String) { }           // _show{Something}
}
```

## Import Organization

Order imports as follows:

```dart
// 1. Dart imports
import 'dart:async';
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports (alphabetical)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports - core
import 'package:track_me/core/constants/firestore_constants.dart';
import 'package:track_me/core/routing/route_names.dart';

// 5. Project imports - feature (relative for same feature)
import '../data/repositories/workout_repository_impl.dart';
import '../domain/entities/workout.dart';
import 'workout_provider.dart';

// 6. Part directives
part 'workout_provider.g.dart';
```

## Constants Naming

```dart
// lib/core/constants/firestore_constants.dart
abstract final class FirestoreConstants {
  static const String usersCollection = 'users';
  static const String messagesSubcollection = 'messages';
  static const String workoutsSubcollection = 'workouts';
  static const String prsSubcollection = 'prs';
  static const String agentConfigSubcollection = 'agent_config';
}

abstract final class MessageStatus {
  static const String sent = 'sent';
  static const String processing = 'processing';
  static const String done = 'done';
  static const String error = 'error';
}

abstract final class MessageRole {
  static const String user = 'user';
  static const String assistant = 'assistant';
}

// lib/core/routing/route_names.dart
abstract final class RouteNames {
  static const String signIn = '/sign-in';
  static const String chat = '/chat';
  static const String history = '/history';
  static const String prs = '/prs';
  static const String profile = '/profile';
}
```

## Route Naming

```dart
abstract final class RouteNames {
  static const String signIn = '/sign-in';
  static const String chat = '/chat';
  static const String history = '/history';
  static String workoutDetail(String date) => '/history/$date';
  static const String prs = '/prs';
  static const String profile = '/profile';
}
```

## Test File Naming

```
test/
├── features/
│   ├── ai_coach/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── coach_remote_datasource_test.dart
│   │   │   └── repositories/
│   │   │       └── ai_coach_repository_impl_test.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── coach_provider_test.dart
│   └── workout/
│       └── ...
├── core/
│   └── ...
└── integration_test/
```

## Style Rules (CRITICAL)
- [ ] **NO raw colors** — use `AppColors` / theme only
- [ ] **NO inline TextStyle** — use theme text styles
- [ ] Const constructors where possible for performance
