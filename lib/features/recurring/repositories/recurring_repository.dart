import '../../../database/dao/recurring_transaction_dao.dart';
import '../../../database/database.dart';

class RecurringRepository {
  RecurringRepository(AppDatabase database)
    : _dao = RecurringTransactionDao(database);
  final RecurringTransactionDao _dao;
  Stream<List<RecurringTransaction>> watch() => _dao.watchTransactions();
  Future<int> add(RecurringTransactionsCompanion item) => _dao.insert(item);
  Future<bool> update(RecurringTransaction item) => _dao.update(item);
  Future<int> delete(RecurringTransaction item) => _dao.delete(item);
}
