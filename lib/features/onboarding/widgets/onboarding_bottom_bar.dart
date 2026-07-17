import 'package:flutter/material.dart';

class OnboardingBottomBar extends StatelessWidget {
  const OnboardingBottomBar({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        children: [
          TextButton(
            onPressed: onSkip,
            child: const Text('Skip'),
          ),

          const Spacer(),

          FilledButton(
            onPressed: onNext,
            child: Text(
              isLastPage ? 'Get Started' : 'Next',
            ),
          ),
        ],
      ),
    );
  }
}