import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/features/workout/data/models/workout_log_model.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({super.key, required this.entry, this.onTap});
  final WorkoutEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final exerciseNames = entry.exercises.map((e) => e.name).take(4).join(', ');
    final typeStyle = _getTypeStyle(entry.type);
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Type-colored icon
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(width: 14),
              // Title + exercises
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.day ?? entry.date,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: typeStyle.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entry.type.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: typeStyle.color,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exerciseNames,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    // Stats row
                    Row(
                      children: [
                        Text(
                          '${entry.totalExercises} exercises',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${entry.totalSets} sets',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: AppTheme.textTertiary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  static _TypeStyle _getTypeStyle(String type) {
    return switch (type.toLowerCase()) {
      'cardio' => const _TypeStyle(Icons.directions_run, AppTheme.cardio),
      'flexibility' => const _TypeStyle(
        Icons.self_improvement,
        AppTheme.flexibility,
      ),
      'strength' => const _TypeStyle(
        Icons.fitness_center,
        AppTheme.primaryGreen,
      ),
      _ => const _TypeStyle(Icons.fitness_center, AppTheme.primaryGreen),
    };
  }
}

class _TypeStyle {
  const _TypeStyle(this.icon, this.color);
  final IconData icon;
  final Color color;
}
