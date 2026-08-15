import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../../bills/providers/bill_provider.dart';
import '../../budget/providers/budget_provider.dart';
import '../../recurring/providers/recurring_provider.dart';
import '../../savings/providers/savings_goal_provider.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../repositories/dashboard_repository.dart';
import '../services/financial_intelligence_service.dart';

final dashboardRepositoryProvider =
    Provider<DashboardRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return DashboardRepository(database);
});

final totalIncomeProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getTotalIncome();
});

final totalExpenseProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getTotalExpense();
});

final totalBalanceProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getTotalBalance();
});

final recentTransactionsProvider =
    FutureProvider<List<Transaction>>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getRecentTransactions();
});

final monthlyIncomeProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getMonthlyIncome();
});

final monthlyExpenseProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getMonthlyExpense();
});

final monthlySavingsProvider =
    FutureProvider<double>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getMonthlySavings();
});

final categoryExpenseProvider =
    FutureProvider<Map<String, double>>((ref) async {
  return ref
      .watch(dashboardRepositoryProvider)
      .getCategoryExpenses();
});

/// ------------------------------------------------------------
/// Sprint 8 - Budget Summary
/// ------------------------------------------------------------

final dashboardBudgetProvider = Provider<BudgetDashboard>((ref) {
  return ref.watch(budgetDashboardProvider);
});

/// ------------------------------------------------------------
/// Sprint 8 - Savings Summary
/// ------------------------------------------------------------

class SavingsDashboardSummary {
  const SavingsDashboardSummary({
    required this.target,
    required this.saved,
    required this.goalCount,
    required this.completedCount,
  });

  final double target;
  final double saved;
  final int goalCount;
  final int completedCount;

  double get remaining =>
      (target - saved).clamp(0, double.infinity);

  double get progress {
    if (target <= 0) {
      return 0;
    }

    return (saved / target).clamp(0, 1);
  }
}

final savingsDashboardProvider =
    Provider<SavingsDashboardSummary>((ref) {
  final goals =
      ref.watch(savingsGoalsProvider).valueOrNull ??
          const <SavingsGoal>[];

  final target = goals.fold<double>(
    0,
    (total, goal) => total + goal.targetAmount,
  );

  final saved = goals.fold<double>(
    0,
    (total, goal) => total + goal.currentAmount,
  );

  final completedCount =
      goals.where((goal) => goal.completed).length;

  return SavingsDashboardSummary(
    target: target,
    saved: saved,
    goalCount: goals.length,
    completedCount: completedCount,
  );
});

/// ------------------------------------------------------------
/// Sprint 8 - Bills Summary
/// ------------------------------------------------------------

class BillsDashboardSummary {
  const BillsDashboardSummary({
    required this.upcoming,
    required this.overdue,
    required this.unpaidTotal,
  });

  final int upcoming;
  final int overdue;
  final double unpaidTotal;
}

final billsDashboardProvider =
    Provider<BillsDashboardSummary>((ref) {
  final bills =
      ref.watch(billsProvider).valueOrNull ??
          const <Bill>[];

  final upcoming =
      ref.watch(upcomingBillsProvider);

  final overdue =
      ref.watch(overdueBillsProvider);

  final unpaidTotal = bills
      .where((bill) => !bill.paid)
      .fold<double>(
        0,
        (total, bill) => total + bill.amount,
      );

  return BillsDashboardSummary(
    upcoming: upcoming.length,
    overdue: overdue.length,
    unpaidTotal: unpaidTotal,
  );
});

/// ------------------------------------------------------------
/// Sprint 8 - Recurring Summary
/// ------------------------------------------------------------

class RecurringDashboardSummary {
  const RecurringDashboardSummary({
    required this.activeCount,
    required this.monthlyAmount,
  });

  final int activeCount;
  final double monthlyAmount;
}

final recurringDashboardProvider =
    Provider<RecurringDashboardSummary>((ref) {
  final recurring =
      ref.watch(recurringTransactionsProvider).valueOrNull ??
          const <RecurringTransaction>[];

  final active =
      recurring.where((item) => item.isActive).toList();

  double monthlyAmount = 0;

  for (final item in active) {
    switch (item.interval) {
      case 'daily':
        monthlyAmount += item.amount * 30;
        break;

      case 'weekly':
        monthlyAmount += item.amount * 4.33;
        break;

      case 'yearly':
        monthlyAmount += item.amount / 12;
        break;

      case 'monthly':
      default:
        monthlyAmount += item.amount;
        break;
    }
  }

  return RecurringDashboardSummary(
    activeCount: active.length,
    monthlyAmount: monthlyAmount,
  );
});

/// ------------------------------------------------------------
/// Sprint 8 - Financial Intelligence
/// ------------------------------------------------------------

final financialSnapshotProvider =
    Provider<FinancialSnapshot>((ref) {
  final transactions =
      ref.watch(transactionListProvider).valueOrNull ??
          const <Transaction>[];

  final budgets =
      ref.watch(budgetStreamProvider).valueOrNull ??
          const <Budget>[];

  return const FinancialIntelligenceService().calculate(
    transactions: transactions,
    budgets: budgets,
  );
});