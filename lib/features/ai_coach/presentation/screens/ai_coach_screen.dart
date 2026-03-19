import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return Column(
      children: [
        AppBar(title: const Text('GainBot'), centerTitle: true),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: messagesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (messages) {
                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start logging your workout!',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try: "bench 80kg 3x8"',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
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
                      return MessageBubble(message: messages[reversedIndex]);
                    },
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ChatInput(onSend: _sendMessage),
          ),
        ),
      ],
    );
  }
}
