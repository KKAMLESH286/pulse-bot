import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/ai_coach/data/models/chat_message_model.dart';

part 'coach_remote_datasource.g.dart';

@riverpod
CoachRemoteDatasource coachRemoteDatasource(Ref ref) {
  return CoachRemoteDatasource(
    FirebaseFunctions.instance,
    FirebaseFirestore.instance,
  );
}

class CoachRemoteDatasource {
  CoachRemoteDatasource(this._functions, this._firestore);

  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;

  /// Send a message to the AI coach via Cloud Function callable.
  /// The Cloud Function handles the Claude tool loop and persists messages.
  /// Returns the assistant's response text.
  Future<String> sendMessage(String userId, String message) async {
    final callable = _functions.httpsCallable(
      'chat',
      options: HttpsCallableOptions(timeout: const Duration(seconds: 120)),
    );

    final result = await callable.call<Map<String, dynamic>>({
      'message': message,
    });

    return result.data['text'] as String? ?? '';
  }

  /// Stream messages from Firestore for real-time UI updates.
  Stream<List<ChatMessage>> messagesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snap) => snap.docs.map(ChatMessage.fromFirestore).toList());
  }
}
