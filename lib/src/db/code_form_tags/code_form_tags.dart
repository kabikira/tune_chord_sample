import 'package:drift/drift.dart';
import 'package:tune_chord_sample/src/db/codeForms/code_forms.dart';
import 'package:tune_chord_sample/src/db/tag/tab.dart';

class CodeFormTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get codeFormId =>
      integer().references(CodeForms, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(Tags, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
