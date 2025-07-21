import 'package:drift/drift.dart';

import 'package:tune_chord_sample/src/db/tag/tab.dart';
import 'package:tune_chord_sample/src/db/tunings/tunings.dart';

class TuningTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tuningId =>
      integer().references(Tunings, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
