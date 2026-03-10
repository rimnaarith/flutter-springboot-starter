import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/features/onboarding/data/repository/onboarding_repository.dart';
import 'package:fsp_starter/features/onboarding/onboarding_provider.dart';

class OnboardingState {
  final int currentPage;
  final bool isLastPage;

  const OnboardingState({
    this.currentPage = 0,
    this.isLastPage = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

}

class OnboardingViewmodel extends Notifier<OnboardingState> {
  late final OnboardingRepository _repo;

  @override
  OnboardingState build() {
    _repo = ref.watch(onboardingRepositoryProvider);
    return OnboardingState();
  }

  void setCurrentPage(int pageIndex, int totalPages) {
    state = state.copyWith(
      currentPage: pageIndex,
      isLastPage: pageIndex == totalPages - 1,
    );
  }

  Future<void> finishOnboarding(void Function() onComplete) async {
    await _repo.setOnboardingCompleted();
    onComplete();
  }
}