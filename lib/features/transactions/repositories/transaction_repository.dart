import 'package:ledgerly/database/dao/transaction_dao.dart';
import 'package:ledgerly/database/database.dart';

class TransactionRepository {
  final TransactionDao _transactionDao;

  TransactionRepository(AppDatabase database)
    : _transactionDao = TransactionDao(database);

  Stream<List<Transaction>> watchTransactions() {
    return _transactionDao.watchAllTransactions();
  }

  Future<List<Transaction>> getTransactions() {
    return _transactionDao.getAllTransactions();
  }

  Future<int> addTransaction(TransactionsCompanion transaction) {
    return _transactionDao.insertTransaction(transaction);
  }

  Future<bool> updateTransaction(Transaction transaction) {
    return _transactionDao.updateTransaction(transaction);
  }

  Future<int> deleteTransaction(Transaction transaction) {
    return _transactionDao.deleteTransaction(transaction);
  }

  Future<int> deleteTransactionById(int id) {
    return _transactionDao.deleteTransactionById(id);
  }
}
