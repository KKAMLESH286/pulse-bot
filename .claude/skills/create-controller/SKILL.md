---
name: create-controller
description: Create a Riverpod provider/notifier with proper error handling and UI state management. Use when adding state management, creating providers, or setting up feature state.
---

# Create Provider/Notifier (Clean Architecture)

Create a Riverpod `AsyncNotifier` with Freezed state following the project's Clean Architecture pattern.

## Input

- `$ARGUMENTS` — Provider name and feature context (e.g., `swap`, `dashboard settings`)

## Steps

### 1. Create State Class (Freezed)

Location: `lib/features/{feature}/presentation/providers/{feature}_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{feature}_state.freezed.dart';

@freezed
abstract class {Feature}State with _${Feature}State {
  const factory {Feature}State({
    @Default(false) bool isLoading,
    String? error,
    // Add feature-specific fields with defaults
  }) = _{Feature}State;

  const {Feature}State._();

  bool get hasError => error != null && error!.isNotEmpty;
  // Add computed properties

  {Feature}State clearError() => copyWith(error: null);
}
```

### 2. Create Notifier

Location: `lib/features/{feature}/presentation/providers/{feature}_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

## Rules

### DO:
- Use `state.value` with `?? const {Feature}State()` fallback (Riverpod 3.x)
- Return `bool` from action methods for UI feedback
- Use `ref.read()` for repositories/datasources in action methods
- Clear errors before starting new operations
- Use `@riverpod` codegen (NOT `@Riverpod(keepAlive: true)` for feature providers)

### DON'T:
- Use `state.value!` (crashes if state not initialized)
- Use `state.valueOrNull` (Riverpod 2.x pattern — use `state.value` in 3.x)
- Return `void` from action methods (use `bool` for feedback)
- Use `@Riverpod(keepAlive: true)` on feature providers (only for core infra)
- Put API calls directly in the notifier (go through repository)

## Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Checklist

- [ ] State class uses Freezed `abstract class` with `_$` mixin
- [ ] State has `isLoading`, `error`, and feature-specific fields
- [ ] State has `hasError` getter and `clearError()` method
- [ ] Notifier uses `@riverpod` codegen
- [ ] Notifier extends `_${Feature}Notifier` (generated)
- [ ] `build()` returns initial state
- [ ] Action methods return `Future<bool>`
- [ ] State access uses `state.value ?? const {Feature}State()`
- [ ] Repositories accessed via `ref.read()`
- [ ] Code generation run successfully
