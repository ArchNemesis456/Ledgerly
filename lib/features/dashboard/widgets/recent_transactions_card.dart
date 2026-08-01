import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';

class RecentTransactionsCard extends StatelessWidget {
  final AsyncValue<List<Transaction>> recentTransactions;
  final VoidCallback onViewAll;

  const RecentTransactionsCard({
    super.key,
    required this.recentTransactions,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recent Transactions",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(onPressed: onViewAll, child: const Text("View All")),
          ],
        ),
        const SizedBox(height: 10),
        recentTransactions.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stackTrace) => Card(
            child: ListTile(
              leading: const Icon(Icons.error),
              title: const Text("Failed to load transactions"),
              subtitle: Text(error.toString()),
            ),
          ),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Card(
                child: ListTile(
                  leading: CircleAvatar(child: Icon(Icons.receipt_long)),
                  title: Text("No transactions yet"),
                  subtitle: Text("Add a transaction to get started."),
                ),
              );
            }

            return Card(
              child: Column(
                children: transactions.map((transaction) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: transaction.isIncome
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: Icon(
                        transaction.isIncome
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(transaction.title),
                    subtitle: Text(
                      "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                    ),
                    trailing: Text(
                      "${transaction.isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: transaction.isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
