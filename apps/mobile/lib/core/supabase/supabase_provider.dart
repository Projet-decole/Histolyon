import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

/// Client Supabase partagé. Seules les couches `data/` des features le lisent
/// (jamais `presentation/`). En test, le surcharger avec
/// `supabaseClientProvider.overrideWithValue(...)`.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;
