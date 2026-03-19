---
name: create-model
description: Create Freezed models with JSON serialization per feature. Use when adding API models, DTOs, request bodies, response parsing, or domain entities.
---

# Create Model (Clean Architecture)

Create Freezed model classes following the project's per-feature data model pattern.

## Input

- `$ARGUMENTS` — Model name and feature context (e.g., `token swap`, `staking position`, `wallet balance`)

## Steps

### 1. Determine Model Type

- **Data Model (DTO)**: API response/request model with JSON serialization → `lib/features/{feature}/data/models/{name}_model.dart`
- **Domain Entity**: Core business object (only when it diverges from DTO) → `lib/features/{feature}/domain/entities/{name}.dart`
- **Request Model**: API request body → `lib/features/{feature}/data/models/{name}_request.dart`
- **Response Model**: API response wrapper → `lib/features/{feature}/data/models/{name}_response.dart`

### 2. Create Data Model (DTO)

```dart
// lib/features/{feature}/data/models/{name}_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part '{name}_model.freezed.dart';
part '{name}_model.g.dart';

@freezed
abstract class {Name}Model with _${Name}Model {
  const factory {Name}Model({
    required String id,
    required String name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @Default(false) bool isActive,
  }) = _{Name}Model;

  const {Name}Model._();

  factory {Name}Model.fromJson(Map<String, dynamic> json) =>
      _${Name}ModelFromJson(json);

  /// Convert to domain entity (if entity layer exists)
  {Name} toEntity() => {Name}(
    id: id,
    name: name,
    createdAt: createdAt,
    isActive: isActive,
  );
}
```

### 3. Create Domain Entity (only when it diverges from DTO)

```dart
// lib/features/{feature}/domain/entities/{name}.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part '{name}.freezed.dart';

@freezed
abstract class {Name} with _${Name} {
  const factory {Name}({
    required String id,
    required String name,
    DateTime? createdAt,
    @Default(false) bool isActive,
  }) = _{Name};

  const {Name}._();

  // Domain-specific computed properties
  bool get isNew => createdAt != null &&
      DateTime.now().difference(createdAt!).inDays < 7;
}
```

### 4. Create Request Model (for POST/PUT bodies)

```dart
// lib/features/{feature}/data/models/{name}_request.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part '{name}_request.freezed.dart';
part '{name}_request.g.dart';

@freezed
abstract class {Name}Request with _${Name}Request {
  const factory {Name}Request({
    required String field1,
    required String field2,
  }) = _{Name}Request;

  factory {Name}Request.fromJson(Map<String, dynamic> json) =>
      _${Name}RequestFromJson(json);
}
```

### 5. Run Code Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Rules

- Use Freezed `abstract class` syntax (Freezed 3.x)
- Models live per-feature in `data/models/`, NOT in a centralized `lib/data/models/`
- Use `@JsonKey(name: 'snake_case')` for API fields that differ from Dart camelCase
- Use `@Default(value)` for fields with default values
- Use BigInt for token amounts — never use `double` or `num`
- Add `toEntity()` method on models when a domain entity layer exists
- Domain entities have NO JSON serialization (no `fromJson`/`toJson`)
- Domain entities can have computed properties and business logic helpers
- Add `const` constructor body `const {Name}Model._();` for custom methods

## Token Amount Pattern

```dart
@freezed
abstract class TokenBalanceModel with _$TokenBalanceModel {
  const factory TokenBalanceModel({
    required String address,
    required String symbol,
    required String balance, // Wei as string from API
    required int decimals,
  }) = _TokenBalanceModel;

  const TokenBalanceModel._();

  factory TokenBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$TokenBalanceModelFromJson(json);

  /// Parse balance as BigInt (never floating-point)
  BigInt get balanceWei => BigInt.parse(balance);
}
```

## Checklist

- [ ] Model placed in correct feature directory
- [ ] Uses Freezed `abstract class` syntax
- [ ] JSON serialization via `@freezed` + `json_serializable`
- [ ] `@JsonKey` used for API field name mapping
- [ ] Token amounts use `String` → `BigInt` (never `double`)
- [ ] `toEntity()` method added (if domain entity exists)
- [ ] Domain entities have no JSON serialization
- [ ] Code generation run successfully
