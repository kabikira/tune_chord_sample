// Package imports:
import 'package:drift/drift.dart';

// Project imports:
import 'package:resonance/src/db/chordForms/chord_forms.dart';
import 'package:resonance/src/db/tag/tab.dart';

class ChordFormTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chordFormId =>
      integer().references(ChordForms, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
