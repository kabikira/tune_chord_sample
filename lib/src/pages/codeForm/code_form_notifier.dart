import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

final codeFormNotifierProvider =
    StateNotifierProvider<CodeFormNotifier, AsyncValue<List<CodeForm>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return CodeFormNotifier(db);
    });

class CodeFormNotifier extends StateNotifier<AsyncValue<List<CodeForm>>> {
  final AppDatabase db;

  /// Creates a CodeFormNotifier that watches for changes in code forms list
  ///
  /// Initializes with loading state and immediately starts watching code forms
  CodeFormNotifier(this.db) : super(const AsyncValue.loading()) {
    _watchCodeForms();
  }

  /// Sets up a listener for code form changes in the database
  void _watchCodeForms() {
    db.watchCodeForms().listen(
      (codeForms) => state = AsyncValue.data(codeForms),
      onError:
          (error, stackTrace) => state = AsyncValue.error(error, stackTrace),
    );
  }

  /// Adds a new code form to the database
  ///
  /// [tuningId] The ID of the associated tuning
  /// [fretPositions] String representation of fret positions
  /// [label] Label for the chord form (e.g., "Em", "C", etc.)
  /// [memo] Optional notes about this chord form
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

  /// Updates an existing code form in the database
  ///
  /// [id] The ID of the code form to update
  /// [tuningId] The ID of the associated tuning
  /// [fretPositions] String representation of fret positions
  /// [label] Label for the chord form
  /// [memo] Optional notes about this chord form
  Future<void> updateCodeForm({
    required int id,
    required int tuningId,
    required String fretPositions,
    required String label,
    String? memo,
  }) async {
    try {
      final now = DateTime.now();
      await db.updateCodeForm(
        CodeForm(
          id: id,
          tuningId: tuningId,
          fretPositions: fretPositions,
          label: label,
          memo: memo,
          createdAt: now,
          updatedAt: now,
          isFavorite: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Deletes a code form from the database
  ///
  /// [id] The ID of the code form to delete
  Future<void> deleteCodeForm(int id) async {
    try {
      await db.deleteCodeForm(id);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Gets all code forms for a specific tuning
  ///
  /// [tuningId] The ID of the tuning to filter by
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
