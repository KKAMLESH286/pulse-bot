import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/workout/data/models/workout_log_model.dart';
import 'package:track_me/features/workout/data/services/workout_service.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';

part 'workout_provider.g.dart';

@Riverpod(keepAlive: true)
WorkoutService workoutService(Ref ref) {
  return WorkoutService();
}

@riverpod
Stream<List<WorkoutEntry>> workoutEntries(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(workoutServiceProvider)
      .workoutsStream(user.uid)
      .map((snap) => snap.docs.map(WorkoutEntry.fromFirestore).toList());
}
