import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:track_me/features/workout/presentation/providers/workout_provider.dart';
import 'package:track_me/features/workout/presentation/widgets/exercise_tile_widget.dart';

class WorkoutDetailScreen extends ConsumerWidget {
  const WorkoutDetailScreen({super.key, required this.date});
  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(workoutEntriesProvider);

    return Scaffold(
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          final entry = entries.where((e) => e.id == date).firstOrNull;
          if (entry == null) {
            return const Center(child: Text('Workout not found'));
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(title: Text(entry.date), pinned: true),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    if (entry.notes != null) ...[
                      Text(
                        entry.notes!,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (entry.day != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          entry.day!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Text(
                      '${entry.totalExercises} exercises, ${entry.totalSets} sets',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final exercise in entry.exercises)
                      ExerciseTile(exercise: exercise),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
