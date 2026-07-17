import 'package:flutter/material.dart';

import '../models/onboarding_page.dart';

class OnboardingPageCard extends StatelessWidget {
  const OnboardingPageCard({
    super.key,
    required this.page,
  });

  final OnboardingPageModel page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Column(
        children: [
          const Spacer(),

          const Icon(
            Icons.account_balance_wallet_rounded,
            size: 150,
          ),

          const SizedBox(height: 48),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 20),

          Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}