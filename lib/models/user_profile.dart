import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String? name;
  final String? timezone;
  final String? goals;
  final double? weightKg;
  final double? heightCm;
  final String? level;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.uid,
    this.name,
    this.timezone,
    this.goals,
    this.weightKg,
    this.heightCm,
    this.level,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfile(
      uid: doc.id,
      name: data['name'] as String?,
      timezone: data['timezone'] as String?,
      goals: data['goals'] as String?,
      weightKg: (data['weight_kg'] as num?)?.toDouble(),
      heightCm: (data['height_cm'] as num?)?.toDouble(),
      level: data['level'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    if (name != null) 'name': name,
    if (timezone != null) 'timezone': timezone,
    if (goals != null) 'goals': goals,
    if (weightKg != null) 'weight_kg': weightKg,
    if (heightCm != null) 'height_cm': heightCm,
    if (level != null) 'level': level,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  UserProfile copyWith({
    String? name,
    String? timezone,
    String? goals,
    double? weightKg,
    double? heightCm,
    String? level,
  }) => UserProfile(
    uid: uid,
    name: name ?? this.name,
    timezone: timezone ?? this.timezone,
    goals: goals ?? this.goals,
    weightKg: weightKg ?? this.weightKg,
    heightCm: heightCm ?? this.heightCm,
    level: level ?? this.level,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
