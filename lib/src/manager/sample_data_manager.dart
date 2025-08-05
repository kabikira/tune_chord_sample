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
        name: const Value('スタンダード'),
        strings: const Value('E,A,D,G,B,E'),
        memo: const Value('最も一般的なギターチューニング'),
        isFavorite: const Value(true),
      ),
      TuningsCompanion(
        name: const Value('オープンG'),
        strings: const Value('D,G,D,G,B,D'),
        memo: const Value('スライドギターに適したオープンチューニング'),
        isFavorite: const Value(false),
      ),
      TuningsCompanion(
        name: const Value('Drop D'),
        strings: const Value('D,A,D,G,B,E'),
        memo: const Value('6弦を1音下げたロック・メタル系チューニング'),
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
            memo: const Value('基本的なAメジャーコード'),
            isFavorite: const Value(true),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('3,3,0,0,2,3'),
            label: const Value('G major'),
            memo: const Value('基本的なGメジャーコード'),
            isFavorite: const Value(false),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,1,0,2,3,x'),
            label: const Value('C major'),
            memo: const Value('基本的なCメジャーコード'),
            isFavorite: const Value(false),
          ),
        ];
        break;
      case 1: // オープンG
        chordForms = [
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,0,0,0,0,0'),
            label: const Value('G major'),
            memo: const Value('オープンGメジャーコード'),
            isFavorite: const Value(true),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('5,5,5,5,5,5'),
            label: const Value('C major'),
            memo: const Value('5フレットでのCメジャーコード'),
            isFavorite: const Value(false),
          ),
        ];
        break;
      case 2: // Drop D
        chordForms = [
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('2,3,2,0,0,0'),
            label: const Value('D major'),
            memo: const Value('Drop DでのDメジャーコード'),
            isFavorite: const Value(true),
          ),
          ChordFormsCompanion(
            tuningId: Value(tuningId),
            fretPositions: const Value('0,2,2,2,0,x'),
            label: const Value('A major'),
            memo: const Value('Drop DでのAメジャーコード'),
            isFavorite: const Value(false),
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