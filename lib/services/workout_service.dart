import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _workoutLogsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('workout_logs');

  Stream<QuerySnapshot> workoutLogsStream(String userId) =>
      _workoutLogsRef(userId).orderBy('date', descending: true).snapshots();

  Future<DocumentSnapshot> getWorkoutLog(String userId, String date) =>
      _workoutLogsRef(userId).doc(date).get();
}
