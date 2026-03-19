import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String role;
  final String text;
  final Map<String, dynamic>? workoutData;
  final String status;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.workoutData,
    required this.status,
    required this.createdAt,
  });

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
