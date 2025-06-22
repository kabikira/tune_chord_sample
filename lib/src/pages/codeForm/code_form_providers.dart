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