import '../database.dart';

class BudgetDao {
  final AppDatabase database;

  BudgetDao(this.database);

  Future<List<Budget>> getAllBudgets() {
    return database.select(database.budgets).get();
  }

  Stream<List<Budget>> watchBudgets() {
    return database.select(database.budgets).watch();
  }

  Future<int> insertBudget(BudgetsCompanion budget) {
    return database.into(database.budgets).insert(budget);
  }

  Future<bool> updateBudget(Budget budget) {
    return database.update(database.budgets).replace(budget);
  }

  Future<int> deleteBudget(Budget budget) {
    return database.delete(database.budgets).delete(budget);
  }

  Future<int> deleteBudgetById(int id) {
    return (database.delete(
      database.budgets,
    )..where((tbl) => tbl.id.equals(id))).go();
  }
}
