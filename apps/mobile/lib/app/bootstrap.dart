import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

/// Fournies par `--dart-define-from-file=env/<env>.json` (convention Config &
/// secrets) : jamais de constante d'URL/clé en dur dans le code.
const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Point d'entrée unique (AD-5) : initialise Supabase puis démarre l'app sous
/// un seul `ProviderScope`. Rien d'autre n'assemble l'app.
Future<void> demarrer() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp.router(title: 'HistoLyon', routerConfig: router);
  }
}
