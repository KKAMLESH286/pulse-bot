import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/workout_log.dart';
import '../services/workout_service.dart';
import 'auth_provider.dart';

part 'workout_provider.g.dart';

@Riverpod(keepAlive: true)
WorkoutService workoutService(Ref ref) {
  return WorkoutService();
}

@riverpod
Stream<List<WorkoutLog>> workoutLogs(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(workoutServiceProvider)
      .workoutLogsStream(user.uid)
      .map((snap) => snap.docs.map(WorkoutLog.fromFirestore).toList());
}
