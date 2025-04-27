import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/search/search_page.dart';

// TODO: ここらへん分けた方がいいかも
// 検索結果を提供するプロバイダー
final searchResultsProvider = FutureProvider<List<dynamic>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final searchType = ref.watch(searchTypeProvider);
  final sortOrder = ref.watch(sortOrderProvider);

  if (query.isEmpty) {
    return Future.value([]);
  }

  return ref
      .read(searchNotifierProvider.notifier)
      .search(query: query, type: searchType, sortOrder: sortOrder);
});

// 検索処理を行うNotifier
class SearchNotifier extends StateNotifier<AsyncValue<List<dynamic>>> {
  final AppDatabase _db;

  SearchNotifier(this._db) : super(const AsyncValue.data([]));

  Future<List<dynamic>> search({
    required String query,
    required SearchType type,
    required SortOrder sortOrder,
  }) async {
    try {
      final results = <dynamic>[];

      // チューニングの検索
      if (type == SearchType.tuning || type == SearchType.both) {
        final tunings = await _searchTunings(query);
        results.addAll(tunings);
      }

      // コードフォームの検索
      if (type == SearchType.codeForm || type == SearchType.both) {
        final codeForms = await _searchCodeForms(query);
        results.addAll(codeForms);
      }

      // 結果のソート
      _sortResults(results, sortOrder);

      return results;
    } catch (e) {
      throw Exception('検索中にエラーが発生しました: $e');
    }
  }

  // チューニングの検索
  Future<List<Tuning>> _searchTunings(String query) async {
    final tunings = await _db.getAllTunings();
    return tunings.where((tuning) {
      final name = tuning.name.toLowerCase();
      final strings = tuning.strings.toLowerCase();
      final searchQuery = query.toLowerCase();

      return name.contains(searchQuery) || strings.contains(searchQuery);
    }).toList();
  }

  // コードフォームの検索
  Future<List<CodeForm>> _searchCodeForms(String query) async {
    final codeForms = await _db.getAllCodeForms();
    return codeForms.where((form) {
      final label = (form.label ?? '').toLowerCase();
      final fretPositions = form.fretPositions.toLowerCase();
      final memo = (form.memo ?? '').toLowerCase();
      final searchQuery = query.toLowerCase();

      return label.contains(searchQuery) ||
          fretPositions.contains(searchQuery) ||
          memo.contains(searchQuery);
    }).toList();
  }

  // 検索結果のソート
  void _sortResults(List<dynamic> results, SortOrder sortOrder) {
    switch (sortOrder) {
      case SortOrder.dateAsc:
        // 作成日でソート（古い順）
        results.sort((a, b) {
          final dateA = a is Tuning ? a.createdAt : (a as CodeForm).createdAt;
          final dateB = b is Tuning ? b.createdAt : (b as CodeForm).createdAt;
          return dateA.compareTo(dateB);
        });
        break;
      case SortOrder.dateDesc:
        // 作成日でソート（新しい順）
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
      default:
        // デフォルトは作成日の新しい順
        results.sort((a, b) {
          final dateA = a is Tuning ? a.createdAt : (a as CodeForm).createdAt;
          final dateB = b is Tuning ? b.createdAt : (b as CodeForm).createdAt;
          return dateB.compareTo(dateA);
        });
        break;
    }
  }
}

// 検索Notifierのプロバイダー
final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<dynamic>>>((ref) {
      final db = ref.watch(appDatabaseProvider);
      return SearchNotifier(db);
    });
