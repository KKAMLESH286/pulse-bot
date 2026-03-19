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
│  - API calls via Dio                                        │
│  - Return model DTOs directly                               │
├─────────────────────────────────────────────────────────────┤
│                    CORE PROVIDERS                            │
│  @Riverpod(keepAlive: true)                                 │
│  - Dio, SecureStorage, AuthService                          │
│  - Singleton-like providers                                 │
└─────────────────────────────────────────────────────────────┘
```

## Core Providers (Dependency Injection)

### Location
Core providers live in `lib/core/` (e.g., `lib/core/network/dio_client.dart`).

### Pattern
```dart
import 'package:dio/dio.dart';
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

## Datasource Pattern

### Location
`lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart`

### Pattern
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{feature}_remote_datasource.g.dart';

/// Riverpod provider for datasource
@riverpod
{Feature}RemoteDatasource {feature}RemoteDatasource(Ref ref) {
  return {Feature}RemoteDatasource(ref.watch(dioProvider));
}

/// Datasource class for API calls
class {Feature}RemoteDatasource {
  {Feature}RemoteDatasource(this._dio);

  final Dio _dio;

  Future<List<{Model}>> fetchAll() async {
    final response = await _dio.get('/api/{feature}');
    return (response.data as List)
        .map((json) => {Model}.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
```

## Repository Pattern

### Location
- Interface: `lib/features/{feature}/domain/repositories/{feature}_repository.dart`
- Implementation: `lib/features/{feature}/data/repositories/{feature}_repository_impl.dart`

### Pattern
```dart
// Domain interface
abstract class {Feature}Repository {
  Future<List<{Entity}>> getAll();
  Future<{Entity}> getById(String id);
}

// Data implementation
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

## Provider/Notifier Pattern

### UI State with Freezed
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

### Notifier Structure
```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/{feature}_repository.dart';
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

### Provider Rules

#### DO:
```dart
// Safe state access with fallback (Riverpod 3.x)
final current = state.value ?? const {Feature}State();

// Return bool for UI feedback
Future<bool> doAction() async { ... return true/false; }

// Use ref.read() for repositories/datasources
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

### Provider Invalidation for Refresh
```dart
// Invalidate providers to refresh data
ref.invalidate({feature}RepositoryProvider);
ref.invalidate({feature}NotifierProvider);
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

1. **Use Riverpod for everything** - both DI and state management
2. **Use `@Riverpod(keepAlive: true)`** only for core infrastructure (Dio, SecureStorage, AuthService)
3. **Use `@riverpod`** for all feature providers (notifiers, repositories, datasources)
4. **Always use `state.value`** with fallback (Riverpod 3.x pattern)
5. **Return `bool`** from action methods for UI feedback
6. **Clear errors** before starting new operations
7. **Use Freezed `abstract class`** for immutable UI states (Freezed 3.x)
8. **Use `ref.read()`** for repositories in provider action methods
9. **Use `ref.watch()`** in UI for reactive updates
10. **Run build_runner** after adding/modifying providers
