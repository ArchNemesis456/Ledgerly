import '../../../database/dao/savings_goal_dao.dart';
import '../../../database/database.dart';

class SavingsGoalRepository {
  SavingsGoalRepository(AppDatabase database) : _dao = SavingsGoalDao(database);
  final SavingsGoalDao _dao;
  Stream<List<SavingsGoal>> watchGoals() => _dao.watchGoals();
  Future<int> add(SavingsGoalsCompanion goal) => _dao.insert(goal);
  Future<bool> update(SavingsGoal goal) => _dao.update(goal);
  Future<int> delete(SavingsGoal goal) => _dao.delete(goal);
}
