import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:track_me/core/theme/app_theme.dart';
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
              SliverAppBar(
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(entry.day ?? entry.date),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryGreenDark.withValues(alpha: 0.3),
                          AppTheme.surface,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList.list(
                  children: [
                    if (entry.notes != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardHighlight,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: AppTheme.primaryGreen.withValues(
                                alpha: 0.5,
                              ),
                              width: 3,
                            ),
                          ),
                        ),
                        child: Text(
                          entry.notes!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Summary chips
                    Row(
                      children: [
                        _SummaryChip(
                          label: '${entry.totalExercises} exercises',
                          color: AppTheme.primaryGreen,
                        ),
                        const SizedBox(width: 8),
                        _SummaryChip(
                          label: '${entry.totalSets} sets',
                          color: AppTheme.textSecondary,
                        ),
                        if (entry.type.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _SummaryChip(
                            label: entry.type,
                            color: AppTheme.primaryGreen,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < entry.exercises.length; i++)
                      ExerciseTile(exercise: entry.exercises[i], index: i + 1)
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: i * 60),
                            duration: 300.ms,
                          )
                          .slideY(
                            begin: 0.05,
                            end: 0,
                            delay: Duration(milliseconds: i * 60),
                            duration: 300.ms,
                          ),
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

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
