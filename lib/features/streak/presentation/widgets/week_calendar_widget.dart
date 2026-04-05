import 'package:flutter/material.dart';

import 'package:track_me/core/theme/app_theme.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key, required this.workoutDates});

  final Set<DateTime> workoutDates;

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    // Monday of current week
    final weekStart = today.subtract(Duration(days: today.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final hasWorkout = workoutDates.contains(day);
        final isToday = day == today;
        final isFuture = day.isAfter(today);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _dayLabels[i],
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isToday ? AppTheme.primaryGreen : AppTheme.textTertiary,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 6),
            _DayIndicator(
              hasWorkout: hasWorkout,
              isToday: isToday,
              isFuture: isFuture,
            ),
          ],
        );
      }),
    );
  }
}

class _DayIndicator extends StatelessWidget {
  const _DayIndicator({
    required this.hasWorkout,
    required this.isToday,
    required this.isFuture,
  });

  final bool hasWorkout;
  final bool isToday;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    if (hasWorkout) {
      return Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppTheme.primaryGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    }

    if (isToday) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.primaryGreen, width: 2),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isFuture ? AppTheme.surfaceBright : AppTheme.surface,
        shape: BoxShape.circle,
      ),
    );
  }
}
