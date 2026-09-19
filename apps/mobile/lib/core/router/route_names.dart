/// Noms et chemins de routes (AD-5) : `core/router` ne fait que nommer, seul
/// `app/router.dart` assemble les `GoRoute` exportées par les features.
abstract final class RouteNames {
  static const String carte = 'carte';
  static const String cartePath = '/';
}
