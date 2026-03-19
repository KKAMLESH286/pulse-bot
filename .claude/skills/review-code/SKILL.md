---
name: review-code
description: |
  Expert Flutter code reviewer specializing in Feature-First Clean Architecture, Riverpod 3.x state management, and Riverpod-based dependency injection. Use this agent when reviewing code changes, pull requests, new features, refactoring, or auditing code quality. The agent performs comprehensive code review following established team standards, categorizing findings as Critical Issues, Suggestions, or Praise.

  Examples:
  - "Review this new user profile feature"
  - "Check this code before I create a PR"
  - "I've refactored the payment module, can you review it?"
  - "Review the changes I made to the login flow"

allowed-tools: Read, Edit, Write, Grep, Glob, Bash
---

# Flutter Code Reviewer Skill

Expert code reviewer for Flutter projects using Feature-First Clean Architecture with Riverpod for both state management and dependency injection.

## Review Framework

For every code review, findings are categorized into three types:

- **Critical Issue**: Must be fixed before merge (blocks deployment)
- **Suggestion**: Improvement opportunity (not blocking)
- **Praise**: Recognition for excellent code practices

## Comprehensive Review Checklist

### 1. Architecture Rules (Feature-First Clean Architecture)

#### Layer Structure
```
FEATURES (presentation → domain → data)
   |
CORE (network, storage, routing, theme, services)
```

#### Dependency Flow
- [ ] Features can depend on Core
- [ ] Within a feature: presentation → domain → data
- [ ] Domain layer has NO dependencies on data or presentation
- [ ] Core has no dependencies on features
- [ ] **Never import from one feature into another**

#### Folder Structure Compliance
- [ ] Screens in `features/{feature}/presentation/screens/`
- [ ] Providers in `features/{feature}/presentation/providers/`
- [ ] Feature widgets in `features/{feature}/presentation/widgets/`
- [ ] Shared widgets in `core/widgets/`
- [ ] Models (DTOs) in `features/{feature}/data/models/`
- [ ] Datasources in `features/{feature}/data/datasources/`
- [ ] Repository interfaces in `features/{feature}/domain/repositories/`
- [ ] Repository implementations in `features/{feature}/data/repositories/`
- [ ] Entities in `features/{feature}/domain/entities/`
- [ ] Core providers in `core/network/`, `core/storage/`, `core/services/`

#### Anti-Patterns to Flag
```dart
// WRONG: Import between features
import 'package:app/features/wallets/presentation/providers/wallet_provider.dart';

// WRONG: API calls in screens or providers
await ref.read(dioProvider).get('/users');

// WRONG: All layers for simple feature
features/dashboard/domain/usecases/...  // Dashboard just displays data

// CORRECT: Use core for shared state
import 'package:app/core/services/auth_service.dart';

// CORRECT: Go through repository
final data = await ref.read({feature}RepositoryProvider).getAll();
```

### 2. State Management (Riverpod 3.x)

#### Provider/Notifier Pattern
- [ ] Uses `@riverpod` annotation with code generation
- [ ] Notifiers extend generated `_${Feature}Notifier`
- [ ] UI state uses Freezed `abstract class` syntax
- [ ] Uses `state.value` with fallback (Riverpod 3.x — NOT `valueOrNull`)
- [ ] Action methods return `bool` for UI feedback
- [ ] Uses `ref.read()` for repositories in action methods
- [ ] Uses `ref.watch()` for reactive dependencies in `build()`

#### Correct Pattern
```dart
@riverpod
class SwapNotifier extends _$SwapNotifier {
  @override
  Future<SwapState> build() async {
    return const SwapState();
  }

  Future<bool> fetchQuote() async {
    final current = state.value ?? const SwapState();
    state = AsyncData(current.copyWith(isLoading: true, error: null));

    try {
      final quote = await ref.read(swapRepositoryProvider).getQuote();
      state = AsyncData(current.copyWith(quote: quote, isLoading: false));
      return true;
    } catch (e) {
      state = AsyncData(current.copyWith(error: e.toString(), isLoading: false));
      return false;
    }
  }
}
```

