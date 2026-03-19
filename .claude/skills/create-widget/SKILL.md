---
name: create-widget
description: Create a Flutter widget following project guidelines with proper styling and placement. Use when creating new widgets, UI components, buttons, or input fields.
---

# Create Widget (Clean Architecture)

Create a widget following the project's Feature-First Clean Architecture guidelines.

## Input

- `$ARGUMENTS` — Widget name and context (e.g., `token card`, `swap button`, `balance header`)

## Steps

### 1. Determine Placement

- **Feature-specific widget**: `lib/features/{feature}/presentation/widgets/{widget_name}_widget.dart`
- **Shared/reusable widget**: `lib/core/widgets/{widget_name}_widget.dart`

### 2. Create Widget

#### Stateless Widget (default)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class {WidgetName}Widget extends StatelessWidget {
  const {WidgetName}Widget({
    super.key,
    // Required parameters first
    // Optional parameters with defaults
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // TODO: implement
  }
}
```

#### Consumer Widget (needs provider access)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class {WidgetName}Widget extends ConsumerWidget {
  const {WidgetName}Widget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({feature}NotifierProvider);

    return state.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data: (uiState) => _buildContent(context, uiState),
    );
  }

  Widget _buildContent(BuildContext context, {Feature}State uiState) {
    return const SizedBox.shrink(); // TODO: implement
  }
}
```

## Rules

### Style Rules (CRITICAL)
- **NO raw colors** — use `AppColors` only
- **NO inline TextStyle** — use `AppTextStyles` only
- **NO hardcoded asset strings** — use defined asset constants
- ScreenUtil extensions used correctly (`.w`, `.h`, `.sp`, `.r`)
- `const` constructors where possible for performance
- All visible text uses `context.l10n.keyName`

### Widget Design
- Keep widgets focused — one responsibility per widget
- Use callbacks for actions (e.g., `onTap`, `onChanged`)
- Accept data via constructor, not by reading providers directly (unless it's a top-level consumer widget)
- Prefer composition over inheritance

### Placement Rules
- Widget used by only one feature → `lib/features/{feature}/presentation/widgets/`
- Widget used across features → `lib/core/widgets/`
- Never import widgets from one feature into another

## Checklist

- [ ] Widget placed in correct location (feature or core)
- [ ] Uses `AppColors` and `AppTextStyles` — no raw colors or inline styles
- [ ] All text localized via `context.l10n`
- [ ] ScreenUtil extensions used (`.w`, `.h`, `.sp`, `.r`)
- [ ] `const` constructors used where possible
- [ ] No business logic in widget
- [ ] No cross-feature imports
