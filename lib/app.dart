import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:track_me/core/routing/app_router.dart';
import 'package:track_me/core/theme/app_theme.dart';

class PulseAIApp extends ConsumerWidget {
  const PulseAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Pulse AI',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
