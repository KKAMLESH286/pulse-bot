import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/core/constants/firestore_constants.dart';
import '../models/meal_plan_model.dart';

part 'meal_plan_remote_datasource.g.dart';

@riverpod
MealPlanRemoteDatasource mealPlanRemoteDatasource(Ref ref) {
  return MealPlanRemoteDatasource(FirebaseFirestore.instance);
}

class MealPlanRemoteDatasource {
  MealPlanRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentReference _docRef(String userId) => _firestore
      .collection(FirestoreConstants.usersCollection)
      .doc(userId)
      .collection(FirestoreConstants.mealPlanSubcollection)
      .doc('current');

  Stream<MealPlanModel?> watchMealPlan(String userId) {
    return _docRef(userId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return MealPlanModel.fromFirestore(snap);
    });
  }

  Future<void> saveMealPlan(String userId, MealPlanModel model) async {
    await _docRef(userId).set(model.toFirestore());
  }
}
