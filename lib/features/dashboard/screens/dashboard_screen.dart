import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../home/providers/home_navigation_provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/income_expense_cards.dart';
import '../widgets/monthly_summary_cards.dart';
import '../widgets/recent_transactions_card.dart';
import '../widgets/category_expense_chart.dart';

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
    final categoryExpenses = ref.watch(categoryExpenseProvider);
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
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Total Balance Card
            BalanceCard(totalBalance: totalBalance),

            const SizedBox(height: 25),

            // Income & Expense
            IncomeExpenseCards(
              totalIncome: totalIncome,
              totalExpense: totalExpense,
            ),

            const SizedBox(height: 30),

            Text(
              "This Month",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            MonthlySummaryCards(
              monthlyIncome: monthlyIncome,
              monthlyExpense: monthlyExpense,
              monthlySavings: monthlySavings,
            ),

            FilledButton.icon(
              onPressed: () {
                context.go(AppRoutes.budget);
              },
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text("Manage Budgets"),
            ),

            const SizedBox(height: 30),

            categoryExpenses.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Failed to load chart"),
                ),
              ),
              data: (data) => CategoryExpenseChart(expenses: data),
            ),

            const SizedBox(height: 30),

            RecentTransactionsCard(
              recentTransactions: recentTransactions,
              onViewAll: () {
                ref.read(homeNavigationProvider.notifier).state = 1;
              },
            ),
          ],
        ),
      ),
    );
  }
}
