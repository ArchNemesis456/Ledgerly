import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return BudgetRepository(database);
});

final budgetStreamProvider = StreamProvider<List<Budget>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchBudgets();
});

final budgetDashboardProvider = Provider<BudgetDashboard>((ref) {
  final budgets =
      ref.watch(budgetStreamProvider).valueOrNull ?? const <Budget>[];
  return BudgetDashboard.fromBudgets(budgets);
});

class BudgetDashboard {
  const BudgetDashboard({
    required this.limit,
    required this.spent,
    required this.activeCount,
  });

  factory BudgetDashboard.fromBudgets(List<Budget> budgets) {
    final active = budgets.where((budget) => budget.isActive).toList();
    return BudgetDashboard(
      limit: active.fold(0, (total, budget) => total + budget.limitAmount),
      spent: active.fold(0, (total, budget) => total + budget.spentAmount),
      activeCount: active.length,
    );
  }

  final double limit;
  final double spent;
  final int activeCount;
  double get remaining => (limit - spent).clamp(0, double.infinity);
}
