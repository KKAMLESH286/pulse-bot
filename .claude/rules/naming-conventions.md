# Naming Conventions

## File Naming

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{name}_screen.dart` | `login_screen.dart` |
| Provider/Notifier | `{name}_provider.dart` | `dashboard_provider.dart` |
| State | `{name}_state.dart` | `dashboard_state.dart` |
| Widget | `{name}_widget.dart` | `user_card_widget.dart` |
| Repository (interface) | `{name}_repository.dart` | `swap_repository.dart` |
| Repository (impl) | `{name}_repository_impl.dart` | `swap_repository_impl.dart` |
| Datasource | `{name}_remote_datasource.dart` | `swap_remote_datasource.dart` |
| Model (DTO) | `{name}_model.dart` | `token_model.dart` |
| Entity (domain) | `{name}.dart` | `token.dart` |
| Use Case | `{name}_usecase.dart` | `execute_swap_usecase.dart` |
| Service | `{name}_service.dart` | `auth_service.dart` |
| Utils | `{name}_utils.dart` | `date_utils.dart` |
| Extensions | `{name}_extensions.dart` | `string_extensions.dart` |
| Constants | `{name}_constants.dart` | `app_constants.dart` |

## Class Naming

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `{Name}Screen` | `LoginScreen` |
| Notifier | `{Name}Notifier` | `DashboardNotifier` |
| State (Freezed) | `{Name}State` | `DashboardState` |
| Widget | `{Name}Widget` | `UserCardWidget` |
| Repository (interface) | `{Name}Repository` | `SwapRepository` |
| Repository (impl) | `{Name}RepositoryImpl` | `SwapRepositoryImpl` |
| Datasource | `{Name}RemoteDatasource` | `SwapRemoteDatasource` |
| Use Case | `{Name}UseCase` | `ExecuteSwapUseCase` |
| Service | `{Name}Service` | `AuthService` |
| Model (Freezed DTO) | `{Name}Model` | `TokenModel` |
| Entity (domain) | `{Name}` | `Token` |
| Request Model | `{Name}Request` | `SwapRequest` |
| Response Model | `{Name}Response` | `SwapResponse` |

## Folder Naming

Use **snake_case** for all folders:

```
features/
├── wallet_connect/              # Multi-word feature
│   ├── data/
│   │   ├── models/
│   │   ├── datasources/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── providers/
│       ├── screens/
│       └── widgets/
├── dashboard/                   # Single word feature
├── swap/
└── trading_cex/

core/
├── config/
├── constants/
├── network/
│   └── interceptors/
├── routing/
├── services/
├── storage/
├── theme/
└── widgets/
```

## Variable Naming

### Private Fields
```dart
class MyClass {
  final Dio _dio;              // Private with underscore prefix
  final AuthService _authService;
}
```

### Providers
```dart
// Generated provider naming (automatic from @riverpod)
dashboardNotifierProvider        // From DashboardNotifier class
swapNotifierProvider             // From SwapNotifier class
swapRemoteDatasourceProvider     // From swapRemoteDatasource function

// Accessing
ref.watch(dashboardNotifierProvider);
ref.read(swapNotifierProvider.notifier);
```

### Riverpod Provider Access
```dart
// Use ref.read() in action methods
final repo = ref.read(swapRepositoryProvider);
final storage = ref.read(secureStorageProvider);

