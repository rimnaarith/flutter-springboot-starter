import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/core/routing/router_notifier.dart';
import 'package:fsp_starter/features/auth/presentation/views/login_screen.dart';
import 'package:fsp_starter/features/auth/presentation/views/signup_screen.dart';
import 'package:fsp_starter/features/home/view/pages/home_screen.dart';
import 'package:fsp_starter/features/home/view/pages/main_scaffold.dart';
import 'package:fsp_starter/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:fsp_starter/features/profile/view/pages/profile_screen.dart';

GoRouter buildRouter(String initialRoute, WidgetRef ref) => GoRouter(
  initialLocation: initialRoute,
  refreshListenable: ref.watch(routerNotifierProvider),
  redirect: ref.watch(routerNotifierProvider).redirect,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainScaffold(child: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            )
          ]
        )
      ]
    ),
  ]
);