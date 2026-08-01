import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/bill_repository.dart';

final billRepositoryProvider = Provider<BillRepository>(
  (ref) => BillRepository(ref.watch(databaseProvider)),
);
final billsProvider = StreamProvider<List<Bill>>(
  (ref) => ref.watch(billRepositoryProvider).watchBills(),
);
final upcomingBillsProvider = Provider<List<Bill>>((ref) {
  final now = DateTime.now();
  return (ref.watch(billsProvider).valueOrNull ?? const <Bill>[])
      .where(
        (bill) =>
            !bill.paid &&
            !bill.dueDate.isBefore(DateTime(now.year, now.month, now.day)),
      )
      .toList();
});
final overdueBillsProvider = Provider<List<Bill>>((ref) {
  final now = DateTime.now();
  return (ref.watch(billsProvider).valueOrNull ?? const <Bill>[])
      .where(
        (bill) =>
            !bill.paid &&
            bill.dueDate.isBefore(DateTime(now.year, now.month, now.day)),
      )
      .toList();
});
