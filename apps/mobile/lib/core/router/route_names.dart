/// Noms et chemins de routes (AD-5) : `core/router` ne fait que nommer, seul
/// `app/router.dart` assemble les `GoRoute` exportées par les features.
///
/// Naviguer d'une feature à une autre passe par ces noms, jamais par un import
/// de l'autre feature :
/// - vers un onglet : `context.goNamed(RouteNames.carte)` ;
/// - vers un écran plein écran (`pin`, `modele3d`) : `context.pushNamed(...)`,
///   pour garder les onglets dessous (bouton et geste retour).
abstract final class RouteNames {
  // Onglets (surfaces principales S1-S3, conception/05-architecture-info.yaml).
  static const String carte = 'carte';
  static const String cartePath = '/';
  static const String parcours = 'parcours';
  static const String parcoursPath = '/parcours';
  static const String profil = 'profil';
  static const String profilPath = '/profil';

  // Écrans plein écran, au-dessus des onglets. Paramètre : `slug`.
  static const String pin = 'pin';
  static const String pinPath = '/pin/:slug';
  static const String modele3d = 'modele3d';
  static const String modele3dPath = '/modele-3d/:slug';
}
