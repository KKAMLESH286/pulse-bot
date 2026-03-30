import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/ai_coach/data/datasources/coach_remote_datasource.dart';
import 'package:track_me/features/ai_coach/data/models/chat_message_model.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';

part 'chat_provider.g.dart';

/// Pending user message for optimistic display before Firestore confirms.
final pendingMessageProvider = StateProvider<ChatMessage?>((ref) => null);

/// Stream of chat messages from Firestore (real-time updates).
@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(coachRemoteDatasourceProvider).messagesStream(user.uid);
}

/// Combined messages: Firestore stream + pending optimistic message.
/// Deduplicates by checking if pending message text already exists in stream.
@riverpod
List<ChatMessage> allChatMessages(Ref ref) {
  final firestoreMessages = ref.watch(chatMessagesProvider).value ?? [];
  final pending = ref.watch(pendingMessageProvider);

  if (pending == null) return firestoreMessages;

  // Check if Firestore already has this message (dedup)
  final alreadyInStream = firestoreMessages.any(
    (m) => m.isUser && m.text == pending.text && !m.createdAt.isBefore(pending.createdAt),
  );

  if (alreadyInStream) return firestoreMessages;

  return [...firestoreMessages, pending];
}

/// Whether the AI coach is currently processing a message.
@riverpod
bool isChatProcessing(Ref ref) {
  final messages = ref.watch(allChatMessagesProvider);
  if (messages.isEmpty) return false;
  final last = messages.last;
  return last.isUser && (last.status == 'sent' || last.status == 'processing');
}

/// Send a message to the AI coach via Cloud Function.
/// Returns the assistant's response text.
@riverpod
class CoachNotifier extends _$CoachNotifier {
  @override
  bool build() => false; // isSending state

  Future<bool> sendMessage(String message) async {
    if (state) return false; // Already sending
    state = true;

    // Optimistic update: show user message instantly
    final pendingMsg = ChatMessage(
      id: 'pending_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      text: message,
      status: 'sent',
      createdAt: DateTime.now(),
    );
    ref.read(pendingMessageProvider.notifier).state = pendingMsg;

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return false;

      await ref
          .read(coachRemoteDatasourceProvider)
          .sendMessage(user.uid, message);

      return true;
    } catch (e) {
      return false;
    } finally {
      ref.read(pendingMessageProvider.notifier).state = null;
      state = false;
    }
  }
}
