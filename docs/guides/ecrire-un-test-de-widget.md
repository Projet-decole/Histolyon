# Guide — Écrire un test de widget

**AD source :** AD-14 (« Tests d'abord, dans cet ordre, par couche » — pour `presentation` : « le premier commit d'une branche de story contient ses tests (rouges) », [`ARCHITECTURE-SPINE.md`](../ARCHITECTURE-SPINE.md)).

## 1. Où placer le test

Chaque fichier de la couche `presentation` a son test dans le dossier `test/` miroir, avec le suffixe `_test.dart`. Pour une feature :

```
apps/mobile/lib/features/<slug>/presentation/mon_widget.dart
apps/mobile/test/features/<slug>/presentation/mon_widget_test.dart
```

Point de départ concret : `apps/mobile/test/widget_test.dart` (démarrage de l'app, navigation entre onglets, ouverture d'un pin par route nommée) et `apps/mobile/test/core/` (tests de `core/session`, `core/log`, `core/models`, `core/profile`).

## 2. Quoi couvrir en priorité

1. Les états de l'écran : chargement, erreur (`Failure`), vide, nominal.
2. L'interaction principale décrite par l'issue (tap, glissement du slider…) et son effet observable.
3. Si un composant visuel est réutilisable par d'autres features, il descend dans `packages/` (ou `core/`) avec son propre test — pas copié d'une feature à l'autre.

Un `integration_test` de bout en bout n'est **pas** ta responsabilité par issue : un seul existe pour tout le produit, exécuté en nightly.

## 3. Structure Arrange / Act / Assert

Chaque test suit ce squelette :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/<slug>/presentation/mon_widget.dart';

void main() {
  testWidgets('<comportement attendu, en une phrase>', (WidgetTester tester) async {
    // Arrange : construire le widget (avec un ProviderScope si des providers Riverpod sont lus)
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: MonWidget()),
      ),
    );

    // Act : simuler l'interaction utilisateur (ou ne rien faire pour un test d'état initial)
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Assert : vérifier le résultat observable
    expect(find.text('résultat attendu'), findsOneWidget);
  });
}
```

Points spécifiques à ce projet :

- Si le widget lit un provider `@riverpod` de `domain/`, enveloppe-le dans un `ProviderScope` avec des `overrides` pour isoler le test du vrai `data/` (pas d'appel réseau réel dans un test `presentation`).
- Un widget qui dépend de `go_router` (navigation nommée via `core/router/route_names.dart`) se teste avec un `GoRouter` de test minimal plutôt qu'en lançant l'app entière.
- Le test ne doit jamais attendre une exception Supabase/Drift : si le widget affiche un état d'erreur, on l'obtient en fournissant un `override` de provider qui renvoie un `Err(Failure)` (`core/models/failure.dart`), pas en simulant une vraie panne réseau.

## 4. Premier commit rouge

Avant d'écrire l'implémentation : écris le test avec le comportement final attendu, lance-le (`cd apps/mobile && flutter test test/features/<slug>/presentation/mon_widget_test.dart`), vérifie qu'il **échoue** pour la bonne raison (widget/texte introuvable, pas une erreur de compilation), puis committe ce test seul comme premier commit de la branche. Le relecteur vérifiera cet ordre avant le squash merge (AD-14).

## 5. Vérifier avant de pousser

- `flutter test` sur le package touché passe (les tests ajoutés sont maintenant verts).
- `melos run analyze` ne remonte aucune régression.
- La couverture du package ne baisse pas (cliquet CI, `coverage_baseline.txt`).
