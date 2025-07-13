import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

// TODO: AsyncNotifierに書き換え

final tuningNotifierProvider =
    StateNotifierProvider<TuningNotifier, AsyncValue<List<Tuning>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return TuningNotifier(db);
    });

// タグの状態を管理するプロバイダー
final tagsProvider = StreamProvider<List<Tag>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchTags();
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

  Future<void> addTuning(
    String name,
    String strings, {
    List<int>? tagIds,
  }) async {
    try {
      // 空文字列の場合はデフォルト値を設定
      final finalName = name.isEmpty ? 'No TuningName' : name;
      final tuningId = await db.addTuning(
        TuningsCompanion(name: Value(finalName), strings: Value(strings)),
      );

      if (tagIds != null && tagIds.isNotEmpty) {
        for (final tagId in tagIds) {
          await db.addTuningTag(
            TuningTagsCompanion(tuningId: Value(tuningId), tagId: Value(tagId)),
          );
        }
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTuning({
    required int id,
    required String name,
    required String strings,
    List<int>? tagIds,
  }) async {
    try {
      final tunings = await db.getAllTunings();
      final existingTuning = tunings.firstWhere(
        (tuning) => tuning.id == id,
        orElse: () => throw Exception('チューニングが見つかりません'),
      );

      // 空文字列の場合はデフォルト値を設定
      final finalName = name.isEmpty ? 'Untitled Tuning' : name;
      await db.updateTuning(
        Tuning(
          id: id,
          name: finalName,
          strings: strings,
          memo: existingTuning.memo,
          isFavorite: existingTuning.isFavorite,
          userId: existingTuning.userId,
          createdAt: existingTuning.createdAt,
          updatedAt: DateTime.now(),
        ),
      );

      // 既存のタグを削除
      final existingTags = await db.getAllTuningTags();
      for (final tag in existingTags.where((t) => t.tuningId == id)) {
        await db.deleteTuningTag(tag.id);
      }

      // 新しいタグを追加
      if (tagIds != null && tagIds.isNotEmpty) {
        for (final tagId in tagIds) {
          await db.addTuningTag(
            TuningTagsCompanion(tuningId: Value(id), tagId: Value(tagId)),
          );
        }
      }
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
