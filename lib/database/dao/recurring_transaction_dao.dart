import '../database.dart';

class RecurringTransactionDao {
  RecurringTransactionDao(this.database);
  final AppDatabase database;
  Stream<List<RecurringTransaction>> watchTransactions() =>
      database.select(database.recurringTransactions).watch();
  Future<int> insert(RecurringTransactionsCompanion transaction) =>
      database.into(database.recurringTransactions).insert(transaction);
  Future<bool> update(RecurringTransaction transaction) =>
      database.update(database.recurringTransactions).replace(transaction);
  Future<int> delete(RecurringTransaction transaction) =>
      database.delete(database.recurringTransactions).delete(transaction);
}
