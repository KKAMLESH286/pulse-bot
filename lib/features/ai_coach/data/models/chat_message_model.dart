import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String role,
    required String text,
    Map<String, dynamic>? workoutData,
    required String status,
    required DateTime createdAt,
  }) = _ChatMessage;

  const ChatMessage._();

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      role: data['role'] as String? ?? 'user',
      text: data['text'] as String? ?? '',
      workoutData: data['workoutData'] as Map<String, dynamic>?,
      status: data['status'] as String? ?? 'sent',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'role': role,
    'text': text,
    if (workoutData != null) 'workoutData': workoutData,
    'status': status,
    'createdAt': FieldValue.serverTimestamp(),
  };

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isProcessing => status == 'processing';
  bool get hasWorkoutData => workoutData != null;
}
