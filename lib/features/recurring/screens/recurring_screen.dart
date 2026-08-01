import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/recurring_provider.dart';

class RecurringScreen extends ConsumerWidget {
  const RecurringScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(recurringTransactionsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Recurring transactions')),
      body: items.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No recurring transactions yet.'))
            : ListView(
                children: list
                    .map(
                      (item) => ListTile(
                        title: Text(item.title),
                        subtitle: Text(
                          '${item.interval} · next ${MaterialLocalizations.of(context).formatMediumDate(nextOccurrence(item))}',
                        ),
                        trailing: Text('₹${item.amount.toStringAsFixed(0)}'),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
