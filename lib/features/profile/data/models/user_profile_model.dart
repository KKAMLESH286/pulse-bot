import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    String? name,
    String? timezone,
    String? goals,
    double? weightKg,
    double? heightCm,
    String? level,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserProfile;

  const UserProfile._();

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
}
