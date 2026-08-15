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
    final recentTransactions =
        ref.watch(recentTransactionsProvider);

    final monthlyIncome =
        ref.watch(monthlyIncomeProvider);
    final monthlyExpense =
        ref.watch(monthlyExpenseProvider);
    final monthlySavings =
        ref.watch(monthlySavingsProvider);

    final categoryExpenses =
        ref.watch(categoryExpenseProvider);

    final budget = ref.watch(dashboardBudgetProvider);
    final savings = ref.watch(savingsDashboardProvider);
    final bills = ref.watch(billsDashboardProvider);
    final recurring =
        ref.watch(recurringDashboardProvider);
    final financial =
        ref.watch(financialSnapshotProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Good Evening 👋",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              "Welcome Back!",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 30),

            BalanceCard(
              totalBalance: totalBalance,
            ),

            const SizedBox(height: 25),

            IncomeExpenseCards(
              totalIncome: totalIncome,
              totalExpense: totalExpense,
            ),

            const SizedBox(height: 30),

            Text(
              "This Month",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            MonthlySummaryCards(
              monthlyIncome: monthlyIncome,
              monthlyExpense: monthlyExpense,
              monthlySavings: monthlySavings,
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                context.go(AppRoutes.budget);
              },
              icon: const Icon(
                Icons.account_balance_wallet,
              ),
              label: const Text("Manage Budgets"),
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// BUDGET SUMMARY
            /// ------------------------------------------------

            _SectionTitle(
              title: "Budget Overview",
              icon: Icons.pie_chart_outline,
            ),

            const SizedBox(height: 12),

            _SummaryGrid(
              children: [
                _MetricCard(
                  title: "Budget Limit",
                  value:
                      "₹${budget.limit.toStringAsFixed(0)}",
                  icon: Icons.account_balance_wallet,
                ),
                _MetricCard(
                  title: "Spent",
                  value:
                      "₹${budget.spent.toStringAsFixed(0)}",
                  icon: Icons.trending_down,
                ),
                _MetricCard(
                  title: "Remaining",
                  value:
                      "₹${budget.remaining.toStringAsFixed(0)}",
                  icon: Icons.savings_outlined,
                ),
                _MetricCard(
                  title: "Active Budgets",
                  value:
                      budget.activeCount.toString(),
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// SAVINGS SUMMARY
            /// ------------------------------------------------

            _SectionTitle(
              title: "Savings Goals",
              icon: Icons.savings_outlined,
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Overall Progress",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${(savings.progress * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: savings.progress,
                        minHeight: 10,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saved ₹${savings.saved.toStringAsFixed(0)}",
                        ),
                        Text(
                          "Target ₹${savings.target.toStringAsFixed(0)}",
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${savings.goalCount} goals · ${savings.completedCount} completed",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// BILLS
            /// ------------------------------------------------

            _SectionTitle(
              title: "Bills & Reminders",
              icon: Icons.receipt_long_outlined,
            ),

            const SizedBox(height: 12),

            _SummaryGrid(
              children: [
                _MetricCard(
                  title: "Upcoming",
                  value: bills.upcoming.toString(),
                  icon: Icons.event,
                ),
                _MetricCard(
                  title: "Overdue",
                  value: bills.overdue.toString(),
                  icon: Icons.warning_amber_rounded,
                ),
                _MetricCard(
                  title: "Unpaid",
                  value:
                      "₹${bills.unpaidTotal.toStringAsFixed(0)}",
                  icon: Icons.pending_actions,
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// RECURRING TRANSACTIONS
            /// ------------------------------------------------

            _SectionTitle(
              title: "Recurring Transactions",
              icon: Icons.repeat,
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.repeat),
                ),
                title: Text(
                  "${recurring.activeCount} active recurring transactions",
                ),
                subtitle: Text(
                  "≈ ₹${recurring.monthlyAmount.toStringAsFixed(0)} per month",
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// FINANCIAL HEALTH
            /// ------------------------------------------------

            _SectionTitle(
              title: "Financial Health",
              icon: Icons.favorite_outline,
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 90,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CircularProgressIndicator(
                                value:
                                    financial.healthScore /
                                        100,
                                strokeWidth: 9,
                              ),
                              Center(
                                child: Text(
                                  financial.healthScore
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                _healthLabel(
                                  financial.healthScore,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "Savings rate: ${financial.savingsRate.toStringAsFixed(1)}%",
                              ),

                              const SizedBox(height: 4),

                              Text(
                                "Budget usage: ${(financial.budgetUsage * 100).toStringAsFixed(1)}%",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Divider(),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _SmallInsight(
                            label: "Monthly Spending",
                            value:
                                "₹${financial.monthlySpending.toStringAsFixed(0)}",
                          ),
                        ),
                        Expanded(
                          child: _SmallInsight(
                            label: "Top Category",
                            value:
                                financial.topSpendingCategory ??
                                    "None",
                          ),
                        ),
                      ],
                    ),

                    if (financial.highestExpense != null) ...[
                      const SizedBox(height: 14),
                      _SmallInsight(
                        label: "Highest Expense",
                        value:
                            "${financial.highestExpense!.title} · ₹${financial.highestExpense!.amount.toStringAsFixed(0)}",
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// CATEGORY CHART
            /// ------------------------------------------------

            categoryExpenses.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, _) => const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Failed to load chart",
                  ),
                ),
              ),
              data: (data) =>
                  CategoryExpenseChart(
                expenses: data,
              ),
            ),

            const SizedBox(height: 30),

            /// ------------------------------------------------
            /// RECENT TRANSACTIONS
            /// ------------------------------------------------

            RecentTransactionsCard(
              recentTransactions:
                  recentTransactions,
              onViewAll: () {
                ref
                    .read(
                      homeNavigationProvider
                          .notifier,
                    )
                    .state = 1;
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _healthLabel(int score) {
    if (score >= 80) {
      return "Excellent";
    }

    if (score >= 60) {
      return "Good";
    }

    if (score >= 40) {
      return "Needs Attention";
    }

    return "At Risk";
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 650 ? 4 : 2;

        final width =
            (constraints.maxWidth -
                    ((columns - 1) * 12)) /
                columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: children
              .map(
                (child) => SizedBox(
                  width: width,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallInsight extends StatelessWidget {
  const _SmallInsight({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}