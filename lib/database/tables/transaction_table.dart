import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text()();

  RealColumn get amount => real()();

  BoolColumn get isIncome =>
      boolean().withDefault(const Constant(false))();

  IntColumn get accountId => integer()();

  IntColumn get categoryId => integer()();

  DateTimeColumn get date =>
      dateTime().withDefault(currentDateAndTime)();

  TextColumn get notes => text().nullable()();
}