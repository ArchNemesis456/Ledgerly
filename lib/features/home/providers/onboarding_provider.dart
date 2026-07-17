import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/onboarding_page.dart';

final onboardingPagesProvider = Provider<List<OnboardingPageModel>>((ref) {
  return const [
    OnboardingPageModel(
      title: 'Welcome to Ledgerly',
      description:
          'Take control of your finances with smart tracking and powerful insights.',
      image: 'assets/images/onboarding_1.png',
    ),
    OnboardingPageModel(
      title: 'Track Every Expense',
      description:
          'Record transactions, organize accounts, and never lose sight of your spending.',
      image: 'assets/images/onboarding_2.png',
    ),
    OnboardingPageModel(
      title: 'AI-Powered Insights',
      description:
          'Let Ledgerly analyze your finances and help you make better financial decisions.',
      image: 'assets/images/onboarding_3.png',
    ),
  ];
});