import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_stats_model.freezed.dart';

@freezed
abstract class WorkoutStats with _$WorkoutStats {
  const factory WorkoutStats({
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int thisWeekCount,
    @Default(0) int totalWorkouts,
    @Default({}) Set<DateTime> workoutDates,
  }) = _WorkoutStats;
}
