import 'package:supabase_flutter/supabase_flutter.dart';

/// Repositório de autenticação.
///
/// Usa Supabase Auth quando configurado.
/// Em modo demo (Supabase não configurado), simula autenticação.
class AuthRepository {
  AuthRepository();

  SupabaseClient? get _client => Supabase.instance.isInitialized ? Supabase.instance.client : null;

  User? get currentUser => _client?.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _client?.auth.onAuthStateChange ?? const Stream.empty();

  Future<void> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    if (_client != null) {
      await _client!.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );
    }
    // Modo demo: não faz nada, UI redireciona manualmente
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (_client != null) {
      await _client!.auth.signInWithPassword(
        email: email,
        password: password,
      );
    }
    // Modo demo: não faz nada, UI redireciona manualmente
  }

  Future<void> signOut() async {
    if (_client != null) {
      await _client!.auth.signOut();
    }
  }

  bool get isAuthenticated => currentUser != null;
}
