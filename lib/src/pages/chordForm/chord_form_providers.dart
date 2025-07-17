import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

// 単一のチューニングを取得するためのプロバイダー
final singleTuningProvider = FutureProvider.family<Tuning, int>((
  ref,
  tuningId,
) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getTuningById(tuningId);
});

// chordFormIdからtuning.stringsを取得するプロバイダー
final tuningStringsFromChordFormProvider = FutureProvider.family<String, int>((
  ref,
  chordFormId,
) async {
  final db = ref.watch(appDatabaseProvider);
  final chordForm = await db.getChordFormById(chordFormId);
  final tuning = await db.getTuningById(chordForm.tuningId);
  return tuning.strings;
});