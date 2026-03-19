import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final exercises = data['exercises'] as List<dynamic>? ?? [];
    final type = data['type'] as String? ?? 'workout';
    final day = data['day'] as String?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.fitness_center,
                  size: 16,
                  color: Color(0xFF4CAF50),
                ),
                const SizedBox(width: 8),
                Text(
                  day ?? type.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            for (final exercise in exercises) ...[
              _buildExerciseRow(exercise as Map<String, dynamic>),
              const SizedBox(height: 4),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseRow(Map<String, dynamic> exercise) {
    final name = exercise['name'] as String? ?? '';
    final sets = exercise['sets'] as List<dynamic>? ?? [];
    final setsStr = sets
        .map((s) {
          final map = s as Map<String, dynamic>;
          return '${map['weight_kg']}kg x ${map['reps']}';
        })
        .join(', ');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            setsStr,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ),
      ],
    );
  }
}
