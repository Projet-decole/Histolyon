/// Modèle d'erreur partagé (AD-5, AD-20). `data` convertit toute exception
/// (réseau, Supabase, inattendue) en `Failure` — `presentation` n'attrape
/// jamais d'exception brute.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ReseauFailure extends Failure {
  const ReseauFailure([super.message = 'Connexion réseau indisponible']);
}

final class ServeurFailure extends Failure {
  const ServeurFailure(super.message);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class InconnueFailure extends Failure {
  const InconnueFailure(super.message);
}

/// Résultat d'une opération pouvant échouer (`data` -> `domain`).
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
