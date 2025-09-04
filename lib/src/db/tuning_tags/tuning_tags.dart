// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:chord_fracture/src/db/tag/tab.dart';
import 'package:chord_fracture/src/db/tunings/tunings.dart';

class TuningTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tuningId =>
      integer().references(Tunings, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
