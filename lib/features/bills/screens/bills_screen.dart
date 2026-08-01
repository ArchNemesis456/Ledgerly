import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bill_provider.dart';
import '../widgets/bill_card.dart';
import 'add_bill_screen.dart';
import 'bill_details_screen.dart';

class BillsScreen extends ConsumerWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(billsProvider);
    final upcoming = ref.watch(upcomingBillsProvider);
    final overdue = ref.watch(overdueBillsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bills & Reminders')),

      body: bills.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (error, _) => Center(child: Text(error.toString())),

        data: (_) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (overdue.isNotEmpty) ...[
                Text(
                  "Overdue Bills",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 12),

                ...overdue.map(
                  (bill) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BillCard(
                      bill: bill,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BillDetailsScreen(bill: bill),
                        ),
                      ),
                      onPaid: () async {
                        await ref
                            .read(billRepositoryProvider)
                            .updateBill(bill.copyWith(paid: true));
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 28),
              ],

              Text(
                "Upcoming Bills",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              if (upcoming.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("No upcoming bills."),
                  ),
                ),

              ...upcoming.map(
                (bill) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BillCard(
                    bill: bill,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillDetailsScreen(bill: bill),
                      ),
                    ),
                    onPaid: () async {
                      await ref
                          .read(billRepositoryProvider)
                          .updateBill(bill.copyWith(paid: true));
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBillScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Bill"),
      ),
    );
  }
}
