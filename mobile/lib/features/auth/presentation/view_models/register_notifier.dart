import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/features/auth/auth_provider.dart';
import 'package:fsp_starter/features/auth/data/repository/auth_repository.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  failure
}

class RegisterState {
  final RegisterStatus status;
  final bool showPassword;
  final bool showConfirmPassword;

  const RegisterState({
    this.status = .initial,
    this.showPassword = false,
    this.showConfirmPassword = false,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    bool? showPassword,
    bool? showConfirmPassword,
  }) {
    return RegisterState(
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword
    );
  }
}

class RegisterViewModel extends Notifier<RegisterState> {

  late final AuthRepository _repo;

  @override
  build() {
    _repo = ref.watch(authRepositoryProvider);
    return RegisterState(status: .initial);
  }

  Future<void> register(String email, String password) async {
    state = state.copyWith(status: .loading);
    await _repo.register(email, password);
    state = state.copyWith(status: .success);
  }

  void togglePassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }
  void toggleConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }
  
}