import '../../../database/database.dart';

class FinancialSnapshot {
  const FinancialSnapshot({
    required this.monthlyIncome,
    required this.monthlySpending,
    required this.budgetUsage,
    required this.topSpendingCategory,
    required this.highestExpense,
  });

  final double monthlyIncome;
  final double monthlySpending;
  final double budgetUsage;
  final String? topSpendingCategory;
  final Transaction? highestExpense;

  double get savingsRate => monthlyIncome == 0
      ? 0
      : ((monthlyIncome - monthlySpending) / monthlyIncome) * 100;

  int get healthScore {
    final savingsPoints = savingsRate.clamp(0, 30).round();
    final budgetPoints = (40 * (1 - budgetUsage.clamp(0, 1))).round();
    final spendingPoints =
        monthlyIncome == 0 || monthlySpending <= monthlyIncome ? 30 : 0;
    return (savingsPoints + budgetPoints + spendingPoints).clamp(0, 100);
  }
}

class FinancialIntelligenceService {
  const FinancialIntelligenceService();

  FinancialSnapshot calculate({
    required List<Transaction> transactions,
    required List<Budget> budgets,
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final monthly = transactions.where(
      (transaction) =>
          transaction.date.year == date.year &&
          transaction.date.month == date.month,
    );
    final income = monthly
        .where((transaction) => transaction.isIncome)
        .fold<double>(0, (total, transaction) => total + transaction.amount);
    final expenses = monthly
        .where((transaction) => !transaction.isIncome)
        .toList();
    final spending = expenses.fold<double>(
      0,
      (total, transaction) => total + transaction.amount,
    );
    final categories = <int, double>{};
    for (final expense in expenses) {
      categories.update(
        expense.categoryId,
        (total) => total + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    final top = categories.entries.isEmpty
        ? null
        : (categories.entries.toList()
                ..sort((left, right) => right.value.compareTo(left.value)))
              .first
              .key
              .toString();
    expenses.sort((left, right) => right.amount.compareTo(left.amount));
    final activeBudgets = budgets.where((budget) => budget.isActive).toList();
    final limit = activeBudgets.fold<double>(
      0,
      (total, budget) => total + budget.limitAmount,
    );
    final spent = activeBudgets.fold<double>(
      0,
      (total, budget) => total + budget.spentAmount,
    );
    return FinancialSnapshot(
      monthlyIncome: income,
      monthlySpending: spending,
      budgetUsage: limit == 0 ? 0 : spent / limit,
      topSpendingCategory: top,
      highestExpense: expenses.isEmpty ? null : expenses.first,
    );
  }
}
