import '../database.dart';

class BillDao {
  BillDao(this.database);
  final AppDatabase database;
  Stream<List<Bill>> watchBills() => database.select(database.bills).watch();
  Future<int> insert(BillsCompanion bill) =>
      database.into(database.bills).insert(bill);
  Future<bool> update(Bill bill) =>
      database.update(database.bills).replace(bill);
  Future<int> delete(Bill bill) => database.delete(database.bills).delete(bill);
}
