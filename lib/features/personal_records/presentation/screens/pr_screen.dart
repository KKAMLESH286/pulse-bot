import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/core/widgets/empty_state_widget.dart';
import 'package:track_me/features/personal_records/presentation/providers/pr_provider.dart';

class PRScreen extends ConsumerWidget {
  const PRScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prsAsync = ref.watch(personalRecordsProvider);

    return Column(
      children: [
        AppBar(title: const Text('Personal Records')),
        Expanded(
          child: prsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (prs) {
              if (prs.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.emoji_events,
                  iconGradient: AppTheme.goldGradient,
                  title: 'No records yet',
                  subtitle:
                      'Your personal bests will appear here automatically',
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.1,
                ),
                itemCount: prs.length,
                itemBuilder: (context, index) {
                  final pr = prs[index];
                  final theme = Theme.of(context);

                  return Card(
                        margin: EdgeInsets.zero,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gold gradient top strip
                              Container(
                                height: 3,
                                decoration: const BoxDecoration(
                                  gradient: AppTheme.goldGradient,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Gradient trophy
                                      ShaderMask(
                                            shaderCallback: (bounds) => AppTheme
                                                .goldGradient
                                                .createShader(bounds),
                                            child: const Icon(
                                              Icons.emoji_events,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          )
                                          .animate(
                                            onPlay: (c) => c.repeat(
                                              reverse: true,
                                              period: 3.seconds,
                                            ),
                                          )
                                          .shimmer(
                                            duration: 1500.ms,
                                            color: AppTheme.gold.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                      const SizedBox(height: 8),
                                      Text(
                                        pr.exerciseName.replaceAll('_', ' '),
                                        style: theme.textTheme.titleSmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      // Hero weight
                                      Text(
                                        pr.display,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: AppTheme.primaryGreen,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat.yMMMd().format(pr.date),
                                        style: theme.textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: index * 80),
                        duration: 300.ms,
                      )
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                        delay: Duration(milliseconds: index * 80),
                        duration: 300.ms,
                      );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
