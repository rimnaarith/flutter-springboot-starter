import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// This provider will hold the actual instance. 
// We use 'throw' because we will override it in main.dart
// So we can check for some data before the app starts.
// For example, checking if onboarding is completed.
// See main.dart for the override implementation.
// In case we don't need to check anything, we can just return SharedPreferences.getInstance() directly here.

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});