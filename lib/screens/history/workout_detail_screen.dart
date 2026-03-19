import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/workout_provider.dart';
import '../../widgets/history/exercise_tile.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(workoutLogsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(date)),
      body: logsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (logs) {
          final log = logs.where((l) => l.id == date).firstOrNull;
          if (log == null) {
            return const Center(child: Text('Workout not found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (log.notes != null) ...[
                Text(
                  log.notes!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                '${log.totalExercises} exercises, ${log.totalSets} sets',
                style: const TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              for (final workout in log.workouts) ...[
                if (workout.day != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      workout.day!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                for (final exercise in workout.exercises)
                  ExerciseTile(exercise: exercise),
                const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}
