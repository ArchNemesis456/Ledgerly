import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/budget_provider.dart';
import '../widgets/budget_card.dart';
import 'add_budget_screen.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetStreamProvider);
    final dashboard = ref.watch(budgetDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Budgets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const AddBudgetScreen())),
        icon: const Icon(Icons.add),
        label: const Text('New budget'),
      ),
      body: budgets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (budgetList) {
          if (budgetList.isEmpty) {
            return const Center(
              child: Text(
                "No Budgets Yet",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BudgetStats(dashboard: dashboard),
              const SizedBox(height: 16),
              ...budgetList.map(
                (budget) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BudgetCard(
                    budget: budget,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddBudgetScreen(budget: budget),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BudgetStats extends StatelessWidget {
  const _BudgetStats({required this.dashboard});
  final BudgetDashboard dashboard;
  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: [
          _Stat('Total budget', dashboard.limit),
          _Stat('Spent', dashboard.spent),
          _Stat('Remaining', dashboard.remaining),
          Text(
            '${dashboard.activeCount} active',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label),
      Text(
        '₹${value.toStringAsFixed(0)}',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    ],
  );
}
