import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _messagesRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('messages');

  Future<void> sendMessage(String userId, String text) async {
    await _messagesRef(userId).add({
      'role': 'user',
      'text': text,
      'status': 'sent',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> messagesStream(String userId) =>
      _messagesRef(userId).orderBy('createdAt').snapshots();
}
