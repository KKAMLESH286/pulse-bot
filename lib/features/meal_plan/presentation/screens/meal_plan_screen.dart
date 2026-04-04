import 'dart:convert';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:web/web.dart' as web;

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/core/widgets/empty_state_widget.dart';
import '../providers/meal_plan_provider.dart';

class MealPlanScreen extends ConsumerStatefulWidget {
  const MealPlanScreen({super.key});

  @override
  ConsumerState<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends ConsumerState<MealPlanScreen> {
  String? _currentViewType;
  String? _loadedHtml;

  void _ensureIframe(String htmlContent) {
    if (_loadedHtml == htmlContent) return;
    _loadedHtml = htmlContent;

    final viewType = 'meal-plan-${DateTime.now().millisecondsSinceEpoch}';
    _currentViewType = viewType;

    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final dataUrl =
          'data:text/html;charset=utf-8;base64,${base64Encode(utf8.encode(htmlContent))}';

      final iframe =
          web.document.createElement('iframe') as web.HTMLIFrameElement
            ..src = dataUrl
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';

      return iframe;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanAsync = ref.watch(mealPlanStreamProvider);
    final uploaderState = ref.watch(mealPlanUploaderProvider);

    return Column(
      children: [
        AppBar(
          title: const Text('Meal Plan'),
          actions: [
            if (mealPlanAsync.value != null)
              IconButton(
                icon: const Icon(Icons.upload_file),
                tooltip: 'Replace meal plan',
                onPressed: uploaderState.isLoading
                    ? null
                    : () => _handleUpload(),
              ),
          ],
        ),
        if (uploaderState.isLoading)
          const LinearProgressIndicator(color: AppTheme.primaryGreen),
        Expanded(
          child: mealPlanAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (mealPlan) {
              if (mealPlan == null || mealPlan.htmlContent.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.restaurant_menu,
                  iconGradient: AppTheme.primaryGradient,
                  title: 'No meal plan yet',
                  subtitle: 'Upload an HTML meal plan file to get started',
                  actionLabel: 'Upload Meal Plan',
                  onAction: uploaderState.isLoading
                      ? null
                      : () => _handleUpload(),
                );
              }

              _ensureIframe(mealPlan.htmlContent);

              return Column(
                children: [
                  _buildHeader(mealPlan.fileName, mealPlan.updatedAt),
                  Expanded(
                    child: _currentViewType != null
                        ? HtmlElementView(viewType: _currentViewType!)
                        : const SizedBox.shrink(),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String fileName, DateTime? updatedAt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.surfaceBright, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            size: 16,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (updatedAt != null)
            Text(
              timeago.format(updatedAt),
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleUpload() async {
    final success = await ref
        .read(mealPlanUploaderProvider.notifier)
        .uploadMealPlan();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Meal plan uploaded' : 'Upload cancelled or failed',
        ),
        backgroundColor: success ? AppTheme.primaryGreen : AppTheme.error,
      ),
    );
  }
}
