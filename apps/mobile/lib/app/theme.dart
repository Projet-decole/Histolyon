import 'package:design_tokens/design_tokens.dart';
import 'package:flutter/material.dart';

/// Thème unique de l'app (AD-10) : construit à la composition root depuis
/// `design_tokens`, pour que les features n'aient jamais de valeur visuelle
/// en dur. Clair uniquement (pas de thème sombre).
ThemeData construireTheme() {
  final couleurs =
      ColorScheme.fromSeed(
        seedColor: TOK_COLOR_PRIMARY,
        brightness: Brightness.light,
      ).copyWith(
        primary: TOK_COLOR_PRIMARY,
        onPrimary: TOK_COLOR_BLANC_NARRATIF,
        secondary: TOK_COLOR_OR_ACCENT,
        surface: TOK_COLOR_FOND_PRINCIPAL,
        onSurface: TOK_COLOR_TEXTE_PRINCIPAL,
        onSurfaceVariant: TOK_COLOR_TEXTE_SECONDAIRE,
        error: TOK_COLOR_FONCTIONNEL_ERREUR,
      );
  return ThemeData(
    colorScheme: couleurs,
    scaffoldBackgroundColor: TOK_COLOR_FOND_PRINCIPAL,
  );
}
