import '../database.dart';

class SavingsGoalDao {
  SavingsGoalDao(this.database);
  final AppDatabase database;
  Stream<List<SavingsGoal>> watchGoals() => database.select(database.savingsGoals).watch();
  Future<int> insert(SavingsGoalsCompanion goal) => database.into(database.savingsGoals).insert(goal);
  Future<bool> update(SavingsGoal goal) => database.update(database.savingsGoals).replace(goal);
  Future<int> delete(SavingsGoal goal) => database.delete(database.savingsGoals).delete(goal);
}
