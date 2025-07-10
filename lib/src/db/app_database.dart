import 'dart:io';

import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:drift/drift.dart';
import 'package:tune_chord_sample/src/db/codeForms/code_forms.dart';
import 'package:tune_chord_sample/src/db/code_form_tags/code_form_tags.dart';
import 'package:tune_chord_sample/src/db/tag/tab.dart';
import 'package:tune_chord_sample/src/db/tuning_tags/tuning_tags.dart';
import 'package:tune_chord_sample/src/db/tunings/tunings.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

@DriftDatabase(tables: [Tunings, CodeForms, Tags, TuningTags, CodeFormTags])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
  // ---------- Tunings ----------
  Stream<List<Tuning>> watchTunings() => select(tunings).watch();
  Future<List<Tuning>> getAllTunings() => select(tunings).get();
  Future<Tuning> getTuningById(int id) =>
      (select(tunings)..where((t) => t.id.equals(id))).getSingle();
  Future<int> addTuning(TuningsCompanion tuning) =>
      into(tunings).insert(tuning);
  Future<bool> updateTuning(Tuning tuning) => update(tunings).replace(tuning);
  Future<void> deleteTuning(int id) =>
      (delete(tunings)..where((t) => t.id.equals(id))).go();

  // ---------- CodeForms ----------
  Stream<List<CodeForm>> watchCodeForms() => select(codeForms).watch();
  Future<List<CodeForm>> getAllCodeForms() => select(codeForms).get();
  Future<int> addCodeForm(CodeFormsCompanion form) =>
      into(codeForms).insert(form);
  Future<bool> updateCodeForm(CodeForm form) => update(codeForms).replace(form);
  Future<void> deleteCodeForm(int id) =>
      (delete(codeForms)..where((t) => t.id.equals(id))).go();

  // ---------- Tags ----------
  Stream<List<Tag>> watchTags() => select(tags).watch();
  Future<List<Tag>> getAllTags() => select(tags).get();
  Future<int> addTag(TagsCompanion tag) => into(tags).insert(tag);
  Future<bool> updateTag(Tag tag) => update(tags).replace(tag);
  Future<void> deleteTag(int id) =>
      (delete(tags)..where((t) => t.id.equals(id))).go();

  // ---------- TuningTags ----------
  Stream<List<TuningTag>> watchTuningTags() => select(tuningTags).watch();
  Future<List<TuningTag>> getAllTuningTags() => select(tuningTags).get();
  Future<int> addTuningTag(TuningTagsCompanion tag) =>
      into(tuningTags).insert(tag);
  Future<void> deleteTuningTag(int id) =>
      (delete(tuningTags)..where((t) => t.id.equals(id))).go();

  // ---------- CodeFormTags ----------
  Stream<List<CodeFormTag>> watchCodeFormTags() => select(codeFormTags).watch();
  Future<List<CodeFormTag>> getAllCodeFormTags() => select(codeFormTags).get();
  Future<int> addCodeFormTag(CodeFormTagsCompanion tag) =>
      into(codeFormTags).insert(tag);
  Future<void> deleteCodeFormTag(int id) =>
      (delete(codeFormTags)..where((t) => t.id.equals(id))).go();

  // ---------- Helper Methods for Tags ----------
  Future<List<Tag>> getTagsForTuning(int tuningId) async {
    final query = select(tags).join([
      innerJoin(tuningTags, tuningTags.tagId.equalsExp(tags.id)),
    ])..where(tuningTags.tuningId.equals(tuningId));
    
    final result = await query.get();
    return result.map((row) => row.readTable(tags)).toList();
  }

  Future<List<Tag>> getTagsForCodeForm(int codeFormId) async {
    final query = select(tags).join([
      innerJoin(codeFormTags, codeFormTags.tagId.equalsExp(tags.id)),
    ])..where(codeFormTags.codeFormId.equals(codeFormId));
    
    final result = await query.get();
    return result.map((row) => row.readTable(tags)).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
