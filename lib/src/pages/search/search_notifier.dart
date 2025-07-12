import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/search/search_page.dart';

// タグ取得用プロバイダー
final tuningTagsProvider = FutureProvider.family<List<Tag>, int>((ref, tuningId) async {
  final db = ref.watch(appDatabaseProvider);
  return await db.getTagsForTuning(tuningId);
});

final codeFormTagsProvider = FutureProvider.family<List<Tag>, int>((ref, codeFormId) async {
  final db = ref.watch(appDatabaseProvider);
  return await db.getTagsForCodeForm(codeFormId);
});

// チューニング検索プロバイダー
final tuningSearchProvider = FutureProvider.family<List<Tuning>, String>((ref, query) async {
  final db = ref.watch(appDatabaseProvider);
  if (query.isEmpty) return [];
  
  final tunings = await db.getAllTunings();
  final searchQuery = query.toLowerCase();
  
  // 名前と文字列による検索
  final directMatches = tunings.where((tuning) {
    final name = tuning.name.toLowerCase();
    final strings = tuning.strings.toLowerCase();
    return name.contains(searchQuery) || strings.contains(searchQuery);
  }).toList();
  
  // タグによる検索
  final tags = await db.getAllTags();
  final matchingTags = tags.where((tag) => 
    tag.name.toLowerCase().contains(searchQuery)
  ).toList();
  
  final tagMatches = <Tuning>[];
  for (final tag in matchingTags) {
    final tuningTags = await db.getAllTuningTags();
    final matchingTuningTags = tuningTags.where((tt) => tt.tagId == tag.id).toList();
    
    for (final tuningTag in matchingTuningTags) {
      final tuning = tunings.firstWhere((t) => t.id == tuningTag.tuningId);
      if (!tagMatches.contains(tuning)) {
        tagMatches.add(tuning);
      }
    }
  }
  
  // 重複を除去して結果を結合
  final allMatches = <Tuning>[];
  allMatches.addAll(directMatches);
  for (final tagMatch in tagMatches) {
    if (!allMatches.any((t) => t.id == tagMatch.id)) {
      allMatches.add(tagMatch);
    }
  }
  
  return allMatches;
});

// コードフォーム検索プロバイダー
final codeFormSearchProvider = FutureProvider.family<List<CodeForm>, String>((ref, query) async {
  final db = ref.watch(appDatabaseProvider);
  if (query.isEmpty) return [];
  
  final codeForms = await db.getAllCodeForms();
  final searchQuery = query.toLowerCase();
  
  // 名前、フレットポジション、メモによる検索
  final directMatches = codeForms.where((form) {
    final label = (form.label ?? '').toLowerCase();
    final fretPositions = form.fretPositions.toLowerCase();
    final memo = (form.memo ?? '').toLowerCase();
    
    return label.contains(searchQuery) ||
        fretPositions.contains(searchQuery) ||
        memo.contains(searchQuery);
  }).toList();
  
  // タグによる検索
  final tags = await db.getAllTags();
  final matchingTags = tags.where((tag) => 
    tag.name.toLowerCase().contains(searchQuery)
  ).toList();
  
  final tagMatches = <CodeForm>[];
  for (final tag in matchingTags) {
    final codeFormTags = await db.getAllCodeFormTags();
    final matchingCodeFormTags = codeFormTags.where((cft) => cft.tagId == tag.id).toList();
    
    for (final codeFormTag in matchingCodeFormTags) {
      final codeForm = codeForms.firstWhere((cf) => cf.id == codeFormTag.codeFormId);
      if (!tagMatches.contains(codeForm)) {
        tagMatches.add(codeForm);
      }
    }
  }
  
  // 重複を除去して結果を結合
  final allMatches = <CodeForm>[];
  allMatches.addAll(directMatches);
  for (final tagMatch in tagMatches) {
    if (!allMatches.any((cf) => cf.id == tagMatch.id)) {
      allMatches.add(tagMatch);
    }
  }
  
  return allMatches;
});

// 検索結果ソート処理のユーティリティクラス
class SearchResultSorter {
  static void sortResults(List<dynamic> results, SortOrder sortOrder) {
    switch (sortOrder) {
      case SortOrder.dateAsc:
        results.sort((a, b) {
          final dateA = a is Tuning ? a.createdAt : (a as CodeForm).createdAt;
          final dateB = b is Tuning ? b.createdAt : (b as CodeForm).createdAt;
          return dateA.compareTo(dateB);
        });
        break;
      case SortOrder.dateDesc:
        results.sort((a, b) {
          final dateA = a is Tuning ? a.createdAt : (a as CodeForm).createdAt;
          final dateB = b is Tuning ? b.createdAt : (b as CodeForm).createdAt;
          return dateB.compareTo(dateA);
        });
        break;
      case SortOrder.idAsc:
        results.sort((a, b) {
          final idA = a is Tuning ? a.id : (a as CodeForm).id;
          final idB = b is Tuning ? b.id : (b as CodeForm).id;
          return idA.compareTo(idB);
        });
        break;
      case SortOrder.idDesc:
        results.sort((a, b) {
          final idA = a is Tuning ? a.id : (a as CodeForm).id;
          final idB = b is Tuning ? b.id : (b as CodeForm).id;
          return idB.compareTo(idA);
        });
        break;
    }
  }
}

// 統合検索結果プロバイダー
final searchResultsProvider = FutureProvider<List<dynamic>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final searchType = ref.watch(searchTypeProvider);
  final sortOrder = ref.watch(sortOrderProvider);

  if (query.isEmpty) {
    return [];
  }

  try {
    final results = <dynamic>[];

    // タグ専用検索
    if (searchType == SearchType.tag) {
      final db = ref.read(appDatabaseProvider);
      final tags = await db.getAllTags();
      final matchingTags = tags.where((tag) => 
        tag.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      // タグにマッチしたチューニングとコードフォームを取得
      for (final tag in matchingTags) {
        final tuningTags = await db.getAllTuningTags();
        final codeFormTags = await db.getAllCodeFormTags();
        
        final matchingTuningTags = tuningTags.where((tt) => tt.tagId == tag.id).toList();
        final matchingCodeFormTags = codeFormTags.where((cft) => cft.tagId == tag.id).toList();
        
        final allTunings = await db.getAllTunings();
        final allCodeForms = await db.getAllCodeForms();
        
        for (final tuningTag in matchingTuningTags) {
          final tuning = allTunings.firstWhere((t) => t.id == tuningTag.tuningId);
          if (!results.any((r) => r is Tuning && r.id == tuning.id)) {
            results.add(tuning);
          }
        }
        
        for (final codeFormTag in matchingCodeFormTags) {
          final codeForm = allCodeForms.firstWhere((cf) => cf.id == codeFormTag.codeFormId);
          if (!results.any((r) => r is CodeForm && r.id == codeForm.id)) {
            results.add(codeForm);
          }
        }
      }
    } else {
      // チューニングの検索
      if (searchType == SearchType.tuning || searchType == SearchType.both) {
        final tunings = await ref.read(tuningSearchProvider(query).future);
        results.addAll(tunings);
      }

      // コードフォームの検索
      if (searchType == SearchType.codeForm || searchType == SearchType.both) {
        final codeForms = await ref.read(codeFormSearchProvider(query).future);
        results.addAll(codeForms);
      }
    }

    // 結果のソート
    SearchResultSorter.sortResults(results, sortOrder);

    return results;
  } catch (e) {
    // TODO: 多言語対応 - エラーメッセージをローカライゼーションで対応する予定
    throw Exception('検索中にエラーが発生しました: $e');
  }
});
