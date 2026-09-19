import 'dart:developer' as developer;

/// Logger partagé (AD-20, convention Observabilité) : niveaux basiques, sans
/// PII. Enveloppe `dart:developer` pour rester remplaçable sans toucher les
/// appelants si un besoin d'observabilité plus riche apparaît.
class AppLogger {
  const AppLogger(this._domaine);

  final String _domaine;

  void debug(String message) => _log(message, level: 500);

  void info(String message) => _log(message, level: 800);

  void avertissement(String message) => _log(message, level: 900);

  void erreur(String message, [Object? erreur, StackTrace? pile]) {
    developer.log(
      message,
      name: _domaine,
      level: 1000,
      error: erreur,
      stackTrace: pile,
    );
  }

  void _log(String message, {required int level}) {
    developer.log(message, name: _domaine, level: level);
  }
}
