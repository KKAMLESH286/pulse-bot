import 'package:flutter/material.dart';

import 'package:track_me/features/workout/data/models/workout_log_model.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({super.key, required this.entry, this.onTap});
  final WorkoutEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final exerciseNames = entry.exercises.map((e) => e.name).take(4).join(', ');

    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.fitness_center, color: Color(0xFF4CAF50)),
        ),
        title: Text(
          entry.day ?? entry.date,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          exerciseNames,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[500], fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${entry.totalExercises} exercises',
              style: const TextStyle(fontSize: 12, color: Color(0xFF4CAF50)),
            ),
            Text(
              '${entry.totalSets} sets',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
