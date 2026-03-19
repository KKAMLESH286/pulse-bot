---
name: riverpod-state-management
description: Expert Riverpod state management implementation for Flutter apps. Use when implementing state management with Riverpod, flutter_riverpod, or riverpod_annotation. Covers providers, code generation, dependency injection, async data handling, and Feature-First Clean Architecture patterns.
allowed-tools: Read, Edit, Write, Grep, Glob, Bash
---

# Riverpod State Management (Clean Architecture)

Expert assistance for implementing state management using Riverpod for both state management and dependency injection in a Feature-First Clean Architecture.

## Architecture Overview

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
│  - API calls via Dio                                        │
│  - Return model DTOs directly                               │
├─────────────────────────────────────────────────────────────┤
│                    CORE PROVIDERS                            │
│  @Riverpod(keepAlive: true)                                 │
│  - Dio, SecureStorage, AuthService                          │
│  - Singleton-like providers                                 │
└─────────────────────────────────────────────────────────────┘
```

## Core Providers (Riverpod DI)

```dart
// lib/core/network/dio_client.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

/// Dio HTTP client with auth interceptor
@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.backendUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(WalletAuthInterceptor(secureStorage));
  return dio;
}
```

## Provider/Notifier Pattern

### State Class (Freezed)

```dart
// lib/features/{feature}/presentation/providers/{feature}_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

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

### Notifier

```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/{feature}_repository_impl.dart';
import '{feature}_state.dart';

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

    state = AsyncData(current.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      // Use ref.read() for repositories
      final data = await ref.read({feature}RepositoryProvider).getAll();

      state = AsyncData(current.copyWith(
        data: data,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
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

## Datasource Pattern

```dart
// lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{feature}_remote_datasource.g.dart';

@riverpod
{Feature}RemoteDatasource {feature}RemoteDatasource(Ref ref) {
  return {Feature}RemoteDatasource(ref.watch(dioProvider));
}

class {Feature}RemoteDatasource {
  {Feature}RemoteDatasource(this._dio);
  final Dio _dio;

  Future<List<{Feature}Model>> fetchAll() async {
    final response = await _dio.get('/api/{feature}');
    return (response.data as List)
        .map((json) => {Feature}Model.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
```

## Repository Pattern

```dart
// Domain interface
// lib/features/{feature}/domain/repositories/{feature}_repository.dart

abstract class {Feature}Repository {
  Future<List<{Entity}>> getAll();
  Future<{Entity}> getById(String id);
}

// Data implementation
// lib/features/{feature}/data/repositories/{feature}_repository_impl.dart

@riverpod
{Feature}Repository {feature}Repository(Ref ref) {
  return {Feature}RepositoryImpl(ref.watch({feature}RemoteDatasourceProvider));
}

class {Feature}RepositoryImpl implements {Feature}Repository {
  {Feature}RepositoryImpl(this._datasource);
  final {Feature}RemoteDatasource _datasource;

  @override
  Future<List<{Entity}>> getAll() async {
    final models = await _datasource.fetchAll();
    return models.map((m) => m.toEntity()).toList();
  }
}
```

## Screen Integration

### ConsumerStatefulWidget

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

  Future<void> _handleAction() async {
    final success = await ref.read({feature}NotifierProvider.notifier).doAction();
    if (success && mounted) {
      context.go(RouteNames.nextScreen);
    } else {
      _showError();
    }
  }

  void _showError() {
    final state = ref.read({feature}NotifierProvider);
    if (state.value?.hasError == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.value!.error!)),
      );
    }
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

## Ref Methods

```dart
// Watch: Rebuilds when value changes (use in build())
final state = ref.watch({feature}NotifierProvider);

// Read: One-time read, no rebuild (use in callbacks)
final success = await ref.read({feature}NotifierProvider.notifier).doAction();

// Listen: Side effects on change
ref.listen({feature}NotifierProvider, (previous, next) {
  if (next.value?.hasError == true) {
    showErrorSnackBar(context, next.value!.error!);
  }
});

// Invalidate: Force provider refresh
ref.invalidate({feature}NotifierProvider);
```

## Cross-Feature State Sharing

### Via Core Services

```dart
// Access shared auth state from any provider
@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  Future<DashboardState> build() async {
    final authService = ref.read(authServiceProvider);
    final wallet = authService.currentWallet;
    return DashboardState(wallet: wallet);
  }
}
```

### Provider Invalidation

```dart
ref.invalidate({feature}RepositoryProvider);
ref.invalidate({feature}NotifierProvider);
```

## Provider Lifetime Policy

| Provider | keepAlive | Reason |
|----------|-----------|--------|
| Dio | Yes | Core HTTP client |
| SecureStorage | Yes | Persistent storage |
| AuthService | Yes | Auth state persists |
| Feature notifiers | No | Reload on navigation |
| Repositories | No | Stateless per-use |
| Datasources | No | Stateless per-use |

## Best Practices

### DO:
```dart
// Safe state access (Riverpod 3.x)
final current = state.value ?? const {Feature}State();

// Return bool for UI feedback
Future<bool> doAction() async { ... return true/false; }

// ref.read() for repositories in actions
final repo = ref.read({feature}RepositoryProvider);

// ref.watch() in build
final state = ref.watch({feature}NotifierProvider);

// Clear errors before operations
state = AsyncData(current.copyWith(isLoading: true, error: null));
```

### DON'T:
```dart
// CRASHES if state not initialized
state = AsyncData(state.value!.copyWith(...));

// Riverpod 2.x pattern
final current = state.valueOrNull ?? const {Feature}State();

// No UI feedback
Future<void> doAction() async { }

// Don't use ref.watch() in callbacks
onPressed: () => ref.watch(...), // Use ref.read()
```

## Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs  # Watch mode
```

## Related Skills

- **create-controller** — Create providers with proper patterns
- **create-screen** — Create screens that consume providers
- **create-feature** — Scaffold complete feature
- **create-data-provider** — Create repository + datasource layer
