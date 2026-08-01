import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryExpenseChart extends StatelessWidget {
  final Map<String, double> expenses;

  const CategoryExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text("No expense data available")),
        ),
      );
    }

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    final total = expenses.values.fold<double>(0, (sum, value) => sum + value);

    final entries = expenses.entries.toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Expenses by Category",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 55,
                  sectionsSpace: 3,
                  sections: List.generate(entries.length, (index) {
                    final entry = entries[index];

                    return PieChartSectionData(
                      color: colors[index % colors.length],
                      value: entry.value,
                      title:
                          "${((entry.value / total) * 100).toStringAsFixed(0)}%",
                      radius: 75,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Column(
              children: List.generate(entries.length, (index) {
                final entry = entries[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors[index % colors.length],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(entry.key)),
                      Text(
                        "₹${entry.value.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
