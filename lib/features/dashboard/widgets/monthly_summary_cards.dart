import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MonthlySummaryCards extends StatelessWidget {
  final AsyncValue<double> monthlyIncome;
  final AsyncValue<double> monthlyExpense;
  final AsyncValue<double> monthlySavings;

  const MonthlySummaryCards({
    super.key,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.monthlySavings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text("Income"),
                  const SizedBox(height: 8),
                  monthlyIncome.when(
                    data: (value) => Text(
                      "₹${value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => const Text("Error"),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.trending_down, color: Colors.red),
                  const SizedBox(height: 8),
                  const Text("Expense"),
                  const SizedBox(height: 8),
                  monthlyExpense.when(
                    data: (value) => Text(
                      "₹${value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => const Text("Error"),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.savings, color: Colors.blue),
                  const SizedBox(height: 8),
                  const Text("Savings"),
                  const SizedBox(height: 8),
                  monthlySavings.when(
                    data: (value) => Text(
                      "₹${value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => const Text("Error"),
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
