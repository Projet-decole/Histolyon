// Vérifie la liste fermée des six providers de session (AD-20) : valeur par
// défaut et mutation minimale de chacun.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/session/session_providers.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('epoqueSelectionnee démarre à null et se met à jour', () {
    expect(container.read(epoqueSelectionneeProvider), isNull);
    container.read(epoqueSelectionneeProvider.notifier).definir('epoque-1');
    expect(container.read(epoqueSelectionneeProvider), 'epoque-1');
  });

  test('parcoursActif démarre à null et se met à jour', () {
    expect(container.read(parcoursActifProvider), isNull);
    container.read(parcoursActifProvider.notifier).definir('parcours-1');
    expect(container.read(parcoursActifProvider), 'parcours-1');
  });

  test('etapeCourante démarre à null et se met à jour', () {
    expect(container.read(etapeCouranteProvider), isNull);
    container.read(etapeCouranteProvider.notifier).definir(2);
    expect(container.read(etapeCouranteProvider), 2);
  });

  test('pinCourant démarre à null et se met à jour', () {
    expect(container.read(pinCourantProvider), isNull);
    container.read(pinCourantProvider.notifier).definir('pin-1');
    expect(container.read(pinCourantProvider), 'pin-1');
  });

  test('modePresentation démarre à false et bascule', () {
    expect(container.read(modePresentationProvider), isFalse);
    container.read(modePresentationProvider.notifier).basculer();
    expect(container.read(modePresentationProvider), isTrue);
  });

  test('lectureAudio démarre à false et se met à jour', () {
    expect(container.read(lectureAudioProvider), isFalse);
    container.read(lectureAudioProvider.notifier).definir(true);
    expect(container.read(lectureAudioProvider), isTrue);
  });
}
