import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';
import 'auth_provider.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true)
ChatService chatService(Ref ref) {
  return ChatService();
}

@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref
      .watch(chatServiceProvider)
      .messagesStream(user.uid)
      .map((snap) => snap.docs.map(ChatMessage.fromFirestore).toList());
}

@riverpod
bool isChatProcessing(Ref ref) {
  final messages = ref.watch(chatMessagesProvider).value ?? [];
  if (messages.isEmpty) return false;
  final last = messages.last;
  return last.isUser && (last.status == 'sent' || last.status == 'processing');
}
