# Architecture Rules: Feature-First Clean Architecture with Riverpod

This project follows a **Feature-First Clean Architecture** pattern with Riverpod for state management and dependency injection.

## Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│                       FEATURES                               │
│  Each feature has: presentation / domain / data layers      │
│  (Add layers only when complexity demands it)               │
├─────────────────────────────────────────────────────────────┤
│                        CORE                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐       │
│  │ Network  │ │ Storage  │ │ Routing  │ │  Theme   │       │
│  │ (Dio)    │ │ (Secure) │ │(GoRouter)│ │          │       │
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
│   └── app_config.dart          # Environment variables
├── constants/
│   └── tokens.dart              # Token definitions, chain constants
├── routing/
│   ├── app_router.dart          # GoRouter setup with auth redirects
│   └── route_names.dart         # Route path constants
├── network/
│   ├── dio_client.dart          # Dio client assembly
│   ├── exceptions.dart          # Typed exceptions (NetworkException, AuthException, Web3Exception)
│   └── interceptors/
│       ├── wallet_auth_interceptor.dart  # JWT injection from secure storage
│       └── cex_auth_interceptor.dart     # CEX-specific auth headers
├── storage/
│   └── secure_storage_service.dart      # flutter_secure_storage wrapper
├── services/
│   ├── auth_service.dart
│   └── api_service.dart
├── theme/                       # Shared theme, colors, typography
└── widgets/                     # Shared reusable UI components
```

### 2. Features (`lib/features/`)

Each feature follows a layered structure. **Add layers only when complexity demands it** — simple display-only features don't need domain/data layers.

```
features/{feature}/
├── data/
│   ├── models/                  # DTOs with freezed serialization
│   │   └── {name}_model.dart
│   ├── datasources/             # Remote API calls + local cache
│   │   └── {feature}_remote_datasource.dart
│   └── repositories/            # Repository implementations
│       └── {feature}_repository_impl.dart
├── domain/
│   ├── entities/                # Core business objects
│   │   └── {name}.dart
│   ├── repositories/            # Abstract repository interfaces
│   │   └── {feature}_repository.dart
│   └── usecases/                # Single-responsibility business logic (complex flows only)
│       └── {usecase_name}.dart
└── presentation/
    ├── providers/               # Riverpod providers (StateNotifier, AsyncNotifier)
    │   └── {feature}_provider.dart
    ├── screens/
    │   └── {feature}_screen.dart
    └── widgets/                 # Feature-specific widgets
        └── {widget_name}_widget.dart
```

## Component Patterns

### Core Providers (Riverpod DI)

Core dependencies are provided via Riverpod:

```dart
// lib/core/network/dio_client.dart (or core providers file)

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

### Repository Pattern

```dart
// Domain layer: abstract interface
// lib/features/{feature}/domain/repositories/{feature}_repository.dart

abstract class {Feature}Repository {
  Future<List<{Entity}>> getAll();
  Future<{Entity}> getById(String id);
}

// Data layer: implementation
// lib/features/{feature}/data/repositories/{feature}_repository_impl.dart

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

### Datasource Pattern

```dart
// lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart

@riverpod
{Feature}RemoteDatasource {feature}RemoteDatasource(Ref ref) {
  return {Feature}RemoteDatasource(ref.watch(dioProvider));
}

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

### Providers (Presentation Layer)

```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

@riverpod
class {Feature}Notifier extends _${Feature}Notifier {
  @override
  Future<{Feature}State> build() async {
    return const {Feature}State();
  }

  Future<bool> fetchData() async {
    final current = state.value ?? const {Feature}State();
    state = AsyncData(current.copyWith(isLoading: true, error: null));

    try {
      final repository = ref.read({feature}RepositoryProvider);
      final data = await repository.getAll();
      state = AsyncData(current.copyWith(data: data, isLoading: false));
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(error: e.toString(), isLoading: false));
      return false;
    }
  }
}
```

### Use Cases (Only for Complex Flows)

```dart
// lib/features/swap/domain/usecases/execute_swap_usecase.dart
// Only create when business logic spans multiple repositories

class ExecuteSwapUseCase {
  ExecuteSwapUseCase(this._swapRepo, this._walletRepo, this._transactionRepo);

  final SwapRepository _swapRepo;
  final WalletRepository _walletRepo;
  final TransactionRepository _transactionRepo;

  Future<SwapResult> execute(SwapParams params) async {
    final quote = await _swapRepo.getQuote(params);
    final tx = await _walletRepo.buildTransaction(quote);
    final result = await _walletRepo.sendTransaction(tx);
    await _transactionRepo.record(result);
    return result;
  }
}
```

### Models vs Entities

```dart
// Data layer DTO: lib/features/{feature}/data/models/{name}_model.dart
@freezed
abstract class {Name}Model with _${Name}Model {
  const factory {Name}Model({
    required String id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _{Name}Model;

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      _${Name}ModelFromJson(json);
}

// Domain entity: lib/features/{feature}/domain/entities/{name}.dart
// Only create when entity diverges from DTO
@freezed
abstract class {Name} with _${Name} {
  const factory {Name}({
    required String id,
    DateTime? createdAt,
  }) = _{Name};
}
```

## Anti-Patterns to Avoid

### DO NOT:

1. **Put API calls in screens or providers directly**
   ```dart
   // WRONG - API call in screen
   final response = await dio.get('/users');

   // CORRECT - Go through repository
   final users = await ref.read({feature}RepositoryProvider).getAll();
   ```

2. **Import between features**
   ```dart
   // WRONG
   import 'package:app/features/wallets/presentation/providers/wallet_provider.dart';

   // CORRECT - Use core for shared state
   import 'package:app/core/services/auth_service.dart';
   ```

3. **Add all layers to simple features**
   ```dart
   // WRONG - Dashboard just displays data, doesn't need domain layer
   features/dashboard/domain/usecases/...
   features/dashboard/domain/repositories/...

   // CORRECT - Simple features skip unnecessary layers
   features/dashboard/presentation/screens/dashboard_screen.dart
   features/dashboard/presentation/providers/dashboard_provider.dart
   ```

4. **Create use cases for simple CRUD**
   ```dart
   // WRONG - Pass-through use case
   class GetUsersUseCase {
     Future<List<User>> execute() => repository.getAll();
   }

   // CORRECT - Provider calls repository directly for simple operations
   final users = await ref.read(usersRepositoryProvider).getAll();
   ```

5. **Use floating-point for token amounts**
   ```dart
   // WRONG
   double tokenAmount = 1.5;

   // CORRECT
   BigInt tokenAmount = BigInt.from(1500000000000000000);
   // Convert to display string only at presentation boundary
   ```

6. **Use keepAlive on feature providers**
   ```dart
   // WRONG
   @Riverpod(keepAlive: true)
   class DashboardNotifier extends _$DashboardNotifier { }

   // CORRECT - Feature providers should reload per navigation
   @riverpod
   class DashboardNotifier extends _$DashboardNotifier { }
   ```

## Provider Lifetime Policy (keepAlive)

### Use `@Riverpod(keepAlive: true)` ONLY for core infrastructure:

| Provider | keepAlive | Reason |
|----------|-----------|--------|
| Dio | Yes | HTTP client with configured interceptors |
| SecureStorage | Yes | Persistent storage service |
| AuthService | Yes | Auth state must persist across navigation |

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
