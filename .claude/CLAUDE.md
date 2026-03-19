# CLAUDE.md — ConnectWallet (CROPR Finance Flutter Mobile App)

## Project Overview

DeFi portfolio management mobile app built with Flutter, converting the existing React web app. Supports 8 blockchain networks (Ethereum, Polygon, Arbitrum, Optimism, Base, BSC, Avalanche, Linea) with wallet-based authentication, token swaps, staking, lending, and bridge features.

- **Flutter SDK:** ^3.41.3
- **Dart:** ^3.11.1
- **Backend:** Node.js API at `BACKEND_URL` (configured via `.env`)

## Architecture

### Pattern: Feature-First Clean Architecture with Riverpod

Each feature follows this layered structure (add layers only when complexity demands it):

```
features/<feature>/
├── data/
│   ├── models/          # DTOs with freezed serialization
│   ├── datasources/     # Remote API calls + local cache
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/         # Core business objects
│   ├── repositories/     # Abstract repository interfaces
│   └── usecases/         # Single-responsibility business logic (only for complex flows)
└── presentation/
    ├── providers/         # Riverpod providers (StateNotifier, AsyncNotifier)
    ├── screens/
    └── widgets/           # Feature-specific widgets
```

**Do NOT add all layers to every feature.** Simple display-only features (e.g., dashboard) don't need domain/data layers. Add them when the feature has real business logic or data-fetching needs.

### Core Layer

```
core/
├── config/              # AppConfig, environment variables
├── constants/           # Token definitions, chain constants
├── routing/             # GoRouter setup with auth redirects
├── network/             # Dio client, interceptors, error types
├── storage/             # flutter_secure_storage wrapper
├── theme/               # Shared theme, colors, typography
└── widgets/             # Shared reusable UI components
```

### Key Libraries

| Purpose | Package | Notes |
|---|---|---|
| State management | `flutter_riverpod` | Use `AsyncNotifierProvider` for data-fetching. Prefer `@riverpod` codegen as features grow. |
| Navigation | `go_router` | Named routes with auth-aware redirects. Use `ShellRoute` for bottom nav tabs. |
| Web3/Wallet | `reown_appkit` | WalletConnect v2 modal + session management. |
| HTTP client | `dio` (migrate from `http`) | Add interceptors for JWT injection and error handling. |
| Models | `freezed` + `json_serializable` | Use for all state classes and API models — generates copyWith, ==, JSON. |
| Secure storage | `flutter_secure_storage` | Persist JWT tokens — never store in-memory only. |
| Testing | `patrol` | Integration tests. Add unit tests for notifiers and repositories. |

## Coding Conventions

### State Management (Riverpod)

- Use `StateNotifierProvider` for mutable UI state with complex transitions.
- Use `AsyncNotifierProvider` for any provider that fetches data (handles loading/error/data).
- Use `Provider` for computed/derived state.
- Use `StateProvider` only for trivial single-value state.
- Never put API calls directly in screens — always go through a provider.
- Keep providers scoped to their feature; shared state lives in `core/`.

### API & Data Layer

- All HTTP calls go through repository classes, never called directly from providers or screens.
- Repository interfaces live in `domain/repositories/`; implementations in `data/repositories/`.
- Use Dio interceptors for:
  - `WalletAuthInterceptor` — auto-inject JWT from secure storage.
  - `CexAuthInterceptor` — CEX-specific auth headers.
  - Error interceptor — map HTTP errors to typed `AppException` subclasses.
- Use BigInt for all token amount arithmetic (no floating-point).
- Convert wei/smallest-unit values at the presentation layer boundary only.

### Use Cases

- Create a use case only when business logic spans multiple repositories or requires orchestration.
- Example: `ExecuteSwapUseCase` (fetch quote → build tx → send via wallet → record to backend).
- Do NOT create use cases for simple pass-through CRUD operations.

### Navigation

