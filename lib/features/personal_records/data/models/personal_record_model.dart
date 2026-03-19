import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'personal_record_model.freezed.dart';

@freezed
abstract class PersonalRecord with _$PersonalRecord {
  const factory PersonalRecord({
    required String id,
    required String exerciseName,
    required double weightKg,
    required int reps,
    required DateTime date,
    String? note,
  }) = _PersonalRecord;

  const PersonalRecord._();

  factory PersonalRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PersonalRecord(
      id: doc.id,
      exerciseName: doc.id,
      weightKg: (data['weight_kg'] as num?)?.toDouble() ?? 0,
      reps: (data['reps'] as num?)?.toInt() ?? 0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      note: data['note'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'weight_kg': weightKg,
    'reps': reps,
    'date': Timestamp.fromDate(date),
    if (note != null) 'note': note,
  };

  String get display => '${weightKg}kg x $reps reps';
}
