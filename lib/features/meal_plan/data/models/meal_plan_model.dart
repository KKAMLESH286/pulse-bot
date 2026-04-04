import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_plan_model.freezed.dart';

@freezed
abstract class MealPlanModel with _$MealPlanModel {
  const factory MealPlanModel({
    required String htmlContent,
    required String fileName,
    DateTime? updatedAt,
  }) = _MealPlanModel;

  const MealPlanModel._();

  factory MealPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return MealPlanModel(
      htmlContent: data['htmlContent'] as String? ?? '',
      fileName: data['fileName'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'htmlContent': htmlContent,
    'fileName': fileName,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}
