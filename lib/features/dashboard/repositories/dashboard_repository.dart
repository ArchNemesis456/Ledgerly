import 'package:ledgerly/database/dao/transaction_dao.dart';
import 'package:ledgerly/database/database.dart';

class DashboardRepository {
  final TransactionDao _transactionDao;

  DashboardRepository(AppDatabase database)
      : _transactionDao = TransactionDao(database);

  Future<double> getTotalIncome() async {
    final transactions =
        await _transactionDao.getAllTransactions();

    double total = 0;

    for (final transaction in transactions) {
      if (transaction.isIncome) {
        total += transaction.amount;
      }
    }

    return total;
  }

  Future<double> getTotalExpense() async {
    final transactions =
        await _transactionDao.getAllTransactions();

    double total = 0;

    for (final transaction in transactions) {
      if (!transaction.isIncome) {
        total += transaction.amount;
      }
    }

    return total;
  }

  Future<double> getTotalBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();

    return income - expense;
  }

  Future<List<Transaction>> getRecentTransactions() async {
    final transactions =
        await _transactionDao.getAllTransactions();

    return transactions.take(5).toList();
  }
  Future<double> getMonthlyIncome() async {
    final transactions = await _transactionDao.getAllTransactions();

    final now = DateTime.now();

    double total = 0;

    for (final transaction in transactions) {
        if (transaction.isIncome &&
            transaction.date.month == now.month &&
            transaction.date.year == now.year) {
        total += transaction.amount;
        }
    }

    return total;
    }

    Future<double> getMonthlyExpense() async {
    final transactions = await _transactionDao.getAllTransactions();

    final now = DateTime.now();

    double total = 0;

    for (final transaction in transactions) {
        if (!transaction.isIncome &&
            transaction.date.month == now.month &&
            transaction.date.year == now.year) {
        total += transaction.amount;
        }
    }

    return total;
    }

    Future<double> getMonthlySavings() async {
        final income = await getMonthlyIncome();
        final expense = await getMonthlyExpense();

        return income - expense;
        }

        Future<Map<String, double>> getCategoryExpenses() async {
    final transactions =
        await _transactionDao.getAllTransactions();

    final Map<String, double> categoryTotals = {};

    for (final transaction in transactions) {
        if (transaction.isIncome) continue;

        final category = transaction.categoryId.toString();

        categoryTotals[category] =
            (categoryTotals[category] ?? 0) +
                transaction.amount;
    }

    return categoryTotals;
    }
}