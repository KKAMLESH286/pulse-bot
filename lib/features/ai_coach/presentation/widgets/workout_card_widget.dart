import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final exercises = data['exercises'] as List<dynamic>? ?? [];
    final type = data['type'] as String? ?? 'workout';
    final day = data['day'] as String?;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green gradient left border
            Container(
              width: 4,
              constraints: const BoxConstraints(minHeight: 60),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            size: 14,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          day ?? type.toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Exercise rows
                    for (int i = 0; i < exercises.length; i++)
                      _buildExerciseRow(
                        context,
                        exercises[i] as Map<String, dynamic>,
                        i.isEven,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseRow(
    BuildContext context,
    Map<String, dynamic> exercise,
    bool isEven,
  ) {
    final name = exercise['name'] as String? ?? '';
    final sets = exercise['sets'] as List<dynamic>? ?? [];
    final setsStr = sets
        .map((s) {
          final map = s as Map<String, dynamic>;
          return '${map['weight_kg']}kg x ${map['reps']}';
        })
        .join(', ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isEven ? AppTheme.surfaceLight : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              setsStr,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
