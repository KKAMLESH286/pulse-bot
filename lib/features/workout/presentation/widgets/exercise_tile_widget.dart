import 'package:flutter/material.dart';

import 'package:track_me/features/workout/data/models/workout_log_model.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({super.key, required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    exercise.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  '${exercise.sets.length} sets',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < exercise.sets.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${i + 1}.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    Text(
                      exercise.sets[i].display,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            if (exercise.note != null) ...[
              const SizedBox(height: 4),
              Text(
                exercise.note!,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
