// Package imports:
import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resonance/src/db/app_database.dart';

// TODO: AsyncNotifierに書き換え

final chordFormNotifierProvider =
    StateNotifierProvider<ChordFormNotifier, AsyncValue<List<ChordForm>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return ChordFormNotifier(db);
    });

class ChordFormNotifier extends StateNotifier<AsyncValue<List<ChordForm>>> {
  final AppDatabase db;

  ChordFormNotifier(this.db) : super(const AsyncValue.loading()) {
    _watchChordForms();
  }

  void _watchChordForms() {
    db.watchChordForms().listen(
      (chordForms) => state = AsyncValue.data(chordForms),
      onError:
          (error, stackTrace) => state = AsyncValue.error(error, stackTrace),
    );
  }

  Future<void> addChordForm({
    required int tuningId,
    required String fretPositions,
    String? label,
    String? memo,
  }) async {
    try {
      await db.addChordForm(
        ChordFormsCompanion(
          tuningId: drift.Value(tuningId),
          fretPositions: drift.Value(fretPositions),
          label:
              label != null ? drift.Value(label) : const drift.Value.absent(),
          memo: memo != null ? drift.Value(memo) : const drift.Value.absent(),
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateChordForm(ChordForm chordForm) async {
    try {
      await db.updateChordForm(chordForm);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteChordForm(int id) async {
    try {
      await db.deleteChordForm(id);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<ChordForm>> getChordFormsByTuning(int tuningId) async {
    try {
      final allChordForms = await db.getAllChordForms();
      return allChordForms.where((form) => form.tuningId == tuningId).toList();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return [];
    }
  }
}
