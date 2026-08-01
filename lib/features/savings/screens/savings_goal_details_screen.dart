import 'package:flutter/material.dart';
import '../../../database/database.dart';
import 'add_savings_goal_screen.dart';

class SavingsGoalDetailsScreen extends StatelessWidget {
  final SavingsGoal goal;

  const SavingsGoalDetailsScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);

    final remaining = (goal.targetAmount - goal.currentAmount).clamp(
      0.0,
      double.infinity,
    );

    final completed = goal.currentAmount >= goal.targetAmount;

    return Scaffold(
      appBar: AppBar(title: const Text("Savings Goal")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 900),
              builder: (_, value, _) {
                return SizedBox(
                  width: 170,
                  height: 170,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(value: value, strokeWidth: 12),
                      Center(
                        child: Text(
                          "${(value * 100).toStringAsFixed(0)}%",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            if (completed)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                builder: (_, value, _) {
                  return Transform.scale(
                    scale: value,
                    child: Card(
                      color: Colors.green.shade50,
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.emoji_events, color: Colors.amber),
                            SizedBox(width: 10),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "🏆 Congratulations!",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text("You've reached your savings goal."),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            Text(
              goal.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: const Icon(Icons.savings),
                title: const Text("Saved"),
                trailing: Text("₹${goal.currentAmount.toStringAsFixed(2)}"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Target"),
                trailing: Text("₹${goal.targetAmount.toStringAsFixed(2)}"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text("Remaining"),
                trailing: Text("₹${remaining.toStringAsFixed(2)}"),
              ),
            ),

            if (goal.deadline != null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_month),
                  title: const Text("Deadline"),
                  trailing: Text(
                    "${goal.deadline!.day}/${goal.deadline!.month}/${goal.deadline!.year}",
                  ),
                ),
              ),

            const Spacer(),
            if (!completed)
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Add Savings feature coming next."),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add Savings"),
              ),

            if (!completed) const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddSavingsGoalScreen(goal: goal),
                  ),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Goal"),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
