---
name: create-form
description: Create a form screen with validation, submission handling, and error display. Use when adding login forms, registration forms, profile edit forms, or any multi-field input screens.
---

# Create Form (Clean Architecture)

Creates form screens following project validation patterns with proper error handling and submission flow.

## Input

- `$ARGUMENTS` — Form name and feature context (e.g., `login auth`, `swap settings`, `profile edit`)

## Steps

### 0. Add l10n Keys (MANDATORY - Do This First)

**All form text MUST be localized.** Add these keys before creating the form:

```json
// lib/l10n/app_en.arb
"{formName}Title": "Form Title",
"{formName}Subtitle": "Subtitle text",
"{formName}FieldLabel": "Field Label",
"{formName}FieldHint": "Enter value...",
"{formName}Submit": "Submit",
"validationRequired": "This field is required",
"validationEmail": "Invalid email address",
"validationMinLength": "Must be at least {count} characters",

// lib/l10n/app_es.arb (Spanish translations)
"{formName}Title": "Titulo del Formulario",
"{formName}Subtitle": "Texto de subtitulo",
"{formName}FieldLabel": "Etiqueta del Campo",
"{formName}FieldHint": "Ingrese valor...",
"{formName}Submit": "Enviar",
"validationRequired": "Este campo es obligatorio",
"validationEmail": "Direccion de correo invalida",
"validationMinLength": "Debe tener al menos {count} caracteres"
```

Then regenerate: `flutter gen-l10n`

### 1. Form Screen Structure

Location: `lib/features/{feature}/presentation/screens/{form}_screen.dart`

Forms use `ConsumerStatefulWidget` with:
- `TextEditingController` for each field
- `_submitted` flag for validation timing
- Getter methods for real-time validation
- Loading state from provider

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/{feature}_provider.dart';

class {Form}Screen extends ConsumerStatefulWidget {
  const {Form}Screen({super.key});

  @override
  ConsumerState<{Form}Screen> createState() => _{Form}ScreenState();
}

class _{Form}ScreenState extends ConsumerState<{Form}Screen> {
  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();
  final _field2FocusNode = FocusNode();
  bool _submitted = false;

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    _field2FocusNode.dispose();
    super.dispose();
  }
```

### 2. Validation Pattern

**Validators return localized error messages via `context.l10n`:**

```dart
  String? get _field1Error {
    if (_field1Controller.text.isEmpty) {
      return _submitted ? context.l10n.validationRequired : null;
    }
    return null;
  }

  String? get _emailError {
    final value = _emailController.text;
    if (value.isEmpty) {
      return _submitted ? context.l10n.validationRequired : null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return context.l10n.validationEmail;
    }
    return null;
  }

  bool get _isFormValid => _field1Error == null && _emailError == null;
```

### 3. Submission Handler

```dart
  bool get _isLoading =>
      ref.watch({feature}NotifierProvider).value?.isLoading ?? false;

  Future<void> _handleSubmit() async {
    setState(() => _submitted = true);

    if (!_isFormValid) return;

    final success = await ref
        .read({feature}NotifierProvider.notifier)
        .submitForm(
          field1: _field1Controller.text,
          field2: _field2Controller.text,
        );

    if (!mounted) return;

    if (success) {
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
```

### 4. Field Widget with Error Display

```dart
  Widget _buildField1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _field1Controller,
          decoration: InputDecoration(
            hintText: context.l10n.{formName}FieldHint,
            labelText: context.l10n.{formName}FieldLabel,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _field2FocusNode.requestFocus(),
          onChanged: (_) => setState(() {}),
        ),
        if (_field1Error != null) ...[
          SizedBox(height: 4.h),
          Text(
            _field1Error!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
```

### 5. Submit Button with Loading State

```dart
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        child: _isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(context.l10n.{formName}Submit),
      ),
    );
  }
```

### 6. Full Build Method

```dart
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.{formName}Title),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),
                      _buildField1(),
                      SizedBox(height: 16.h),
                      _buildField2(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  22.w,
                  16.h,
                  22.w,
                  34.h + MediaQuery.of(context).padding.bottom,
                ),
                child: _buildSubmitButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Key Patterns Summary

| Pattern | Implementation |
|---------|----------------|
| Validation timing | `_submitted` flag — show errors only after first submit |
| Real-time feedback | `onChanged: (_) => setState(() {})` on each field |
| Validation logic | Getter methods returning `context.l10n` error strings |
| Loading state | `ref.watch({feature}NotifierProvider).value?.isLoading ?? false` |
| Submit action | `ref.read({feature}NotifierProvider.notifier).action()` |
| Error display | Check `state.value?.hasError` and show snackbar |
| Keyboard dismiss | Wrap in `GestureDetector` with `FocusScope.of(context).unfocus()` |

## Checklist

- [ ] Form screen in `lib/features/{feature}/presentation/screens/`
- [ ] All strings localized via `context.l10n`
- [ ] L10n keys added to both ARB files
- [ ] Validation getters with `_submitted` flag pattern
- [ ] Loading state from provider via `ref.watch()`
- [ ] Submit action via `ref.read().notifier`
- [ ] `mounted` check after async operations
- [ ] Error display via SnackBar
- [ ] Uses `AppColors`, `AppTextStyles`, ScreenUtil
- [ ] Keyboard dismissal on tap outside
