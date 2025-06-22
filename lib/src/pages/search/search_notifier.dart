import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/search/search_page.dart';

// チューニング検索プロバイダー
final tuningSearchProvider = FutureProvider.family<List<Tuning>, String>((ref, query) async {
  final db = ref.watch(appDatabaseProvider);
  if (query.isEmpty) return [];
  
  final tunings = await db.getAllTunings();
  final searchQuery = query.toLowerCase();
  
  return tunings.where((tuning) {
    final name = tuning.name.toLowerCase();
    final strings = tuning.strings.toLowerCase();
    return name.contains(searchQuery) || strings.contains(searchQuery);
  }).toList();
});

// コードフォーム検索プロバイダー
final codeFormSearchProvider = FutureProvider.family<List<CodeForm>, String>((ref, query) async {
  final db = ref.watch(appDatabaseProvider);
  if (query.isEmpty) return [];
  
  final codeForms = await db.getAllCodeForms();
  final searchQuery = query.toLowerCase();
  
  return codeForms.where((form) {
    final label = (form.label ?? '').toLowerCase();
    final fretPositions = form.fretPositions.toLowerCase();
    final memo = (form.memo ?? '').toLowerCase();
    
    return label.contains(searchQuery) ||
        fretPositions.contains(searchQuery) ||
        memo.contains(searchQuery);
  }).toList();
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

    // 結果のソート
    SearchResultSorter.sortResults(results, sortOrder);

    return results;
  } catch (e) {
    throw Exception('検索中にエラーが発生しました: $e');
  }
});
