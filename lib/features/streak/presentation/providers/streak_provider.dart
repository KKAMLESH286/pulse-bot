import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:track_me/features/streak/data/datasources/streak_datasource.dart';
import 'package:track_me/features/streak/data/models/workout_stats_model.dart';

part 'streak_provider.g.dart';

@riverpod
Stream<WorkoutStats> workoutStats(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const WorkoutStats());

  return ref
      .watch(streakDatasourceProvider)
      .workoutDatesStream(user.uid)
      .map(_computeStats);
}

WorkoutStats _computeStats(List<String> dateStrings) {
  // Parse and deduplicate dates (normalize to date-only)
  final dates =
      dateStrings
          .map(DateTime.tryParse)
          .whereType<DateTime>()
          .map((d) => DateTime(d.year, d.month, d.day))
          .toSet()
          .toList()
        ..sort((a, b) => b.compareTo(a)); // newest first

  if (dates.isEmpty) return const WorkoutStats();

  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  // Current streak: consecutive days backward from today (or yesterday)
  int currentStreak = 0;
  var checkDate = today;

  // If no workout today, start checking from yesterday
  // (user hasn't worked out yet today — don't break their streak)
  if (!dates.contains(today)) {
    checkDate = today.subtract(const Duration(days: 1));
  }

  for (final date in dates) {
    if (date == checkDate) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else if (date.isBefore(checkDate)) {
      break;
    }
  }

  // Longest streak: max consecutive-day span
  final sorted = dates.toList()..sort(); // oldest first
  int longestStreak = 0;
  int tempStreak = 1;
  for (int i = 1; i < sorted.length; i++) {
    if (sorted[i].difference(sorted[i - 1]).inDays == 1) {
      tempStreak++;
    } else {
      longestStreak = max(longestStreak, tempStreak);
      tempStreak = 1;
    }
  }
  longestStreak = max(longestStreak, tempStreak);

  // This week count (Mon–Sun)
  final weekStart = today.subtract(Duration(days: today.weekday - 1));
  final thisWeekCount = dates
      .where((d) => !d.isBefore(weekStart) && !d.isAfter(today))
      .length;

  return WorkoutStats(
    currentStreak: currentStreak,
    longestStreak: longestStreak,
    thisWeekCount: thisWeekCount,
    totalWorkouts: dateStrings.length,
    workoutDates: dates.toSet(),
  );
}
