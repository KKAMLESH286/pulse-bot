import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/core/widgets/empty_state_widget.dart';
import 'package:track_me/core/widgets/section_header_widget.dart';
import 'package:track_me/features/workout/data/models/workout_log_model.dart';
import 'package:track_me/features/workout/presentation/providers/workout_provider.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:track_me/features/workout/presentation/widgets/session_tile_widget.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Workout'),
            content: const Text(
              'Are you sure you want to delete this workout log?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(workoutEntriesProvider);

    return Column(
      children: [
        AppBar(title: const Text('Workout History')),
        Expanded(
          child: entriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (entries) {
              if (entries.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.timeline,
                  iconGradient: AppTheme.primaryGradient,
                  title: 'No workouts yet',
                  subtitle: 'Chat with your AI coach to log your first workout',
                  actionLabel: 'Go to Chat',
                  onAction: () => context.go('/chat'),
                );
              }

              final grouped = <String, List<WorkoutEntry>>{};
              for (final entry in entries) {
                grouped.putIfAbsent(entry.date, () => []).add(entry);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: grouped.length,
                itemBuilder: (context, index) {
                  final date = grouped.keys.elementAt(index);
                  final workouts = grouped[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(label: _formatDateHeader(date)),
                      for (int i = 0; i < workouts.length; i++)
                        Dismissible(
                          key: ValueKey(workouts[i].id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (_) => _confirmDelete(context),
                          onDismissed: (_) {
                            final user = ref.read(currentUserProvider);
                            if (user != null) {
                              ref
                                  .read(workoutServiceProvider)
                                  .deleteWorkout(user.uid, workouts[i].id);
                            }
                          },
                          child:
                              SessionTile(
                                    entry: workouts[i],
                                    onTap: () => context.go(
                                      '/history/${workouts[i].id}',
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(milliseconds: i * 50),
                                    duration: 300.ms,
                                  )
                                  .slideX(
                                    begin: 0.03,
                                    end: 0,
                                    delay: Duration(milliseconds: i * 50),
                                    duration: 300.ms,
                                  ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDateHeader(String date) {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
    final diff = today.difference(dateOnly).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return _weekdayName(parsed.weekday);

    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[parsed.month]} ${parsed.day}, ${parsed.year}';
  }

  String _weekdayName(int weekday) {
    const names = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[weekday];
  }
}
