import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _workoutsRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('workouts');

  Stream<QuerySnapshot> workoutsStream(String userId) =>
      _workoutsRef(userId).orderBy('date', descending: true).snapshots();

  Future<DocumentSnapshot> getWorkout(String userId, String workoutId) =>
      _workoutsRef(userId).doc(workoutId).get();

  Future<void> deleteWorkout(String userId, String workoutId) =>
      _workoutsRef(userId).doc(workoutId).delete();
}
