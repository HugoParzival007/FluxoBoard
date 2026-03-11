/// Configuração do Supabase.
///
/// Para usar Supabase, crie um projeto em https://supabase.com
/// e defina as variáveis ao rodar o app:
///
/// flutter run --dart-define=SUPABASE_URL=sua_url --dart-define=SUPABASE_ANON_KEY=sua_key
///
/// Ou substitua os valores abaixo diretamente (não commitar credenciais reais).
class SupabaseConfig {
  SupabaseConfig._();

  static const String _url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String _anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  static bool get isConfigured => _url.isNotEmpty && _anonKey.isNotEmpty;

  static String get url => _url;
  static String get anonKey => _anonKey;
}
