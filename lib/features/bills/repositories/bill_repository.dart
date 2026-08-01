import '../../../database/dao/bill_dao.dart';
import '../../../database/database.dart';

class BillRepository {
  BillRepository(AppDatabase database) : _dao = BillDao(database);
  final BillDao _dao;
  Stream<List<Bill>> watchBills() => _dao.watchBills();
  Future<int> add(BillsCompanion bill) => _dao.insert(bill);
  Future<bool> update(Bill bill) => _dao.update(bill);
  Future<int> delete(Bill bill) => _dao.delete(bill);
}