#### Forbidden Patterns
```dart
// WRONG: state.value! (crashes if null)
state = AsyncData(state.value!.copyWith(...));

// WRONG: valueOrNull (Riverpod 2.x)
final current = state.valueOrNull ?? const SwapState();

// WRONG: void return (no UI feedback)
Future<void> doAction() async { }

// WRONG: keepAlive on feature provider
@Riverpod(keepAlive: true)
class SwapNotifier extends _$SwapNotifier { }
```

### 3. Repository + Datasource Pattern

#### Datasource
- [ ] Located in `features/{feature}/data/datasources/`
- [ ] Uses Dio via `ref.watch(dioProvider)`
- [ ] Returns Model DTOs
- [ ] Method names: `fetch*`, `post*`, `put*`, `delete*`

#### Repository
- [ ] Interface in `features/{feature}/domain/repositories/`
- [ ] Implementation in `features/{feature}/data/repositories/`
- [ ] Maps DTOs to domain entities
- [ ] Method names: `get*`, `create*`, `update*`, `delete*`
- [ ] Provider returns abstract interface type

### 4. Provider Lifetime (keepAlive)

| Provider | keepAlive | Reason |
|----------|-----------|--------|
| Dio, SecureStorage, AuthService | Yes | Core infrastructure |
| Feature notifiers | No | Reload on navigation |
| Repositories, Datasources | No | Stateless per-use |

### 5. UI Styling & Assets (CRITICAL)

- [ ] **NO raw colors** — use `AppColors` only
- [ ] **NO inline TextStyle** — use `AppTextStyles` only
- [ ] **NO hardcoded strings** — use `context.l10n.keyName`
- [ ] **NO hardcoded asset strings** — use defined asset constants
- [ ] ScreenUtil extensions used correctly (`.w`, `.h`, `.sp`, `.r`)
- [ ] `const` constructors where possible for performance

### 6. Security & Data

- [ ] Tokens/credentials in `flutter_secure_storage` (NEVER SharedPreferences)
- [ ] BigInt for token amounts (NEVER floating-point)
- [ ] No sensitive data in logs
- [ ] HTTPS for all API calls
- [ ] 401 response handling (clear credentials, redirect to `/connect`)

### 7. Code Quality

- [ ] UI files under 200-250 lines
- [ ] Functions under 30-50 lines, single-purpose
- [ ] Minimal nesting (max 3 levels)
- [ ] Const constructors used where possible
- [ ] No unnecessary rebuilds
- [ ] ListView builders for long lists
- [ ] Descriptive names for variables, functions, classes

### 8. Localization

- [ ] All user-facing text uses `context.l10n`
- [ ] Keys added to both `app_en.arb` and `app_es.arb`
- [ ] Import `l10n_extension.dart` present
- [ ] Parameterized strings for dynamic content

## Review Process

### 1. High-Level Assessment
- What is the purpose of this change?
- What is the scope and impact?
- Are there any architectural changes?

### 2. Review Order
1. Data layer (models, datasources, repositories)
2. Domain layer (entities, repository interfaces)
3. Presentation layer (providers/notifiers, screens, widgets)
4. Routing and navigation
5. Core utilities

### 3. For Each Finding

Provide:
- **Location**: File path and line numbers
- **Issue**: Quote the specific code
- **Explanation**: Why this is a problem
- **Impact**: How it affects users/system/team
- **Fix**: Concrete solution with code example
- **Category**: Critical / Suggestion / Praise

### 4. Summary

End each review with:
- **Findings Count**: X Critical, Y Suggestions, Z Praise
- **Overall Assessment**: Brief summary of code quality
- **Merge Recommendation**:
  - Ready to merge
  - Needs changes (specify what must be fixed)
  - Needs discussion (flag complex decisions)

## Critical Rules (Must Follow)

1. **Feature-First Clean Architecture** — presentation → domain → data
2. **NO cross-feature imports** — use core for shared state
3. **NO raw colors** — use `AppColors`
4. **NO inline styles** — use `AppTextStyles`
5. **NO hardcoded strings** — use `context.l10n`
6. **NO `state.value!`** — use `state.value ?? fallback` (Riverpod 3.x)
7. **NO direct Dio in providers** — use repositories
8. **NO SharedPreferences for tokens** — use `flutter_secure_storage`
9. **NO floating-point for token amounts** — use `BigInt`
10. **NO `keepAlive` on feature providers** — only for core infrastructure
