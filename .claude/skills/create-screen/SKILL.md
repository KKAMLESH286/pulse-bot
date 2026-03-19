---
name: create-screen
description: Create a Flutter screen with proper structure, provider integration, and navigation setup. Use when adding new screens, pages, or views to a feature.
---

# Create Screen (Clean Architecture)

Create a screen following the project's Feature-First Clean Architecture with Riverpod integration.

## Input

- `$ARGUMENTS` — Screen name and feature context (e.g., `swap details`, `staking overview`)

## Steps

### 1. Create Screen File

Location: `lib/features/{feature}/presentation/screens/{screen_name}_screen.dart`

#### ConsumerStatefulWidget (default — use when screen has lifecycle needs)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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

  Future<void> _handleAction() async {
    final success = await ref.read({feature}NotifierProvider.notifier).doAction();
    if (success && mounted) {
      context.go(RouteNames.nextScreen);
    } else {
      _showError();
    }
  }

  void _showError() {
    final state = ref.read({feature}NotifierProvider);
    if (state.value?.hasError == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.value!.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch({feature}NotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.{feature}Title),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (uiState) => _buildContent(uiState),
      ),
    );
  }

  Widget _buildContent({Feature}State uiState) {
    if (uiState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return const SizedBox.shrink(); // TODO: implement
  }
}
```

#### ConsumerWidget (use for simple, stateless screens)

```dart
class {Feature}Screen extends ConsumerWidget {
  const {Feature}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({feature}NotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.{feature}Title),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (uiState) => _buildContent(context, uiState),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {Feature}State uiState) {
    return const SizedBox.shrink(); // TODO: implement
  }
}
```

### 2. Add Route

In `lib/core/routing/route_names.dart`:
```dart
static const String {feature} = '/{feature}';
```

In `lib/core/routing/app_router.dart`, register the route.

### 3. Add Localization

Add screen strings to `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`.

### 4. Run Code Generation

```bash
flutter gen-l10n
```

## Rules

- Use `ref.watch()` in `build()` for reactive state
- Use `ref.read()` in callbacks/handlers for actions
- Fetch data in `initState` via `addPostFrameCallback`
- Check `mounted` before navigation after async operations
- All visible text uses `context.l10n.keyName`
- Use `AppColors` and `AppTextStyles` — no raw colors or inline styles
- Use ScreenUtil extensions (`.w`, `.h`, `.sp`, `.r`)
- Use `const` constructors where possible

## Checklist

- [ ] Screen created in `lib/features/{feature}/presentation/screens/`
- [ ] Uses `ConsumerStatefulWidget` or `ConsumerWidget`
- [ ] Provider integrated with `ref.watch()` / `ref.read()`
- [ ] All strings localized via `context.l10n`
- [ ] Route added to GoRouter
- [ ] Error handling via SnackBar or inline error display
- [ ] Uses `AppColors`, `AppTextStyles`, ScreenUtil
- [ ] No business logic in screen — delegated to provider
