import 'package:drift/drift.dart';

class RecurringTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  IntColumn get accountId => integer()();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  TextColumn get interval => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
