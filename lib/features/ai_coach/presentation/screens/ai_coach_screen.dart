import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:track_me/core/theme/app_theme.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:track_me/features/ai_coach/presentation/providers/chat_provider.dart';
import 'package:track_me/features/ai_coach/presentation/widgets/chat_input_widget.dart';
import 'package:track_me/features/ai_coach/presentation/widgets/message_bubble_widget.dart';
import 'package:track_me/features/ai_coach/presentation/widgets/typing_indicator_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();

  Future<void> _sendMessage(String text) async {
    final success = await ref.read(coachProvider.notifier).sendMessage(text);
    if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to send message')));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider);
    final isProcessing = ref.watch(isChatProcessingProvider);
    final isSending = ref.watch(coachProvider);
    final userPhotoUrl = ref.watch(currentUserProvider)?.photoURL;

    return Column(
      children: [
        // Custom AppBar
        _buildAppBar(context),
        Expanded(
          child: messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (messages) {
              if (messages.isEmpty) {
                return _buildEmptyState(context);
              }

              final itemCount =
                  messages.length + (isProcessing || isSending ? 1 : 0);

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  final reversedIndex = itemCount - 1 - index;
                  if (reversedIndex == messages.length &&
                      (isProcessing || isSending)) {
                    return const TypingIndicator();
                  }
                  return MessageBubble(
                        message: messages[reversedIndex],
                        userPhotoUrl: userPhotoUrl,
                      )
                      .animate()
                      .fadeIn(duration: 200.ms)
                      .slideY(
                        begin: 0.05,
                        end: 0,
                        duration: 200.ms,
                        curve: Curves.easeOut,
                      );
                },
              );
            },
          ),
        ),
        ChatInput(onSend: _sendMessage),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 16,
      centerTitle: false,
      title: Row(
        children: [
          // Bot avatar with online indicator
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/app_icon.png',
                  width: 36,
                  height: 36,
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pulse AI', style: Theme.of(context).textTheme.titleMedium),
              Text('AI Coach', style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bot logo
            Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                        blurRadius: 24,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 80,
                      height: 80,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(height: 20),

            Text(
              "Hey! I'm your AI coach",
              style: theme.textTheme.titleMedium,
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 8),

            Text(
              'Tell me what you trained',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

            const SizedBox(height: 28),

            // Suggestion chips
            Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _SuggestionChip(
                      label: 'Bench press 80kg 3x8',
                      onTap: () => _sendMessage('Bench press 80kg 3x8'),
                    ),
                    _SuggestionChip(
                      label: 'I did legs today',
                      onTap: () => _sendMessage('I did legs today'),
                    ),
                    _SuggestionChip(
                      label: 'Suggest a workout',
                      onTap: () => _sendMessage('Suggest a workout'),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primaryGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
