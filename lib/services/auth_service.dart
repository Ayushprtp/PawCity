import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  SupabaseClient get _client => SupabaseService.client;

  Stream<AuthState> authStateChanges() {
    try {
      return _client.auth.onAuthStateChange;
    } catch (_) {
      return const Stream.empty();
    }
  }

  User? get currentUser {
    try {
      return _client.auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('Unable to sign in right now: $e');
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
    required String city,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'display_name': fullName,
          'city': city,
        },
      );

      final userId = response.user?.id;
      if (userId != null) {
        try {
          await _client.from('profiles').upsert({
            'id': userId,
            'username': username,
            'display_name': fullName,
            'city': city,
          });
        } catch (e) {
          // Profile creation might fail due to RLS or triggers, but the user is already created.
          print('Profile upsert failed: $e');
        }
      }

      return response;
    } on AuthException catch (e) {
      throw AppAuthException(e.message);
    } catch (e) {
      throw AppAuthException('Unable to create account right now: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw const AppAuthException('Unable to sign out right now.');
    }
  }
}
