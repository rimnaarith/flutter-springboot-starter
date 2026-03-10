import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/core_providers.dart';
import 'package:fsp_starter/features/auth/data/repository/auth_repository.dart';
import 'package:fsp_starter/features/auth/presentation/view_models/login_notifier.dart';
import 'package:fsp_starter/features/auth/presentation/view_models/register_notifier.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  final jwtStorage = ref.watch(jwtStorageProvider);
  final authNotifier = ref.read(authProvider.notifier);
  return AuthRepository(api, jwtStorage, authNotifier);
});

final registerViewModelProvider = NotifierProvider.autoDispose<RegisterViewModel, RegisterState>(RegisterViewModel.new);
final loginViewModelProvider = NotifierProvider.autoDispose<LoginViewModel, LoginState>(LoginViewModel.new);