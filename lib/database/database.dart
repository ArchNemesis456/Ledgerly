import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/budget_table.dart';
import 'tables/bill_table.dart';
import 'tables/recurring_transaction_table.dart';
import 'tables/savings_goal_table.dart';
import 'tables/account_table.dart';
import 'tables/category_table.dart';
import 'tables/transaction_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Accounts,
    Categories,
    Transactions,
    Budgets,
    SavingsGoals,
    RecurringTransactions,
    Bills,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await customStatement(
          "ALTER TABLE budgets ADD COLUMN category TEXT NOT NULL DEFAULT 'General'",
        );
        await customStatement(
          'ALTER TABLE budgets ADD COLUMN limit_amount REAL NOT NULL DEFAULT 0',
        );
        await customStatement(
          'ALTER TABLE budgets ADD COLUMN spent_amount REAL NOT NULL DEFAULT 0',
        );
        await customStatement(
          'UPDATE budgets SET limit_amount = amount WHERE limit_amount = 0',
        );
        await migrator.createTable(savingsGoals);
        await migrator.createTable(recurringTransactions);
        await migrator.createTable(bills);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'ledgerly.db'));

    return NativeDatabase(file);
  });
}
