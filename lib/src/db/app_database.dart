// Dart imports:
import 'dart:io';

// Package imports:
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

// Project imports:
import 'package:chord_fracture/src/db/chordForms/chord_forms.dart';
import 'package:chord_fracture/src/db/chord_form_tags/chord_form_tags.dart';
import 'package:chord_fracture/src/db/tag/tab.dart';
import 'package:chord_fracture/src/db/tuning_tags/tuning_tags.dart';
import 'package:chord_fracture/src/db/tunings/tunings.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

@DriftDatabase(tables: [Tunings, ChordForms, Tags, TuningTags, ChordFormTags])
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

  // ---------- ChordForms ----------
  Stream<List<ChordForm>> watchChordForms() => select(chordForms).watch();
  Future<List<ChordForm>> getAllChordForms() => select(chordForms).get();
  Future<ChordForm> getChordFormById(int id) =>
      (select(chordForms)..where((t) => t.id.equals(id))).getSingle();
  Future<int> addChordForm(ChordFormsCompanion form) =>
      into(chordForms).insert(form);
  Future<bool> updateChordForm(ChordForm form) => update(chordForms).replace(form);
  Future<void> deleteChordForm(int id) =>
      (delete(chordForms)..where((t) => t.id.equals(id))).go();

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

  // ---------- ChordFormTags ----------
  Stream<List<ChordFormTag>> watchChordFormTags() => select(chordFormTags).watch();
  Future<List<ChordFormTag>> getAllChordFormTags() => select(chordFormTags).get();
  Future<int> addChordFormTag(ChordFormTagsCompanion tag) =>
      into(chordFormTags).insert(tag);
  Future<void> deleteChordFormTag(int id) =>
      (delete(chordFormTags)..where((t) => t.id.equals(id))).go();

  // ---------- Helper Methods for Tags ----------
  Future<List<Tag>> getTagsForTuning(int tuningId) async {
    final query = select(tags).join([
      innerJoin(tuningTags, tuningTags.tagId.equalsExp(tags.id)),
    ])..where(tuningTags.tuningId.equals(tuningId));
    
    final result = await query.get();
    return result.map((row) => row.readTable(tags)).toList();
  }

  Future<List<Tag>> getTagsForChordForm(int chordFormId) async {
    final query = select(tags).join([
      innerJoin(chordFormTags, chordFormTags.tagId.equalsExp(tags.id)),
    ])..where(chordFormTags.chordFormId.equals(chordFormId));
    
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
