import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'streak_datasource.g.dart';

@riverpod
StreakDatasource streakDatasource(Ref ref) {
  return StreakDatasource(FirebaseFirestore.instance);
}

class StreakDatasource {
  StreakDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  /// Streams all workout date strings for the user, ordered descending.
  Stream<List<String>> workoutDatesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => doc.data()['date'] as String? ?? '')
              .where((d) => d.isNotEmpty)
              .toList(),
        );
  }
}
