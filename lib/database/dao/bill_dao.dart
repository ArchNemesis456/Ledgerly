import '../database.dart';

class BillDao {
  final AppDatabase database;

  BillDao(this.database);

  Future<List<Bill>> getBills() {
    return database.select(database.bills).get();
  }

  Stream<List<Bill>> watchBills() {
    return database.select(database.bills).watch();
  }

  Future<int> insertBill(
    BillsCompanion bill,
  ) {
    return database.into(database.bills).insert(bill);
  }

  Future<bool> updateBill(
    Bill bill,
  ) {
    return database.update(database.bills).replace(bill);
  }

  Future<int> deleteBill(
    Bill bill,
  ) {
    return database.delete(database.bills).delete(bill);
  }

  Future<int> deleteBillById(int id) {
    return (database.delete(database.bills)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}