// Use ref.watch() in build methods and for reactive dependencies
final dio = ref.watch(dioProvider);
```

### State Variables
```dart
class DashboardState {
  final bool isLoading;        // Boolean: is{Action}
  final bool hasError;         // Boolean: has{Something}
  final String? errorMessage;  // Nullable with ?
  final WalletInfo? wallet;    // Nullable object
  final List<Token> tokens;    // List type plural
}
```

## Method Naming

### Provider/Notifier Methods
```dart
class SwapNotifier {
  Future<bool> fetchQuote() async { }     // fetch{Data}
  Future<bool> executeSwap() async { }    // execute{Action}
  Future<bool> updateSlippage() async { } // update{Setting}
  void clearError() { }                    // clear{Something}
  void reset() { }                         // reset
}
```

### Repository Methods
```dart
class SwapRepository {
  Future<List<Token>> getTokens() { }          // get{Plural}
  Future<Token> getTokenById(String id) { }    // get{Single}ById
  Future<SwapQuote> getQuote(SwapParams p) { } // get{Result}
  Future<void> recordSwap(SwapResult r) { }    // record{Entity}
}
```

### Datasource Methods
```dart
class SwapRemoteDatasource {
  Future<List<TokenModel>> fetchTokens() { }       // fetch{Plural}
  Future<TokenModel> fetchTokenById(String id) { }  // fetch{Single}ById
  Future<void> postSwap(SwapRequest req) { }        // post{Entity}
}
```

### Screen Handler Methods
```dart
class _SwapScreenState {
  void _handleSwap() { }            // _handle{Action}
  void _onAmountChanged(String) { } // _on{Field}Changed
  void _showError(String) { }       // _show{Something}
  void _navigateToResult() { }      // _navigateTo{Screen}
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
import 'package:flutter/services.dart';

// 3. Package imports (alphabetical)
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports - core
import 'package:cropr_mobile/core/network/dio_client.dart';
import 'package:cropr_mobile/core/routing/route_names.dart';
import 'package:cropr_mobile/core/storage/secure_storage_service.dart';

// 5. Project imports - feature (relative for same feature)
import '../data/repositories/swap_repository_impl.dart';
import '../domain/entities/token.dart';
import 'swap_provider.dart';

// 6. Part directives
part 'swap_provider.g.dart';
```

## Constants Naming

```dart
// lib/core/constants/tokens.dart
abstract final class ChainConstants {
  static const int ethereumChainId = 1;
  static const int polygonChainId = 137;
}

// lib/core/routing/route_names.dart
abstract final class RouteNames {
  static const String dashboard = '/dashboard';
  static const String swap = '/swap';
  static const String wallets = '/wallets';
  static String tokenDetail(String id) => '/tokens/$id';
}
```

## Enum Naming

```dart
enum ChainNetwork {
  ethereum,
  polygon,
  arbitrum,
  optimism,
  base,
  bsc,
  avalanche,
  linea,
}

extension ChainNetworkX on ChainNetwork {
  bool get isEthereum => this == ChainNetwork.ethereum;

  String get displayName {
    return switch (this) {
      ChainNetwork.ethereum => 'Ethereum',
      ChainNetwork.polygon => 'Polygon',
      ChainNetwork.arbitrum => 'Arbitrum',
      ChainNetwork.optimism => 'Optimism',
      ChainNetwork.base => 'Base',
      ChainNetwork.bsc => 'BSC',
      ChainNetwork.avalanche => 'Avalanche',
      ChainNetwork.linea => 'Linea',
    };
  }
}
```

## Route Naming

```dart
// lib/core/routing/route_names.dart
abstract final class RouteNames {
  static const String connect = '/connect';
  static const String dashboard = '/dashboard';
  static const String wallets = '/wallets';
  static const String swap = '/swap';
  static const String earn = '/earn';
  static const String settings = '/settings';
  static const String tokenDetail = '/tokens/:id';
}
```

## Test File Naming

```
test/
├── features/
│   └── swap/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── swap_remote_datasource_test.dart
│       │   └── repositories/
│       │       └── swap_repository_impl_test.dart
│       ├── domain/
│       │   └── usecases/
│       │       └── execute_swap_usecase_test.dart
│       └── presentation/
│           └── providers/
│               └── swap_provider_test.dart
├── core/
│   └── network/
│       └── dio_client_test.dart
└── integration_test/
```

## Style Rules (CRITICAL)
- [ ] **NO raw colors** - use `AppColors` only
- [ ] **NO inline TextStyle** - use `AppTextStyles` only
- [ ] **NO hardcoded asset strings** - use defined asset constants
- [ ] ScreenUtil extensions used correctly (`.w`, `.h`, `.sp`, `.r`)
- [ ] Const constructors where possible for performance
