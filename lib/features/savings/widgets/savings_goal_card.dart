import 'package:flutter/material.dart';
import '../../../database/database.dart';

class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({super.key, required this.goal, required this.onTap});
  final SavingsGoal goal;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final fraction = goal.targetAmount == 0
        ? 0.0
        : (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goal.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: fraction),
                duration: const Duration(milliseconds: 400),
                builder: (_, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 9,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${goal.currentAmount.toStringAsFixed(0)} of ₹${goal.targetAmount.toStringAsFixed(0)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
