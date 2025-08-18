// Package imports:
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:resonance/src/db/app_database.dart';

part 'sample_data_manager.g.dart';

/// サンプルデータを管理するマネージャークラス
class SampleDataManager {
  final AppDatabase _database;

  SampleDataManager(this._database);

  /// サンプルチューニングとコードフォームを挿入
  Future<void> insertSampleData() async {
    // サンプルチューニングを挿入
    final tuningIds = await _insertSampleTunings();

    // 各チューニングにサンプルコードフォームを挿入
    for (int i = 0; i < tuningIds.length; i++) {
      await _insertSampleChordForms(tuningIds[i], i);
    }
  }

  /// サンプルチューニングを挿入
  Future<List<int>> _insertSampleTunings() async {
    final sampleTunings = [
      TuningsCompanion(
        name: const Value('Standard'),
        strings: const Value('EADGBE'),
        isFavorite: const Value(true),
      ),
      TuningsCompanion(
        name: const Value('Csus2'),
        strings: const Value('CGDGCD'),
        memo: const Value('Orkney/Sawmill'),
        isFavorite: const Value(false),
      ),
      TuningsCompanion(
        name: const Value('DDDDAA'),
        strings: const Value('DDDDAA'),
        memo: const Value('minimum/drone'),
        isFavorite: const Value(false),
      ),
    ];

    final tuningIds = <int>[];
    for (final tuning in sampleTunings) {
      final id = await _database.addTuning(tuning);
      tuningIds.add(id);
    }

    return tuningIds;
  }

  /// サンプルコードフォームを挿入
  Future<void> _insertSampleChordForms(int tuningId, int tuningIndex) async {
    List<ChordFormsCompanion> chordForms;

    switch (tuningIndex) {
      case 0: // スタンダードチューニング
        chordForms = [
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,2,2,2,0,x'),
            label: const Value('A major'),
            isFavorite: const Value(true),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('3,3,0,0,2,3'),
            label: const Value('G major'),
            isFavorite: const Value(false),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,1,0,2,3,x'),
            label: const Value('C major'),
            isFavorite: const Value(false),
          ),
        ];
        break;
      case 1: // オープンG
        chordForms = [
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,0,0,15,15,x'),
            memo: const Value('intro'),
            isFavorite: const Value(true),
          ),
        ];
        break;
      case 2: // Drop D
        chordForms = [
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,0,0,0,0,0'),
            label: const Value('D5'),
            isFavorite: const Value(true),
          ),
        ];
        break;
      default:
        chordForms = [];
    }

    for (final chordForm in chordForms) {
      await _database.addChordForm(chordForm);
    }
  }
}

/// SampleDataManagerのプロバイダー
@riverpod
SampleDataManager sampleDataManager(Ref ref) {
  final database = ref.read(appDatabaseProvider);
  return SampleDataManager(database);
}
