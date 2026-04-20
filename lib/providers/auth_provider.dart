import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pawcity/services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) => AuthService();

@riverpod
Stream<Session?> authState(AuthStateRef ref) {
  final service = ref.watch(authServiceProvider);

  return service.authStateChanges().map((state) => state.session);
}
