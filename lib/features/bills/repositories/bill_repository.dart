import '../../../database/dao/bill_dao.dart';
import '../../../database/database.dart';

class BillRepository {
  final BillDao _dao;

  BillRepository(AppDatabase database)
      : _dao = BillDao(database);

  Future<List<Bill>> getBills() {
    return _dao.getBills();
  }

  Stream<List<Bill>> watchBills() {
    return _dao.watchBills();
  }

  Future<int> addBill(
    BillsCompanion bill,
  ) {
    return _dao.insertBill(bill);
  }

  Future<bool> updateBill(
    Bill bill,
  ) {
    return _dao.updateBill(bill);
  }

  Future<int> deleteBill(
    Bill bill,
  ) {
    return _dao.deleteBill(bill);
  }

  Future<int> deleteBillById(int id) {
    return _dao.deleteBillById(id);
  }
}