import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpense = ref.watch(totalExpenseProvider);
    final recentTransactions = ref.watch(recentTransactionsProvider);
    final monthlyIncome = ref.watch(monthlyIncomeProvider);
    final monthlyExpense = ref.watch(monthlyExpenseProvider);
    final monthlySavings = ref.watch(monthlySavingsProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Evening 👋",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              "Welcome Back!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 30),

            // Total Balance Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF3F51B5),
                    Color(0xFF5C6BC0),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Balance",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),

                    const SizedBox(height: 12),

                    totalBalance.when(
                      data: (balance) => Text(
                        "₹${balance.toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      loading: () => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      error: (error, stackTrace) => const Text(
                        "Failed to load",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Income & Expense
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          const Text("Income"),
                          const SizedBox(height: 6),
                          totalIncome.when(
                            data: (income) => Text(
                              "₹${income.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                            ),
                            loading: () => const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            error: (error, stackTrace) =>
                                const Text("Failed to load"),
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
                          const Icon(
                            Icons.arrow_upward,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 10),
                          const Text("Expense"),
                          const SizedBox(height: 6),
                          totalExpense.when(
                            data: (expense) => Text(
                              "₹${expense.toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                            ),
                            loading: () => const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            error: (error, stackTrace) =>
                                const Text("Failed to load"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              "This Month",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.green,
                          ),
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
                            error: (error, stackTrace) =>
                                const Text("Error"),
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
                          const Icon(
                            Icons.trending_down,
                            color: Colors.red,
                          ),
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
                            error: (error, stackTrace) =>
                                const Text("Error"),
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
                          const Icon(
                            Icons.savings,
                            color: Colors.blue,
                          ),
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
                            error: (error, stackTrace) =>
                                const Text("Error"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Transactions",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All"),
                ),
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
                      leading: CircleAvatar(
                        child: Icon(Icons.receipt_long),
                      ),
                      title: Text("No transactions yet"),
                      subtitle: Text(
                        "Add a transaction to get started.",
                      ),
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
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        title: Text(transaction.title),
                        subtitle: Text(
                          "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                        ),
                        trailing: Text(
                          "${transaction.isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
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
        ),
      ),
    );
  }
}