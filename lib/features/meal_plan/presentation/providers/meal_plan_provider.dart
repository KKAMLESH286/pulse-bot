import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:track_me/core/constants/firestore_constants.dart';
import 'package:track_me/features/auth/presentation/providers/auth_provider.dart';
import 'package:track_me/features/meal_plan/data/datasources/meal_plan_remote_datasource.dart';
import 'package:track_me/features/meal_plan/data/models/meal_plan_model.dart';

part 'meal_plan_provider.g.dart';

@riverpod
Stream<MealPlanModel?> mealPlanStream(Ref ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection(FirestoreConstants.usersCollection)
      .doc(user.uid)
      .collection(FirestoreConstants.mealPlanSubcollection)
      .doc('current')
      .snapshots()
      .map((snap) {
        if (!snap.exists) return null;
        return MealPlanModel.fromFirestore(snap);
      });
}

@riverpod
class MealPlanUploader extends _$MealPlanUploader {
  @override
  FutureOr<void> build() {}

  Future<bool> uploadMealPlan() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return false;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['html', 'htm'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return false;

    final file = result.files.first;
    if (file.bytes == null) return false;

    state = const AsyncLoading();

    try {
      final htmlContent = utf8.decode(file.bytes!, allowMalformed: true);
      final model = MealPlanModel(
        htmlContent: htmlContent,
        fileName: file.name,
      );

      final ds = ref.read(mealPlanRemoteDatasourceProvider);
      await ds.saveMealPlan(user.uid, model);

      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}
