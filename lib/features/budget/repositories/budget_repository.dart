import '../../../database/dao/budget_dao.dart';
import '../../../database/database.dart';

class BudgetRepository {
  final BudgetDao _budgetDao;

  BudgetRepository(AppDatabase database) : _budgetDao = BudgetDao(database);

  Future<List<Budget>> getBudgets() {
    return _budgetDao.getAllBudgets();
  }

  Stream<List<Budget>> watchBudgets() {
    return _budgetDao.watchBudgets();
  }

  Future<int> addBudget(BudgetsCompanion budget) {
    return _budgetDao.insertBudget(budget);
  }

  Future<bool> updateBudget(Budget budget) {
    return _budgetDao.updateBudget(budget);
  }

  Future<int> deleteBudget(Budget budget) {
    return _budgetDao.deleteBudget(budget);
  }

  Future<int> deleteBudgetById(int id) {
    return _budgetDao.deleteBudgetById(id);
  }
}
