import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/log/app_logger.dart';
import 'router.dart';
import 'theme.dart';

/// Fournies par `--dart-define-from-file=env/<env>.json` (convention Config &
/// secrets) : jamais de constante d'URL/clé en dur dans le code.
const _log = AppLogger('bootstrap');

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Le MVP lit le contenu embarqué (DEC-04) : Supabase n'est initialisé que si
/// l'URL et la clé sont toutes deux fournies. Sans configuration, l'app démarre
/// quand même et renvoie `false` (rien ne lit alors `supabaseClientProvider`).
Future<bool> initialiserSupabaseSiConfigure({
  required String url,
  required String cle,
  Future<void> Function(String url, String cle) initialiser = _initialiser,
}) async {
  if (url.isEmpty || cle.isEmpty) {
    _log.info('Supabase non configuré : démarrage sur le contenu embarqué.');
    return false;
  }
  await initialiser(url, cle);
  return true;
}

Future<void> _initialiser(String url, String cle) =>
    Supabase.initialize(url: url, publishableKey: cle);

/// Point d'entrée unique (AD-5) : initialise Supabase s'il est configuré, puis
/// démarre l'app sous un seul `ProviderScope`. Rien d'autre n'assemble l'app.
Future<void> demarrer() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialiserSupabaseSiConfigure(
    url: _supabaseUrl,
    cle: _supabaseAnonKey,
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
