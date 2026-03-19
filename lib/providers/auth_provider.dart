import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}

@Riverpod(keepAlive: true)
Stream<User?> authState(Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

@riverpod
User? currentUser(Ref ref) {
  return ref.watch(authStateProvider).value;
}
