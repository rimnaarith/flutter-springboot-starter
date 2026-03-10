import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';
import 'package:fsp_starter/features/auth/auth_provider.dart';
import 'package:fsp_starter/features/auth/data/repository/auth_repository.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final bool showPassword;

  const LoginState({
    this.status = LoginStatus.initial,
    this.showPassword = false,
  });

  LoginState copyWith({LoginStatus? status, bool? showPassword}) {
    return LoginState(
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}

class LoginViewModel extends Notifier<LoginState> {
  late AuthRepository _repo;

  LoginViewModel() {
    log.d('[LoginVM] created');
  }

  @override
  build() {
    log.d('[LoginVM] built');
    _repo = ref.watch(authRepositoryProvider);
    return LoginState(status: LoginStatus.initial);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);
    await _repo.login(email, password);
    state = state.copyWith(status: LoginStatus.success);
  }

  void togglePassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }
}
