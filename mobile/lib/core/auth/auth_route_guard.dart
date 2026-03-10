import '../constants/app_routes.dart';

class AuthRouteGuard {
  static const Set<String> _authRequiredRoutes = {
    AppRoutes.home,
    AppRoutes.profile,
  };

  static bool requiresAuth(String location) {
    return _authRequiredRoutes.contains(location);
  }
}