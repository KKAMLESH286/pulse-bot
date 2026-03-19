import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseSet {
  final double weightKg;
  final int reps;

  const ExerciseSet({required this.weightKg, required this.reps});

  factory ExerciseSet.fromMap(Map<String, dynamic> map) => ExerciseSet(
    weightKg: (map['weight_kg'] as num?)?.toDouble() ?? 0,
    reps: (map['reps'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {'weight_kg': weightKg, 'reps': reps};

  String get display => '${weightKg}kg x $reps';
}

class Exercise {
  final String name;
  final List<ExerciseSet> sets;
  final String? note;

  const Exercise({required this.name, required this.sets, this.note});

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

class Workout {
  final String? time;
  final String type;
  final String? day;
  final List<Exercise> exercises;

  const Workout({
    this.time,
    required this.type,
    this.day,
    required this.exercises,
  });

  factory Workout.fromMap(Map<String, dynamic> map) => Workout(
    time: map['time'] as String?,
    type: map['type'] as String? ?? 'strength',
    day: map['day'] as String?,
    exercises:
        (map['exercises'] as List<dynamic>?)
            ?.map((e) => Exercise.fromMap(e as Map<String, dynamic>))
            .toList() ??
        [],
  );

  Map<String, dynamic> toMap() => {
    if (time != null) 'time': time,
    'type': type,
    if (day != null) 'day': day,
    'exercises': exercises.map((e) => e.toMap()).toList(),
  };
}

class WorkoutLog {
  final String id;
  final String date;
  final String? notes;
  final List<Workout> workouts;

  const WorkoutLog({
    required this.id,
    required this.date,
    this.notes,
    required this.workouts,
  });

  factory WorkoutLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkoutLog(
      id: doc.id,
      date: data['date'] as String? ?? doc.id,
      notes: data['notes'] as String?,
      workouts:
          (data['workouts'] as List<dynamic>?)
              ?.map((w) => Workout.fromMap(w as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() => {
    'date': date,
    if (notes != null) 'notes': notes,
    'workouts': workouts.map((w) => w.toMap()).toList(),
  };

  int get totalExercises =>
      workouts.fold(0, (total, w) => total + w.exercises.length);

  int get totalSets => workouts.fold(
    0,
    (total, w) => total + w.exercises.fold(0, (c, e) => c + e.sets.length),
  );
}
