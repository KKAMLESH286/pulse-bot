import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_log_model.freezed.dart';

@freezed
abstract class ExerciseSet with _$ExerciseSet {
  const factory ExerciseSet({required double weightKg, required int reps}) =
      _ExerciseSet;

  const ExerciseSet._();

  factory ExerciseSet.fromMap(Map<String, dynamic> map) => ExerciseSet(
    weightKg: (map['weight_kg'] as num?)?.toDouble() ?? 0,
    reps: (map['reps'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {'weight_kg': weightKg, 'reps': reps};

  String get display => '${weightKg}kg x $reps';
}

@freezed
abstract class Exercise with _$Exercise {
  const factory Exercise({
    required String name,
    required List<ExerciseSet> sets,
    String? note,
  }) = _Exercise;

  const Exercise._();

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
    name: map['name'] as String? ?? '',
    sets:
        (map['sets'] as List<dynamic>?)
            ?.map((s) => ExerciseSet.fromMap(s as Map<String, dynamic>))
            .toList() ??
        [],
    note: map['note'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'sets': sets.map((s) => s.toMap()).toList(),
    if (note != null) 'note': note,
  };
}

/// A single workout session stored as an individual Firestore document.
///
/// Schema: users/{userId}/workouts/{workoutId}
/// Each document represents one workout session (not grouped by date).
/// The `embedding` field is written by the Cloud Function embedding pipeline.
@freezed
abstract class WorkoutEntry with _$WorkoutEntry {
  const factory WorkoutEntry({
    required String id,
    required String date,
    required String type,
    String? day,
    String? notes,
    required List<Exercise> exercises,
    DateTime? createdAt,
  }) = _WorkoutEntry;

  const WorkoutEntry._();

  factory WorkoutEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutEntry(
      id: doc.id,
      date: data['date'] as String? ?? '',
      type: data['type'] as String? ?? 'strength',
      day: data['day'] as String?,
      notes: data['notes'] as String?,
      exercises:
          (data['exercises'] as List<dynamic>?)
              ?.map((e) => Exercise.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'date': date,
    'type': type,
    if (day != null) 'day': day,
    if (notes != null) 'notes': notes,
    'exercises': exercises.map((e) => e.toMap()).toList(),
    'createdAt': FieldValue.serverTimestamp(),
  };

  int get totalExercises => exercises.length;

  int get totalSets => exercises.fold(0, (total, e) => total + e.sets.length);
}