- All route paths defined in `RouteNames` constants.
- Auth redirect logic lives in the router, not in individual screens.
- Protected routes redirect to `/connect` when wallet is disconnected.
- Use `ShellRoute` for bottom navigation tabs (dashboard, wallets, trade, earn, settings).

### Error Handling

- Define typed exceptions (e.g., `NetworkException`, `AuthException`, `Web3Exception`).
- Catch and map errors at the repository layer.
- Providers expose error state via `AsyncValue.error` or state class error fields.
- Show user-facing errors via SnackBar or dialog — never raw exception messages.

### Models & Serialization

- Use `freezed` for all state and entity classes.
- Use `json_serializable` (via freezed) for API response models.
- Keep DTOs (data layer) separate from entities (domain layer) when they diverge.
- Name model files: `<name>_model.dart` (data), `<name>.dart` (domain entity).

## Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── config/
│   │   └── app_config.dart
│   ├── constants/
│   │   └── tokens.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── route_names.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── interceptors/
│   │   │   ├── wallet_auth_interceptor.dart
│   │   │   └── cex_auth_interceptor.dart
│   │   └── exceptions.dart
│   ├── storage/
│   │   └── secure_storage_service.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   └── api_service.dart
│   ├── theme/
│   └── widgets/
└── features/
    ├── wallet_connect/
    ├── dashboard/
    ├── swap/
    ├── wallets/
    ├── token_list/
    ├── trading_cex/
    ├── staking/
    ├── lending/
    ├── liquidity/
    ├── vaults/
    ├── bridge/
    ├── transactions/
    └── referrals/
```

## Build & Run

```bash
# Install dependencies
flutter pub get

# Run code generation (after adding freezed/riverpod_generator)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run

# Run tests
flutter test
flutter test integration_test/
```

## Environment Variables

Required in `.env` at project root:

```
WALLET_CONNECT_PROJECT_ID=<project-id>
ETHEREUM_RPC=<rpc-url>
POLYGON_RPC=<rpc-url>
ARBITRUM_RPC=<rpc-url>
OPTIMISM_RPC=<rpc-url>
BASE_RPC=<rpc-url>
BSC_RPC=<rpc-url>
AVALANCHE_RPC=<rpc-url>
LINEA_RPC=<rpc-url>
BACKEND_URL=<backend-api-url>
```

Never commit `.env` to version control.

## Things to Avoid

- Do not use BLoC alongside Riverpod — stick with Riverpod only.
- Do not create abstract interfaces for everything — only abstract repositories (for testability) and datasources (for cache vs remote).
- Do not add domain/data layers to simple features that are just displaying static UI.
- Do not use floating-point math for token amounts — always use BigInt.
- Do not store JWT or sensitive data in SharedPreferences — use flutter_secure_storage.
- Do not put business logic in widgets or screens — it belongs in providers or use cases.
- Do not create helper/utility classes for one-time operations.
- Do not add error handling for impossible scenarios — trust internal code, validate at boundaries.

## Implementation Phases

| Phase | Focus | Status |
|---|---|---|
| 0 | Core infra (Riverpod, GoRouter, WalletConnect, Auth) | Done |
| 1 | Dashboard, Wallets, Token list, Charts, Socket.IO | Next |
| 2 | DEX trading, CEX trading, Order history | Planned |
| 3 | Staking, Lending, Liquidity, Vaults | Planned |
| 4 | Bridge, Transactions, Referrals, Asset detail | Planned |
| 5 | Polish, testing, App Store release | Planned |

## Refactoring Priority (Immediate Next Steps)

1. Add `flutter_secure_storage` — persist JWT (users lose auth on restart).
2. Migrate `http` to `Dio` with auth interceptors.
3. Extract repositories from `ApiService` / `AuthService`.
4. Add `freezed` for `WalletState`, `SwapState`, and all API models.
5. Build shared widget library and theme as more screens are added.
6. Add unit tests for all notifiers and repositories.
