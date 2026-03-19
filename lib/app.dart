import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'config/theme.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/history/workout_detail_screen.dart';
import 'screens/prs/pr_screen.dart';
import 'screens/profile/profile_screen.dart';

class GainBotApp extends ConsumerWidget {
  const GainBotApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'GainBot',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/chat',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isSigningIn = state.matchedLocation == '/sign-in';
    if (user == null && !isSigningIn) return '/sign-in';
    if (user != null && isSigningIn) return '/chat';
    return null;
  },
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
        GoRoute(
          path: '/history',
          builder: (context, state) => const HistoryScreen(),
          routes: [
            GoRoute(
              path: ':date',
              builder: (context, state) =>
                  WorkoutDetailScreen(date: state.pathParameters['date']!),
            ),
          ],
        ),
        GoRoute(path: '/prs', builder: (context, state) => const PRScreen()),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/prs')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/chat');
      case 1:
        context.go('/history');
      case 2:
        context.go('/prs');
      case 3:
        context.go('/profile');
    }
  }
}
