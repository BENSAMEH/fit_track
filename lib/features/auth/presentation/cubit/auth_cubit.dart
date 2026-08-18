import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial()) {
    _checkExistingSession();
  }

  final SupabaseClient _client = Supabase.instance.client;

  void _checkExistingSession() {
    final session = _client.auth.currentSession;
    if (session != null) {
      emit(AuthAuthenticated(session.user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        emit(const AuthError('Sign in failed. Please try again.'));
        return;
      }
      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    } catch (e) {
      emit(const AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      final user = response.user;
      if (user == null) {
        emit(const AuthError('Sign up failed. Please try again.'));
        return;
      }

      // If email confirmation is required, Supabase returns a user
      // but no session yet — treat that as "needs confirmation"
      // rather than fully authenticated.
      if (response.session == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      emit(AuthAuthenticated(user));
    } on AuthException catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    } catch (e) {
      emit(const AuthError('Something went wrong. Please try again.'));
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    try {
      await _client.auth.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthError('Failed to sign out. Please try again.'));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      emit(AuthError(_friendlyMessage(e)));
    }
  }

  String _friendlyMessage(AuthException e) {
    // Supabase error messages are already fairly readable, but a
    // couple of common ones are worth rephrasing for clarity.
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('already registered') || msg.contains('already exists')) {
      return 'An account with this email already exists.';
    }
    if (msg.contains('password should be at least')) {
      return 'Password must be at least 6 characters.';
    }
    return e.message;
  }
}