import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

// TODO: AsyncNotifierに書き換え

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

  Future<void> updateTuning({
    required int id,
    required String name,
    required String strings,
  }) async {
    try {
      await db.updateTuning(
        Tuning(
          id: id,
          name: name,
          strings: strings,
          memo: null,
          isFavorite: false,
          userId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTuning(int id) async {
    try {
      await db.deleteTuning(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
