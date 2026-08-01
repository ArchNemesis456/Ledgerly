import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/transaction_repository.dart';
import '../models/transaction_filter.dart';

final transactionFilterProvider = StateProvider<TransactionFilter>(
  (ref) => TransactionFilter.all,
);

final transactionSortProvider = StateProvider<TransactionSort>(
  (ref) => TransactionSort.newest,
);
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return TransactionRepository(database);
});

final transactionListProvider = StreamProvider<List<Transaction>>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);

  return repository.watchTransactions();
});

final transactionCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final transactions = await repository.getTransactions();
  return transactions.length;
});

final totalIncomeProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final transactions = await repository.getTransactions();

  return transactions
      .where((t) => t.isIncome)
      .fold<double>(0.0, (sum, t) => sum + t.amount);
});

final totalExpenseProvider = FutureProvider<double>((ref) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final transactions = await repository.getTransactions();

  return transactions
      .where((t) => !t.isIncome)
      .fold<double>(0.0, (sum, t) => sum + t.amount);
});
