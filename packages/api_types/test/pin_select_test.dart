// AC Story 4.2 : un select typé sur `pin` réussit contre Supabase local.
// Lit SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY dans l'environnement — voir
// `supabase status` en local (mêmes variables que tools/gen_types.dart).

import 'dart:io';

import 'package:api_types/generated_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test/test.dart';

void main() {
  final url = Platform.environment['SUPABASE_URL'];
  final key = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];

  test(
    'select typé sur pin (insertion, lecture, nettoyage)',
    () async {
      final client = SupabaseClient(url!, key!);
      final suffixe = DateTime.now().microsecondsSinceEpoch;

      final categorie = await client
          .from(Categorie.table_name)
          .insert(
            Categorie.insert(
              slug: 'test-gen-types-categorie-$suffixe',
              libelle: 'Catégorie de test (tools/gen-types)',
              ordre: 999,
            ),
          )
          .select()
          .single();

      // Nettoyage même si une insertion ou une assertion échoue — sinon un
      // échec laisse le pin/catégorie de test orphelins en base locale.
      Map<String, dynamic>? pinInsere;
      try {
        pinInsere = await client
            .from(Pin.table_name)
            .insert(
              Pin.insert(
                slug: 'test-gen-types-pin-$suffixe',
                titre: 'Pin de test (tools/gen-types)',
                categorieId: categorie['id'] as String,
                contenuNarratif: {'texte': 'contenu de test'},
              ),
            )
            .select()
            .single();

        final ligne = await client
            .from(Pin.table_name)
            .select()
            .eq('id', pinInsere['id'])
            .single();
        final pin = Pin.converterSingle(ligne);

        expect(pin.titre, 'Pin de test (tools/gen-types)');
        expect(pin.statut, STATUT_PIN.brouillon);
        expect(pin.provenance, PROVENANCE_PIN.editorial);
        expect(pin.localisation, isNull);
      } finally {
        if (pinInsere != null) {
          await client.from(Pin.table_name).delete().eq('id', pinInsere['id']);
        }
        await client
            .from(Categorie.table_name)
            .delete()
            .eq('id', categorie['id']);
      }
    },
    skip: url == null || key == null
        ? 'SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY absentes — test contre '
              'Supabase local sauté (voir supabase status).'
        : false,
  );
}
