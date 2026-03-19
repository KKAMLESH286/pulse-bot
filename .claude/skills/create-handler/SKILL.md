---
name: create-handler
description: Create a core service wrapper for external services like WalletConnect, Firebase, or third-party APIs. Use when integrating external services, adding authentication, or wrapping SDKs.
---

# Create Core Service (Clean Architecture)

Creates service classes that wrap external SDKs and live in the core layer.

## Input

- `$ARGUMENTS` — Service name and external SDK being wrapped (e.g., `wallet_connect`, `firebase_messaging`)

## Steps

### 1. Determine Service Location

Services wrapping external SDKs live in `lib/core/services/`:

```
lib/core/services/
├── auth_service.dart              # WalletConnect + JWT auth
├── {service}_service.dart         # Service implementation
└── ...
```

### 2. Create Service Class

```dart
// lib/core/services/{service}_service.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{service}_service.g.dart';

/// Riverpod provider — keepAlive for singleton services
@Riverpod(keepAlive: true)
{Service}Service {service}Service(Ref ref) {
  return {Service}Service();
}

/// Service class wrapping {ExternalSDK}
class {Service}Service {
  {Service}Service({
    String? config,
  }) : _config = config ?? const String.fromEnvironment('{SERVICE}_CONFIG');

  final String _config;

  bool get isInitialized => _initialized;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    // SDK initialization
    _initialized = true;
  }

  Future<void> dispose() async {
    _initialized = false;
  }
}
```

### 3. Register as Riverpod Provider

Core services use `@Riverpod(keepAlive: true)` since they persist across navigation:

```dart
// In the same file or in lib/core/services/{service}_service.dart

@Riverpod(keepAlive: true)
{Service}Service {service}Service(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return {Service}Service(storage: secureStorage);
}
```

### 4. Use in Feature Providers

```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

@riverpod
class {Feature}Notifier extends _${Feature}Notifier {
  @override
  Future<{Feature}State> build() async {
    final service = ref.read({service}ServiceProvider);
    // Use service
    return const {Feature}State();
  }
}
```

## Common Service Patterns

### Auth Service (WalletConnect + JWT)

```dart
// lib/core/services/auth_service.dart

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthService(secureStorage);
}

class AuthService {
  AuthService(this._secureStorage);
  final SecureStorageService _secureStorage;

  String? _jwtToken;
  WalletInfo? _currentWallet;

  bool get isAuthenticated => _jwtToken != null;
  WalletInfo? get currentWallet => _currentWallet;

  Future<bool> authenticate(String walletAddress, String signature) async {
    // Call backend, get JWT
    // Store in secure storage
    await _secureStorage.write(key: 'jwt', value: _jwtToken!);
    return true;
  }

  Future<void> logout() async {
    _jwtToken = null;
    _currentWallet = null;
    await _secureStorage.delete(key: 'jwt');
  }

  Future<String?> getToken() async {
    _jwtToken ??= await _secureStorage.read(key: 'jwt');
    return _jwtToken;
  }
}
```

### Push Notification Service

```dart
// lib/core/services/push_notification_service.dart

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return PushNotificationService();
}

class PushNotificationService {
  Future<void> initialize() async {
    // Request permission, register token
  }

  Future<String?> getToken() async {
    // Get FCM/APNs token
    return null;
  }

  Stream<Map<String, dynamic>> get onMessage {
    // Return notification stream
    return const Stream.empty();
  }
}
```

## Rules

### DO:
- Use `@Riverpod(keepAlive: true)` for singleton services
- Store sensitive data (tokens, keys) in `flutter_secure_storage` — NEVER in-memory only
- Handle all SDK errors internally or rethrow as typed exceptions
- Keep services focused on a single external dependency
- Use `AppConfig` for environment variables (domain, client IDs, etc.)

### DON'T:
- Don't put services in feature folders — they belong in `lib/core/services/`
- Don't access feature providers from services (services are in core layer)
- Don't store sensitive data in SharedPreferences
- Don't handle UI logic in services
- Don't import from features into core

## Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Checklist

- [ ] Service created in `lib/core/services/`
- [ ] Uses `@Riverpod(keepAlive: true)` provider
- [ ] Sensitive data stored in `flutter_secure_storage`
- [ ] Environment config via `AppConfig` (not hardcoded)
- [ ] Errors mapped to typed exceptions
- [ ] No feature-layer imports in service
- [ ] Code generation run successfully
