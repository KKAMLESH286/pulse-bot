---
name: create-feature
description: Scaffold a new Flutter feature with Clean Architecture layers (data/domain/presentation). Use when creating a new feature, adding a new module, or setting up feature structure.
---

# Create Feature (Clean Architecture)

Scaffold a new feature following Feature-First Clean Architecture with Riverpod.

## Input

- `$ARGUMENTS` — Feature name in snake_case (e.g., `staking`, `bridge`, `token_list`)

## Steps

### 1. Determine Feature Complexity

Ask the user or infer from context:
- **Simple feature** (display-only): Only needs `presentation/` layer
- **Data feature** (fetches from API): Needs `presentation/` + `data/` layers
- **Complex feature** (business logic): Needs all three layers (`presentation/` + `domain/` + `data/`)

### 2. Create Folder Structure

For a **full feature** (adjust based on complexity):

```
lib/features/{feature_name}/
├── data/
│   ├── models/
│   │   └── {feature_name}_model.dart
│   ├── datasources/
│   │   └── {feature_name}_remote_datasource.dart
│   └── repositories/
│       └── {feature_name}_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── {feature_name}.dart
│   └── repositories/
│       └── {feature_name}_repository.dart
└── presentation/
    ├── providers/
    │   ├── {feature_name}_provider.dart
    │   └── {feature_name}_state.dart
    ├── screens/
    │   └── {feature_name}_screen.dart
    └── widgets/
```

### 3. Create State (Freezed)

```dart
// lib/features/{feature}/presentation/providers/{feature}_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part '{feature}_state.freezed.dart';

@freezed
abstract class {Feature}State with _${Feature}State {
  const factory {Feature}State({
    @Default(false) bool isLoading,
    String? error,
    // Add feature-specific fields
  }) = _{Feature}State;

  const {Feature}State._();

  bool get hasError => error != null && error!.isNotEmpty;

  {Feature}State clearError() => copyWith(error: null);
}
```

### 4. Create Provider/Notifier

```dart
// lib/features/{feature}/presentation/providers/{feature}_provider.dart

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
    final current = state.value ?? const {Feature}State();

    state = AsyncData(current.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      final data = await ref.read({feature}RepositoryProvider).getAll();

      state = AsyncData(current.copyWith(
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

### 5. Create Screen

```dart
// lib/features/{feature}/presentation/screens/{feature}_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../providers/{feature}_provider.dart';

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

  Widget _buildContent({Feature}State uiState) {
    return const Center(child: Text('TODO: Implement'));
  }
}
```

### 6. Create Domain Layer (if needed)

```dart
// lib/features/{feature}/domain/repositories/{feature}_repository.dart

abstract class {Feature}Repository {
  Future<List<{Entity}>> getAll();
  Future<{Entity}> getById(String id);
}
```

### 7. Create Data Layer (if needed)

**Datasource:**
```dart
// lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';

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

**Repository Implementation:**
```dart
// lib/features/{feature}/data/repositories/{feature}_repository_impl.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/{feature}_repository.dart';
import '../datasources/{feature}_remote_datasource.dart';

part '{feature}_repository_impl.g.dart';

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

### 8. Add Localization Keys

Add keys to `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`:

```json
{
  "{feature}Title": "{Feature}",
  "{feature}Subtitle": "...",
  "{feature}Empty": "No data available"
}
```

### 9. Add Route

Add to `lib/core/routing/route_names.dart` and register in `app_router.dart`.

### 10. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Checklist

- [ ] Feature folder created under `lib/features/`
- [ ] Layers added only as needed (presentation always, domain/data when required)
- [ ] State class uses Freezed `abstract class` pattern
- [ ] Provider uses `@riverpod` codegen with `AsyncNotifier`
- [ ] Screen uses `ConsumerStatefulWidget` with `ref.watch()`
- [ ] Repository interface in domain, implementation in data (if applicable)
- [ ] Datasource uses Dio via provider (if applicable)
- [ ] All strings localized via `context.l10n`
- [ ] Route registered in GoRouter
- [ ] Code generation run successfully
- [ ] No cross-feature imports (shared state via core only)
