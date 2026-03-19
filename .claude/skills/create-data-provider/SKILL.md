---
name: create-data-provider
description: Create a repository + datasource following Clean Architecture. Use when adding API integration, creating data sources, or implementing backend communication.
---

# Create Repository + Datasource (Clean Architecture)

Create the data layer for a feature following the Repository + Datasource pattern with Riverpod DI.

## Input

- `$ARGUMENTS` — Feature/entity name (e.g., `swap`, `token`, `staking`)

## Steps

### 1. Create Datasource

Location: `lib/features/{feature}/data/datasources/{feature}_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/{feature}_model.dart';

part '{feature}_remote_datasource.g.dart';

/// Riverpod provider for datasource
@riverpod
{Feature}RemoteDatasource {feature}RemoteDatasource(Ref ref) {
  return {Feature}RemoteDatasource(ref.watch(dioProvider));
}

/// Datasource class for {feature} API calls
class {Feature}RemoteDatasource {
  {Feature}RemoteDatasource(this._dio);

  final Dio _dio;

  Future<List<{Feature}Model>> fetchAll() async {
    final response = await _dio.get('/api/{feature}');
    return (response.data as List)
        .map((json) => {Feature}Model.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<{Feature}Model> fetchById(String id) async {
    final response = await _dio.get('/api/{feature}/$id');
    return {Feature}Model.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> create({Feature}Model model) async {
    await _dio.post('/api/{feature}', data: model.toJson());
  }
}
```

### 2. Create Repository Interface (Domain)

Location: `lib/features/{feature}/domain/repositories/{feature}_repository.dart`

```dart
import '../entities/{entity}.dart';

/// Abstract repository interface — domain layer has no data dependencies
abstract class {Feature}Repository {
  Future<List<{Entity}>> getAll();
  Future<{Entity}> getById(String id);
}
```

### 3. Create Repository Implementation (Data)

Location: `lib/features/{feature}/data/repositories/{feature}_repository_impl.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/{feature}_repository.dart';
import '../../domain/entities/{entity}.dart';
import '../datasources/{feature}_remote_datasource.dart';

part '{feature}_repository_impl.g.dart';

/// Riverpod provider — returns abstract interface type
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

  @override
  Future<{Entity}> getById(String id) async {
    final model = await _datasource.fetchById(id);
    return model.toEntity();
  }
}
```

### 4. Create Model (DTO)

Location: `lib/features/{feature}/data/models/{feature}_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/{entity}.dart';

part '{feature}_model.freezed.dart';
part '{feature}_model.g.dart';

@freezed
abstract class {Feature}Model with _${Feature}Model {
  const factory {Feature}Model({
    required String id,
    // Add fields matching API response
  }) = _{Feature}Model;

  const {Feature}Model._();

  factory {Feature}Model.fromJson(Map<String, dynamic> json) =>
      _${Feature}ModelFromJson(json);

  /// Convert DTO to domain entity
  {Entity} toEntity() => {Entity}(
    id: id,
  );
}
```

### 5. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Rules

- Datasource methods use `fetch`, `post`, `put`, `delete` prefixes
- Repository methods use `get`, `create`, `update`, `delete` prefixes
- Repository provider returns the abstract interface type
- Datasource receives Dio via constructor (injected by Riverpod provider)
- Models (DTOs) have `toEntity()` method for domain conversion
- Use `@riverpod` (NOT `@Riverpod(keepAlive: true)`) for repositories and datasources
- All HTTP calls go through Dio — never use `http` package directly

## Checklist

- [ ] Datasource created in `lib/features/{feature}/data/datasources/`
- [ ] Repository interface in `lib/features/{feature}/domain/repositories/`
- [ ] Repository implementation in `lib/features/{feature}/data/repositories/`
- [ ] Model (DTO) in `lib/features/{feature}/data/models/`
- [ ] Riverpod providers created for datasource and repository
- [ ] Repository provider returns abstract interface type
- [ ] Model has `toEntity()` conversion method
- [ ] Code generation run successfully
