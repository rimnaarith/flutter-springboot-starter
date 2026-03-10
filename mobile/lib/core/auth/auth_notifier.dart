import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/constants/storage_keys.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';
import 'package:fsp_starter/core/storage/shared_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus {
  authenticated,
  unauthenticated
}

class AuthState {
  final AuthStatus status;

  const AuthState({required this.status});
}

class AuthNotifier extends Notifier<AuthState> {

  late final SharedPreferences _prefs;
  
  @override
  build() {
    log.d('[AuthNotifier] - build called');
    _prefs = ref.read(sharedPreferencesProvider);
    final isAuthenticated = _prefs.getBool(StorageKeys.isAuthenticated) ?? false;
    log.d('[AuthNotifier] - Initial auth status: ${isAuthenticated ? "authenticated" : "unauthenticated"}');
    return AuthState(status: isAuthenticated ? AuthStatus.authenticated : AuthStatus.unauthenticated);
  }

  void setAuthenticated() {
    log.d('[AuthNotifier] - Setting status to authenticated');
    _prefs.setBool(StorageKeys.isAuthenticated, true);
    state = const AuthState(status: AuthStatus.authenticated);
  }

  void setUnauthenticated() {
    log.d('[AuthNotifier] - Setting status to unauthenticated');
    _prefs.setBool(StorageKeys.isAuthenticated, false);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  AuthStatus get authStatus => state.status;
  
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});