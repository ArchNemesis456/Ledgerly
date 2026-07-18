import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final VoidCallback? onTap;

  const TransactionCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      elevation: 2,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            isIncome
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${date.day}/${date.month}/${date.year}",
        ),
        trailing: Text(
          "${isIncome ? "+" : "-"}₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}