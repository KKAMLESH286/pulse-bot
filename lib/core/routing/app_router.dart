import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:track_me/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:track_me/features/ai_coach/presentation/screens/ai_coach_screen.dart';
import 'package:track_me/features/workout/presentation/screens/history_screen.dart';
import 'package:track_me/features/workout/presentation/screens/workout_detail_screen.dart';
import 'package:track_me/features/personal_records/presentation/screens/pr_screen.dart';
import 'package:track_me/features/program/presentation/screens/program_screen.dart';
import 'package:track_me/features/profile/presentation/screens/profile_screen.dart';
import 'package:track_me/core/widgets/scaffold_with_nav.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.chat,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isSigningIn = state.matchedLocation == RouteNames.signIn;
    if (user == null && !isSigningIn) return RouteNames.signIn;
    if (user != null && isSigningIn) return RouteNames.chat;
    return null;
  },
  routes: [
    GoRoute(
      path: RouteNames.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: RouteNames.chat,
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          path: RouteNames.history,
          builder: (context, state) => const HistoryScreen(),
          routes: [
            GoRoute(
              path: ':date',
              builder: (context, state) =>
                  WorkoutDetailScreen(date: state.pathParameters['date']!),
            ),
          ],
        ),
        GoRoute(
          path: RouteNames.prs,
          builder: (context, state) => const PRScreen(),
        ),
        GoRoute(
          path: RouteNames.program,
          builder: (context, state) => const ProgramScreen(),
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
