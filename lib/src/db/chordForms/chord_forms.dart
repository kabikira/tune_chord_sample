import 'package:drift/drift.dart';

import 'package:tune_chord_sample/src/db/tunings/tunings.dart';

class ChordForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tuningId =>
      integer().references(Tunings, #id, onDelete: KeyAction.cascade)();
  TextColumn get fretPositions => text()(); // 例: "0,2,2,1,0,0"
  TextColumn get label => text().nullable()();
  TextColumn get memo => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
