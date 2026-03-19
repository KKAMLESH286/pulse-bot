---
name: create-route
description: Add new routes to GoRouter with proper guards, transitions, and parameter passing. Use when adding new screens, navigation flows, or deep link support.
---

# Create Route (Clean Architecture)

Adds routes to GoRouter following the project's navigation patterns.

## Input

- `$ARGUMENTS` — Route name and screen to navigate to (e.g., `staking detail`, `swap confirmation`)

## Steps

### 1. Add Route Path Constant

Add to `lib/core/routing/route_names.dart`:

```dart
abstract final class RouteNames {
  // Existing routes...

  // Add new route constant
  static const String {feature} = '/{feature}';
  static const String {feature}Detail = '/{feature}/:id';
}
```

**Naming conventions:**
- Lowercase with hyphens for multi-word paths: `/token-detail`, `/swap-settings`
- Use `:param` for dynamic segments: `/tokens/:id`
- Group related routes with common prefix: `/swap/confirm`, `/swap/result`

### 2. Add Route to GoRouter

Edit `lib/core/routing/app_router.dart`:

```dart
@riverpod
GoRouter appRouter(Ref ref) {
  // ... existing setup ...

  return GoRouter(
    routes: [
      // ... existing routes ...

      GoRoute(
        path: RouteNames.{feature},
        name: '{feature}',
        builder: (context, state) => const {Feature}Screen(),
      ),
    ],
  );
}
```

### 3. Route Types

#### Basic Route
```dart
GoRoute(
  path: RouteNames.{feature},
  name: '{feature}',
  builder: (context, state) => const {Feature}Screen(),
),
```

#### Route with Path Parameters
```dart
GoRoute(
  path: RouteNames.tokenDetail, // '/tokens/:id'
  name: 'tokenDetail',
  builder: (context, state) {
    final id = state.pathParameters['id'] ?? '';
    return TokenDetailScreen(tokenId: id);
  },
),
```

#### Route with Query Parameters
```dart
// Navigate
context.go('${RouteNames.swap}?from=dashboard');

// Access
builder: (context, state) {
  final from = state.uri.queryParameters['from'];
  return SwapScreen(source: from);
},
```

#### Route with Extra Data
```dart
// Navigate
context.go(RouteNames.swapConfirm, extra: swapQuote);

// Access
builder: (context, state) {
  final quote = state.extra as SwapQuote?;
  return SwapConfirmScreen(quote: quote);
},
```

#### No Transition (for bottom nav tabs via ShellRoute)
```dart
GoRoute(
  path: RouteNames.dashboard,
  name: 'dashboard',
  pageBuilder: (context, state) => NoTransitionPage(
    key: state.pageKey,
    child: const DashboardScreen(),
  ),
),
```

#### Nested Routes
```dart
GoRoute(
  path: RouteNames.swap,
  name: 'swap',
  builder: (context, state) => const SwapScreen(),
  routes: [
    GoRoute(
      path: 'confirm', // Full path: /swap/confirm
      name: 'swapConfirm',
      builder: (context, state) => const SwapConfirmScreen(),
    ),
    GoRoute(
      path: 'result', // Full path: /swap/result
      name: 'swapResult',
      builder: (context, state) => const SwapResultScreen(),
    ),
  ],
),
```

### 4. Auth Protection

Routes are guarded by the `redirect` function in GoRouter:

```dart
redirect: (context, state) {
  final authService = ref.read(authServiceProvider);
  final isAuthenticated = authService.isAuthenticated;

  // Public routes (no auth required)
  final isPublicRoute =
      state.matchedLocation == RouteNames.connect ||
      state.matchedLocation == RouteNames.{newPublicRoute};

  if (!isAuthenticated && !isPublicRoute) {
    return RouteNames.connect; // Redirect to connect wallet
  }

  if (isAuthenticated && state.matchedLocation == RouteNames.connect) {
    return RouteNames.dashboard; // Already logged in
  }

  return null; // No redirect
},
```

**Protected route (default):** Just add the route — it's protected automatically.
**Public route:** Add to `isPublicRoute` check.

### 5. Navigation Methods

```dart
// Replace route (main navigation, bottom tabs)
context.go(RouteNames.dashboard);

// Push onto stack (detail screens, flows)
context.push(RouteNames.tokenDetail.replaceAll(':id', token.id));

// Go back
context.pop();

// Named navigation with params
context.goNamed('tokenDetail', pathParameters: {'id': token.id});

// Push replacement
context.pushReplacement(RouteNames.dashboard);
```

### 6. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Checklist

- [ ] Path constant added to `RouteNames` in `route_names.dart`
- [ ] `GoRoute` registered in `app_router.dart`
- [ ] Screen import added to router file
- [ ] If public route, added to `isPublicRoute` check
- [ ] Path parameters use `:param` syntax
- [ ] Code generation run if router uses `@riverpod`
- [ ] Navigation tested (forward and back)
