import 'package:drift/drift.dart';

class Tunings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // チューニング名
  TextColumn get strings => text()(); // 例: "C,G,D,G,C,D
  TextColumn get memo => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
