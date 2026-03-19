import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/features/workout/data/models/workout_log_model.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.exercise, this.index});
  final Exercise exercise;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Numbered circle
                if (index != null)
                  Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                if (index == null)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.fitness_center,
                      size: 16,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                Expanded(
                  child: Text(exercise.name, style: theme.textTheme.titleSmall),
                ),
                Text(
                  '${exercise.sets.length} sets',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Set rows
            for (int i = 0; i < exercise.sets.length; i++)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: i.isEven ? AppTheme.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${i + 1}.',
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                    Text(
                      '${exercise.sets[i].weightKg}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(' kg ', style: theme.textTheme.labelSmall),
                    const Text('x '),
                    Text(
                      '${exercise.sets[i].reps}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(' reps', style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
            // Notes callout
            if (exercise.note != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cardHighlight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border(
                    left: BorderSide(
                      color: AppTheme.primaryGreen.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  exercise.note!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
