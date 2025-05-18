import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

// TODO: AsyncNotifierに書き換え

final codeFormNotifierProvider =
    StateNotifierProvider<CodeFormNotifier, AsyncValue<List<CodeForm>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return CodeFormNotifier(db);
    });

class CodeFormNotifier extends StateNotifier<AsyncValue<List<CodeForm>>> {
  final AppDatabase db;

  CodeFormNotifier(this.db) : super(const AsyncValue.loading()) {
    _watchCodeForms();
  }

  void _watchCodeForms() {
    db.watchCodeForms().listen(
      (codeForms) => state = AsyncValue.data(codeForms),
      onError:
          (error, stackTrace) => state = AsyncValue.error(error, stackTrace),
    );
  }

  Future<void> addCodeForm({
    required int tuningId,
    required String fretPositions,
    required String label,
    String? memo,
  }) async {
    try {
      await db.addCodeForm(
        CodeFormsCompanion(
          tuningId: drift.Value(tuningId),
          fretPositions: drift.Value(fretPositions),
          label: drift.Value(label),
          memo: memo != null ? drift.Value(memo) : const drift.Value.absent(),
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateCodeForm(CodeForm codeForm) async {
    try {
      await db.updateCodeForm(codeForm);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteCodeForm(int id) async {
    try {
      await db.deleteCodeForm(id);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<List<CodeForm>> getCodeFormsByTuning(int tuningId) async {
    try {
      final allCodeForms = await db.getAllCodeForms();
      return allCodeForms.where((form) => form.tuningId == tuningId).toList();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return [];
    }
  }
}
