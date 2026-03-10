import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/app.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/core/constants/storage_keys.dart';
import 'package:fsp_starter/core/storage/cookie_storage.dart';
import 'package:fsp_starter/core/storage/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Ensure initialization before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-initialize SharedPreferences and CookieJar  
  final results = await Future.wait([SharedPreferences.getInstance(), createCookieJar()]);
  final sharedPreferences = results[0] as SharedPreferences;
  final cookieJar = results[1] as PersistCookieJar;

  final isCompletedOnboarding = sharedPreferences.getBool(StorageKeys.onboardingComplete) ?? false;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        cookieJarProvider.overrideWithValue(cookieJar),
      ],
      child: App(initialRoute: isCompletedOnboarding ? AppRoutes.login : AppRoutes.onboarding),
    ),
  );
}
