import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/savings_goal_provider.dart';
import '../widgets/savings_goal_card.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(savingsGoalsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Savings goals')),
      body: goals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) => items.isEmpty
            ? const Center(child: Text('Create a goal to start saving.'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: items
                    .map(
                      (goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SavingsGoalCard(goal: goal, onTap: () {}),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
