import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/dashboard_repository.dart';

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