import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fsp_starter/core/auth/auth_notifier.dart';
import 'package:fsp_starter/core/auth/auth_route_guard.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to auth state changes
    _ref.listen<AuthState>(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  String? redirect(BuildContext context, GoRouterState state) {
    log.d('[RouterNotifier] - Evaluating redirect for route: ${state.uri.path}');
    final authState = _ref.read(authProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    // If the user is not authenticated and trying to access a protected route, redirect to login
    if ( !isAuthenticated && AuthRouteGuard.requiresAuth(state.uri.path)) {
      log.d('[RouterNotifier] - Redirecting to login from ${state.uri.path} due to unauthenticated access attempt');
      return AppRoutes.login;
    }

    if (isAuthenticated &&
        (state.uri.path == AppRoutes.login ||
         state.uri.path == AppRoutes.signup ||
         state.uri.path == AppRoutes.onboarding
        )) {

      log.d('[RouterNotifier] - Redirecting to home from ${state.uri.path} due to authenticated access attempt');
      return AppRoutes.home;
    }

    log.d('[RouterNotifier] - No redirect needed for route: ${state.uri.path}');
    return null;
  }

}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});