import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:track_me/core/theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconGradient,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final LinearGradient? iconGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child:
            Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIcon(),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (actionLabel != null && onAction != null) ...[
                      const SizedBox(height: 24),
                      FilledButton.tonal(
                        onPressed: onAction,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen.withValues(
                            alpha: 0.15,
                          ),
                          foregroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(actionLabel!),
                      ),
                    ],
                  ],
                )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconWidget = Icon(
      icon,
      size: 72,
      color: iconColor ?? AppTheme.textTertiary,
    );

    if (iconGradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) => iconGradient!.createShader(bounds),
        child: Icon(icon, size: 72, color: Colors.white),
      );
    }

    return iconWidget;
  }
}
