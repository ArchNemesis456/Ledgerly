import 'package:drift/drift.dart';
import '../tables/transaction_table.dart';
import '../database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  // Watch all transactions
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(
      transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }

  // Get all transactions once
  Future<List<Transaction>> getAllTransactions() {
    return (select(
      transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.date)])).get();
  }

  // Insert a transaction
  Future<int> insertTransaction(TransactionsCompanion transaction) {
    return into(transactions).insert(transaction);
  }

  // Update a transaction
  Future<bool> updateTransaction(Transaction transaction) {
    return update(transactions).replace(transaction);
  }

  // Delete a transaction
  Future<int> deleteTransaction(Transaction transaction) {
    return delete(transactions).delete(transaction);
  }

  // Delete by ID
  Future<int> deleteTransactionById(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }
}
