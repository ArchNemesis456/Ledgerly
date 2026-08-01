import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeExpenseCards extends StatelessWidget {
  final AsyncValue<double> totalIncome;
  final AsyncValue<double> totalExpense;

  const IncomeExpenseCards({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(Icons.arrow_downward, color: Colors.green),
                  const SizedBox(height: 10),
                  const Text("Income"),
                  const SizedBox(height: 6),
                  totalIncome.when(
                    data: (income) => Text(
                      "₹${income.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stackTrace) => const Text("Failed to load"),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.red),
                  const SizedBox(height: 10),
                  const Text("Expense"),
                  const SizedBox(height: 6),
                  totalExpense.when(
                    data: (expense) => Text(
                      "₹${expense.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stackTrace) => const Text("Failed to load"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
