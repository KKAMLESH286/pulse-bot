import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalRecord {
  final String id;
  final String exerciseName;
  final double weightKg;
  final int reps;
  final DateTime date;
  final String? note;

  const PersonalRecord({
    required this.id,
    required this.exerciseName,
    required this.weightKg,
    required this.reps,
    required this.date,
    this.note,
  });

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
