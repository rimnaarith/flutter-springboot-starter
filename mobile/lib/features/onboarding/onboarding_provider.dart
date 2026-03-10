import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/core_providers.dart';
import 'package:fsp_starter/features/onboarding/data/repository/onboarding_repository.dart';
import 'package:fsp_starter/features/onboarding/presentation/view_models/onboarding_notifier.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingRepository(prefs);
});
final onboardingViewModelProvider = NotifierProvider.autoDispose<OnboardingViewmodel, OnboardingState>(OnboardingViewmodel.new);