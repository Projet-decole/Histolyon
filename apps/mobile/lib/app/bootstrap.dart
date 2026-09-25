import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';
import 'theme.dart';

/// Fournies par `--dart-define-from-file=env/<env>.json` (convention Config &
/// secrets) : jamais de constante d'URL/clé en dur dans le code.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Échoue tôt, avec un message utile, si l'app a été lancée sans sa config
/// (sinon Supabase échoue plus tard avec une erreur obscure).
void verifierConfigSupabase({required String url, required String cle}) {
  if (url.isEmpty || cle.isEmpty) {
    throw StateError(
      'SUPABASE_URL ou SUPABASE_ANON_KEY manquante : lancer avec '
      '--dart-define-from-file=../../env/local.json (voir env/README.md).',
    );
  }
}

/// Point d'entrée unique (AD-5) : initialise Supabase puis démarre l'app sous
/// un seul `ProviderScope`. Rien d'autre n'assemble l'app.
Future<void> demarrer() async {
  WidgetsFlutterBinding.ensureInitialized();
  verifierConfigSupabase(url: _supabaseUrl, cle: _supabaseAnonKey);
  await Supabase.initialize(
    url: _supabaseUrl,
    publishableKey: _supabaseAnonKey,
  );
  runApp(const ProviderScope(child: HistoLyonApp()));
}

class HistoLyonApp extends ConsumerWidget {
  const HistoLyonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'HistoLyon',
      theme: construireTheme(),
      // App en français uniquement (convention Langue).
      locale: const Locale('fr'),
      supportedLocales: const [Locale('fr')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
