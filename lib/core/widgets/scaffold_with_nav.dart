import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:track_me/core/routing/route_names.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateIndex(
          GoRouterState.of(context).matchedLocation,
        ),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'PRs'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Program',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith(RouteNames.history)) return 1;
    if (location.startsWith(RouteNames.prs)) return 2;
    if (location.startsWith(RouteNames.program)) return 3;
    if (location.startsWith(RouteNames.profile)) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.chat);
      case 1:
        context.go(RouteNames.history);
      case 2:
        context.go(RouteNames.prs);
      case 3:
        context.go(RouteNames.program);
      case 4:
        context.go(RouteNames.profile);
    }
  }
}
