import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/features/profile/data/models/user_profile_model.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';

part 'user_profile_provider.g.dart';

@riverpod
Stream<UserProfile?> userProfile(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
}
