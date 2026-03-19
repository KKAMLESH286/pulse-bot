import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/program_provider.dart';

class ProgramScreen extends ConsumerWidget {
  const ProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programContentProvider);

    return Column(
      children: [
        AppBar(title: const Text('My Program')),
        Expanded(
          child: programAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (content) {
              if (content == null || content.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No program set yet.\n\nAsk your AI coach to create a training program for you!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SizedBox(width: double.infinity, child: Text(content)),
              );
            },
          ),
        ),
      ],
    );
  }
}
