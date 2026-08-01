import 'package:flutter/material.dart';
import '../../../database/database.dart';

class BillCard extends StatelessWidget {
  const BillCard({
    super.key,
    required this.bill,
    required this.onPaid,
    required this.onTap,
  });
  final Bill bill;
  final VoidCallback onPaid;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final overdue = !bill.paid && bill.dueDate.isBefore(DateTime.now());
    final color = bill.paid
        ? Colors.green
        : overdue
        ? Colors.red
        : Colors.orange;
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .15),
          child: Icon(
            bill.paid ? Icons.check : Icons.receipt_long,
            color: color,
          ),
        ),
        title: Text(bill.title),
        subtitle: Text(
          'Due ${MaterialLocalizations.of(context).formatMediumDate(bill.dueDate)} · ₹${bill.amount.toStringAsFixed(0)}',
        ),
        trailing: bill.paid
            ? const Chip(label: Text('Paid'))
            : IconButton(
                onPressed: onPaid,
                icon: const Icon(Icons.check_circle_outline),
                tooltip: 'Mark paid',
              ),
      ),
    );
  }
}
