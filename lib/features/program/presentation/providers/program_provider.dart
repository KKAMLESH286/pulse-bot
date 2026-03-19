import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';

part 'program_provider.g.dart';

@riverpod
Stream<String?> programContent(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('agent_config')
      .doc('program')
      .snapshots()
      .map((snap) => snap.data()?['content'] as String?);
}
