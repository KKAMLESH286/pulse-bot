# State Management Rules

This project uses **Riverpod 3.x** with code generation for both state management and dependency injection, following **Feature-First Clean Architecture**.

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        SCREEN                                │
│  ConsumerStatefulWidget / ConsumerWidget                    │
│  - ref.watch() for reactive state                           │
│  - ref.read() for actions                                   │
├─────────────────────────────────────────────────────────────┤
│                   PROVIDER / NOTIFIER                        │
│  @riverpod AsyncNotifier                                    │
│  - Manages UI state                                         │
│  - Uses ref.read() for repositories                         │
├─────────────────────────────────────────────────────────────┤
│                     REPOSITORIES                             │
│  Abstract interface (domain) + Implementation (data)        │
│  - Business logic boundary                                  │
│  - Map DTOs to entities                                     │
├─────────────────────────────────────────────────────────────┤
│                     DATASOURCES                              │
│  @riverpod functional providers                             │
│  - Firestore queries (most features)                        │
│  - Cloud Function calls (ai_coach)                          │
│  - Return model DTOs directly                               │
├─────────────────────────────────────────────────────────────┤
│                    CORE PROVIDERS                            │
│  @Riverpod(keepAlive: true)                                 │
│  - AuthService, FirebaseFirestore                           │
│  - Singleton-like providers                                 │
└─────────────────────────────────────────────────────────────┘
```

## Core Providers (Dependency Injection)

### Location
Core providers live in `lib/core/` or `lib/features/auth/presentation/providers/`.

### Pattern
```dart
// lib/features/auth/presentation/providers/auth_provider.dart

part 'auth_provider.g.dart';

/// Auth service — singleton, persists across navigation
@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}

/// Auth state stream — singleton, persists across navigation
@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}

/// Current user — derived from auth state
@riverpod
User? currentUser(Ref ref) {
  return ref.watch(authStateProvider).value;
}
```

## Datasource Pattern

### Firestore Datasource (most features)
```dart
// lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart

part '{feature}_remote_datasource.g.dart';

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

### Cloud Function Datasource (ai_coach only)
```dart
// lib/features/ai_coach/data/datasources/coach_remote_datasource.dart

@riverpod
CoachRemoteDatasource coachRemoteDatasource(Ref ref) {
  return CoachRemoteDatasource(FirebaseFunctions.instance);
}

class CoachRemoteDatasource {
  CoachRemoteDatasource(this._functions);
  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> sendMessage(String userId, String text) async {
    final callable = _functions.httpsCallable('chat');
    final result = await callable.call<Map<String, dynamic>>({
      'userId': userId,
      'message': text,
    });
    return result.data;
  }
}
```

## Repository Pattern

### Location
- Interface: `lib/features/{feature}/domain/repositories/i_{feature}_repository.dart`
- Implementation: `lib/features/{feature}/data/repositories/{feature}_repository_impl.dart`

### Pattern
```dart
// Domain interface
abstract class I{Feature}Repository {
  Stream<List<{Entity}>> watchAll(String userId);
  Future<{Entity}> getById(String userId, String id);
}

// Data implementation + provider
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

## Provider/Notifier Pattern

### UI State with Freezed
```dart
// lib/features/{feature}/presentation/providers/{feature}_state.dart

part '{feature}_state.freezed.dart';

@freezed
abstract class {Feature}State with _${Feature}State {
  const factory {Feature}State({
    @Default(false) bool isLoading,
    String? error,
    List<{Entity}>? data,
  }) = _{Feature}State;

  const {Feature}State._();

  bool get hasError => error != null && error!.isNotEmpty;
  bool get hasData => data != null && data!.isNotEmpty;

  {Feature}State clearError() => copyWith(error: null);
}
```

### Notifier Structure
```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

part '{feature}_provider.g.dart';

@riverpod
class {Feature}Notifier extends _${Feature}Notifier {
  @override
  Future<{Feature}State> build() async {
    return const {Feature}State();
  }

  Future<bool> fetchData() async {
    // ALWAYS use state.value with fallback (Riverpod 3.x)
    final current = state.value ?? const {Feature}State();

    state = AsyncData(current.copyWith(isLoading: true, error: null));

    try {
      final data = await ref.read({feature}RepositoryProvider).getAll();
      state = AsyncData(current.copyWith(data: data, isLoading: false));
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(error: e.toString(), isLoading: false));
      return false;
    }
  }

  void clearError() {
    final current = state.value;
    if (current != null && current.hasError) {
      state = AsyncData(current.clearError());
    }
  }
}
```

### Stream-Based Providers (for Firestore real-time data)

```dart
// For features that use Firestore streams (workout history, PRs, messages)
@riverpod
Stream<List<{Entity}>> {feature}Stream(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch({feature}RepositoryProvider).watchAll(user.uid);
}
```

### Provider Rules

#### DO:
```dart
// Safe state access with fallback (Riverpod 3.x)
final current = state.value ?? const {Feature}State();

// Return bool for UI feedback
Future<bool> doAction() async { ... return true/false; }

// Use ref.read() for repositories/datasources in action methods
final repository = ref.read({feature}RepositoryProvider);

// Clear errors before new operations
state = AsyncData(current.copyWith(isLoading: true, error: null));
```

#### DON'T:
```dart
// CRASHES if state not initialized
state = AsyncData(state.value!.copyWith(...));

// Don't use valueOrNull (Riverpod 2.x) - use value (Riverpod 3.x)
final current = state.valueOrNull ?? const {Feature}State();  // WRONG

// Don't return void - use bool for feedback
Future<void> doAction() async { }  // WRONG

// Don't access Firestore directly in providers
final snap = await FirebaseFirestore.instance.collection('users').get();  // WRONG
```

## Screen Integration

### ConsumerStatefulWidget Pattern
```dart
class {Feature}Screen extends ConsumerStatefulWidget {
  const {Feature}Screen({super.key});

  @override
  ConsumerState<{Feature}Screen> createState() => _{Feature}ScreenState();
}

class _{Feature}ScreenState extends ConsumerState<{Feature}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read({feature}NotifierProvider.notifier).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch({feature}NotifierProvider);

    return Scaffold(
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (uiState) => _buildContent(uiState),
      ),
    );
  }
}
```

### ConsumerWidget Pattern (Stateless)
```dart
class {Widget}Widget extends ConsumerWidget {
  const {Widget}Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({feature}NotifierProvider);

    return state.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data: (uiState) => Text(uiState.data?.toString() ?? 'No data'),
    );
  }
}
```

## Code Generation

After creating or modifying providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Best Practices Summary

1. **Use Riverpod for everything** — both DI and state management
2. **Use `@Riverpod(keepAlive: true)`** only for core infrastructure (AuthService)
3. **Use `@riverpod`** for all feature providers (notifiers, repositories, datasources)
4. **Always use `state.value`** with fallback (Riverpod 3.x pattern)
5. **Return `bool`** from action methods for UI feedback
6. **Clear errors** before starting new operations
7. **Use Freezed `abstract class`** for immutable UI states (Freezed 3.x)
8. **Use `ref.read()`** for repositories in provider action methods
9. **Use `ref.watch()`** in UI for reactive updates
10. **Run build_runner** after adding/modifying providers
11. **Use Stream providers** for Firestore real-time data
12. **Never call Firestore directly** from screens or providers — go through datasource → repository
