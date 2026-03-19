---
name: figma-to-presentation
description: Implement a Flutter screen from a Figma design using Figma MCP. Use when user says "implement screen from Figma", provides a Figma URL, or asks to create UI from a design link.
---

# Figma to Presentation Layer

Converts Figma designs into Flutter presentation layer code following Feature-First Clean Architecture.

## Steps

### Step 1: Parse Figma URL

Extract `fileKey` and `nodeId` from the Figma URL:
- URL format: `https://figma.com/design/{fileKey}/{fileName}?node-id={nodeId}`
- Convert `-` to `:` in nodeId

### Step 2: Fetch Design Context

```
mcp__figma__get_design_context(
  fileKey: "{fileKey}",
  nodeId: "{nodeId}",
  clientLanguages: "dart",
  clientFrameworks: "flutter"
)
```

### Step 3: Identify Feature & Screen Names

Ask user if not clear:
- **Feature name**: e.g., `swap`, `staking`, `dashboard` (for folder structure)
- **Screen name**: e.g., `swap_confirm`, `staking_overview` (for file naming)

### Step 4: Create Screen Structure

Following Feature-First Clean Architecture:

```
lib/features/{feature}/presentation/
├── providers/
│   ├── {feature}_provider.dart
│   └── {feature}_state.dart
├── screens/
│   └── {screen}_screen.dart
└── widgets/
    └── {component}_widget.dart
```

### Step 5: Identify and Add Localization Keys (MANDATORY)

**CRITICAL: NEVER hardcode strings. All user-facing text MUST be localized.**

1. **Identify all strings** from the Figma design (titles, buttons, labels, hints, errors)

2. **Add to English ARB** (`lib/l10n/app_en.arb`):
```json
{
  "{screenName}Title": "Screen Title from Figma",
  "{screenName}Subtitle": "Subtitle text",
  "{screenName}Button": "Button Label"
}
```

3. **Add to Spanish ARB** (`lib/l10n/app_es.arb`)

4. **Regenerate**: `flutter gen-l10n`

### Step 6: Implement the Screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/{feature}_provider.dart';

class {Screen}Screen extends ConsumerStatefulWidget {
  const {Screen}Screen({super.key});

  @override
  ConsumerState<{Screen}Screen> createState() => _{Screen}ScreenState();
}

class _{Screen}ScreenState extends ConsumerState<{Screen}Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Initialize data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ALWAYS use l10n for text - NEVER hardcode
              Text(context.l10n.{screenName}Title, style: AppTextStyles.headingLarge),
              Text(context.l10n.{screenName}Subtitle, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Step 7: Apply Project Styling Rules

#### ALWAYS Use:
| Figma Element | Flutter Implementation |
|---------------|----------------------|
| **Text strings** | `context.l10n.keyName` (NEVER hardcode) |
| **Colors** | `AppColors.colorName` (NEVER `Colors.red`) |
| **Text styles** | `AppTextStyles.styleName` (NEVER inline `TextStyle`) |
| **Icons/Images** | Asset constants |
| **Spacing** | `.w`, `.h` extensions (ScreenUtil) |
| **Font sizes** | `.sp` extension |
| **Border radius** | `.r` extension |

#### Check Existing Shared Widgets First:
Location: `lib/core/widgets/`

### Step 8: Extract Reusable Components

If a component is used multiple times OR screen exceeds 200 lines:

1. Create widget in `lib/features/{feature}/presentation/widgets/`
2. Name it `{component}_widget.dart`
3. Use `StatelessWidget` for pure presentation, `ConsumerWidget` if needs state
4. Extracted widgets must also use l10n and AppColors/AppTextStyles

### Step 9: Document Required Assets (DO NOT DOWNLOAD)

Track assets needed from Figma — present to user at the end:

```
## Required Assets

### Icons → `assets/icons/`
- [ ] `icon_name.svg` - Description

### Images → `assets/images/`
- [ ] `image_name.png` - Description
```

### Step 10: Run Flutter Analyze

```bash
flutter analyze
```

## Checklist

- [ ] Screen in `lib/features/{feature}/presentation/screens/`
- [ ] All text uses `context.l10n` — no hardcoded strings
- [ ] L10n keys added to both ARB files
- [ ] Uses `AppColors` for all colors
- [ ] Uses `AppTextStyles` for all text styles
- [ ] Uses ScreenUtil extensions (`.w`, `.h`, `.sp`, `.r`)
- [ ] Existing shared widgets reused where possible
- [ ] Components extracted if screen > 200 lines
- [ ] Asset placeholders documented
- [ ] Flutter analyze passes

## Related Skills

- **create-controller** — Add Riverpod state management for screen
- **create-widget** — Extract reusable widgets
- **create-screen** — Manual screen creation
- **create-model** — Create models for screen data
