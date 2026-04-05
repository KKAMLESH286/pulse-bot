import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/features/streak/data/models/workout_stats_model.dart';
import 'package:track_me/features/streak/presentation/providers/streak_provider.dart';

/// Streak display for the custom chat header.
/// Shows: streak + total stats row, and a 7-day week strip below.
class StreakHeader extends ConsumerWidget {
  const StreakHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(workoutStatsProvider);

    return statsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stats) => _StreakHeaderContent(stats: stats),
    );
  }
}

class _StreakHeaderContent extends StatelessWidget {
  const _StreakHeaderContent({required this.stats});
  final WorkoutStats stats;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stats row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatChip(
              icon: Icons.local_fire_department,
              value: stats.currentStreak,
              label: 'streak',
              iconColor: stats.currentStreak > 0
                  ? AppTheme.gold
                  : AppTheme.textTertiary,
              valueColor: stats.currentStreak > 0
                  ? AppTheme.gold
                  : AppTheme.textTertiary,
            ),
            const SizedBox(width: 12),
            _StatChip(
              icon: Icons.emoji_events,
              value: stats.longestStreak,
              label: 'best',
              iconColor: AppTheme.textTertiary,
              valueColor: AppTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            _StatChip(
              icon: Icons.fitness_center,
              value: stats.totalWorkouts,
              label: 'total',
              iconColor: AppTheme.textTertiary,
              valueColor: AppTheme.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Week calendar strip
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(7, (i) {
            final day = weekStart.add(Duration(days: i));
            final hasWorkout = stats.workoutDates.contains(day);
            final isToday = day == today;
            final isFuture = day.isAfter(today);

            return Padding(
              padding: EdgeInsets.only(left: i > 0 ? 4 : 0),
              child: Column(
                children: [
                  Text(
                    _dayLabels[i],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: isToday
                          ? AppTheme.primaryGreen
                          : AppTheme.textTertiary,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasWorkout
                          ? AppTheme.primaryGreen
                          : isFuture
                          ? AppTheme.surfaceBright
                          : AppTheme.surface,
                      border: isToday && !hasWorkout
                          ? Border.all(color: AppTheme.primaryGreen, width: 1.5)
                          : null,
                    ),
                    child: hasWorkout
                        ? const Icon(Icons.check, size: 10, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.valueColor,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color iconColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 3),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
