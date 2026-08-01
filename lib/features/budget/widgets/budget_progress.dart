import 'package:flutter/material.dart';

class BudgetProgress extends StatelessWidget {
  const BudgetProgress({super.key, required this.spent, required this.limit});

  final double spent;
  final double limit;

  @override
  Widget build(BuildContext context) {
    final ratio = limit == 0 ? 0.0 : spent / limit;
    final progress = ratio.clamp(0.0, 1.0);
    final color = ratio > .9
        ? Colors.red
        : ratio >= .7
        ? Colors.orange
        : Colors.green;
    final remaining = (limit - spent).clamp(0, double.infinity);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₹${spent.toStringAsFixed(0)} spent'),
            Text(
              '${(ratio * 100).toStringAsFixed(0)}%',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 450),
          builder: (_, value, _) => LinearProgressIndicator(
            value: value,
            minHeight: 9,
            borderRadius: BorderRadius.circular(99),
            color: color,
            backgroundColor: color.withValues(alpha: .14),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹${remaining.toStringAsFixed(0)} remaining of ₹${limit.toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
