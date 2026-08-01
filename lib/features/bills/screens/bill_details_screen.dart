import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../providers/bill_provider.dart';
import 'add_bill_screen.dart';

class BillDetailsScreen extends ConsumerWidget {
  const BillDetailsScreen({super.key, required this.bill});
  final Bill bill;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('Bill details'),
      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddBillScreen(bill: bill)),
          ),
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Hero(
          tag: 'bill-${bill.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              bill.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Amount'),
                trailing: Text('₹${bill.amount.toStringAsFixed(2)}'),
              ),
              ListTile(
                title: const Text('Due date'),
                trailing: Text(
                  MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(bill.dueDate),
                ),
              ),
              ListTile(
                title: const Text('Reminder'),
                trailing: Text('${bill.reminderDays} days before'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (!bill.paid)
          FilledButton.icon(
            onPressed: () => ref
                .read(billRepositoryProvider)
                .updateBill(bill.copyWith(paid: true)),
            icon: const Icon(Icons.check),
            label: const Text('Mark as paid'),
          ),
        OutlinedButton.icon(
          onPressed: () async {
            final yes = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete bill?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (yes == true) {
              await ref.read(billRepositoryProvider).deleteBill(bill);
              if (context.mounted) Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Delete'),
        ),
      ],
    ),
  );
}
