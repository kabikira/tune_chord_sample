import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

final tuningNotifierProvider =
    StateNotifierProvider<TuningNotifier, AsyncValue<List<Tuning>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return TuningNotifier(db);
    });

class TuningNotifier extends StateNotifier<AsyncValue<List<Tuning>>> {
  final AppDatabase db;

  TuningNotifier(this.db) : super(const AsyncValue.loading()) {
    _watchTunings();
  }

  void _watchTunings() {
    db.watchTunings().listen(
      (tunings) {
        state = AsyncValue.data(tunings);
      },
      onError: (e, st) {
        state = AsyncValue.error(e, st);
      },
    );
  }

  Future<void> addTuning(String name, String strings) async {
    try {
      await db.addTuning(
        TuningsCompanion(name: Value(name), strings: Value(strings)),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
