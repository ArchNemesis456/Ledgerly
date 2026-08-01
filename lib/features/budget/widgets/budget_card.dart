import 'package:flutter/material.dart';

import '../../../database/database.dart';
import 'budget_progress.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.budget, required this.onTap});

  final Budget budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    budget.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(label: Text(budget.category)),
              ],
            ),
            const SizedBox(height: 16),
            BudgetProgress(
              spent: budget.spentAmount,
              limit: budget.limitAmount,
            ),
          ],
        ),
      ),
    ),
  );
}
