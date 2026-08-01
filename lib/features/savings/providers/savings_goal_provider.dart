import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/savings_goal_repository.dart';

final savingsGoalRepositoryProvider = Provider<SavingsGoalRepository>(
  (ref) => SavingsGoalRepository(ref.watch(databaseProvider)),
);
final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>(
  (ref) => ref.watch(savingsGoalRepositoryProvider).watchGoals(),
);
