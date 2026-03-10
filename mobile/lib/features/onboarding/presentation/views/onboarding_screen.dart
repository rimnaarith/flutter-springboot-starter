import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fsp_starter/core/constants/app_routes.dart';
import 'package:fsp_starter/features/onboarding/onboarding_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    ref.listen(onboardingViewModelProvider.select((s) => s.currentPage), (
      previous,
      next,
    ) {
      if (previous != next &&
          !_pageController.position.isScrollingNotifier.value) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    ref
                        .read(onboardingViewModelProvider.notifier)
                        .setCurrentPage(value, 4);
                  },
                  children: const [
                    Center(
                      child: Text(
                        'Onboarding Page 1 Onboarding Page 1 Onboarding Page 1 Onboarding Page 1 Onboarding Page 1',
                      ),
                    ),
                    Center(child: Text('Onboarding Page 2')),
                    Center(child: Text('Onboarding Page 3')),
                    Center(child: Text('Onboarding Page 4')),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        child: Text('Skip'),
                        onPressed: () {
                          ref
                              .read(onboardingViewModelProvider.notifier)
                              .finishOnboarding(() {
                                context.go(AppRoutes.login);
                              });
                        },
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: 4,
                    effect: CustomizableEffect(
                      spacing: 6,
                      dotDecoration: DotDecoration(
                        width: 6,
                        height: 6,
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeDotDecoration: DotDecoration(
                        width: 8,
                        height: 8,
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: state.isLastPage
                            ? const Text('Get Started')
                            : const Text('Next'),
                        onPressed: () {
                          bool isMoving = _pageController
                              .position
                              .isScrollingNotifier
                              .value;
                          if (isMoving) return;
                          if (state.isLastPage) {
                            ref
                                .read(onboardingViewModelProvider.notifier)
                                .finishOnboarding(() {
                                  context.go(AppRoutes.login);
                                });
                            return;
                          }
                          ref
                              .read(onboardingViewModelProvider.notifier)
                              .setCurrentPage(state.currentPage + 1, 4);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
