import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bill_provider.dart';
import '../widgets/bill_card.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Bills & reminders')),
      body: bills.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No bills yet.'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: items
                    .map(
                      (bill) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BillCard(
                          bill: bill,
                          onTap: () {},
                          onPaid: () => ref
                              .read(billRepositoryProvider)
                              .update(bill.copyWith(paid: true)),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
