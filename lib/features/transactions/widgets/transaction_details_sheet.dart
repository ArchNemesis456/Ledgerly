import 'package:flutter/material.dart';
import '../../../database/database.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionDetailsSheet({
    super.key,
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? Colors.green : Colors.red;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 24),

            CircleAvatar(
              radius: 32,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(
                transaction.isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                size: 30,
                color: color,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              transaction.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "${transaction.isIncome ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("Date"),
              subtitle: Text(
                "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
              ),
            ),

            if (transaction.notes != null &&
                transaction.notes!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.notes),
                title: const Text("Notes"),
                subtitle: Text(transaction.notes!),
              ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text("Edit Transaction"),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}