import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/database.dart';
import '../../../database/database_provider.dart';
import '../repositories/recurring_repository.dart';

final recurringRepositoryProvider = Provider<RecurringRepository>(
  (ref) => RecurringRepository(ref.watch(databaseProvider)),
);
final recurringTransactionsProvider =
    StreamProvider<List<RecurringTransaction>>(
      (ref) => ref.watch(recurringRepositoryProvider).watch(),
    );
final upcomingRecurringProvider = Provider<List<RecurringTransaction>>(
  (ref) =>
      (ref.watch(recurringTransactionsProvider).valueOrNull ??
              const <RecurringTransaction>[])
          .where((item) => item.isActive)
          .toList(),
);
DateTime nextOccurrence(RecurringTransaction item, {DateTime? from}) {
  final date = from ?? DateTime.now();
  var candidate = item.startDate;
  while (candidate.isBefore(date)) {
    candidate = switch (item.interval) {
      'daily' => candidate.add(const Duration(days: 1)),
      'weekly' => candidate.add(const Duration(days: 7)),
      'yearly' => DateTime(candidate.year + 1, candidate.month, candidate.day),
      _ => DateTime(candidate.year, candidate.month + 1, candidate.day),
    };
  }
  return candidate;
}
