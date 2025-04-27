import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/search/search_notifier.dart';

// 検索対象の種類
enum SearchType { tuning, codeForm, both }

// ソート順
enum SortOrder { dateAsc, dateDesc, idAsc, idDesc }

// 検索タイプを管理するプロバイダー
final searchTypeProvider = StateProvider<SearchType>((ref) => SearchType.both);

// ソート順を管理するプロバイダー
final sortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.dateDesc);

// 検索クエリを保持するプロバイダー
final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchType = ref.watch(searchTypeProvider);
    final sortOrder = ref.watch(sortOrderProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('検索')),
      body: Column(
        children: [
          // 検索ボックス
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '検索キーワードを入力',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).state = '';
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),

          // 検索オプション
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // 検索タイプ選択
                Flexible(
                  // TODO: DropdownMenuEntryも検討
                  child: DropdownButtonFormField<SearchType>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: '検索対象',
                      border: OutlineInputBorder(),
                    ),
                    value: searchType,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(searchTypeProvider.notifier).state = value;
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: SearchType.both,
                        child: Text('すべて'),
                      ),
                      DropdownMenuItem(
                        value: SearchType.tuning,
                        child: Text('チューニングのみ'),
                      ),
                      DropdownMenuItem(
                        value: SearchType.codeForm,
                        child: Text('コードフォームのみ'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // ソート順選択
                Flexible(
                  child: DropdownButtonFormField<SortOrder>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: '並び順',
                      border: OutlineInputBorder(),
                    ),
                    value: sortOrder,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(sortOrderProvider.notifier).state = value;
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: SortOrder.dateDesc,
                        child: Text('新しい順'),
                      ),
                      DropdownMenuItem(
                        value: SortOrder.dateAsc,
                        child: Text('古い順'),
                      ),
                      DropdownMenuItem(
                        value: SortOrder.idAsc,
                        child: Text('ID昇順'),
                      ),
                      DropdownMenuItem(
                        value: SortOrder.idDesc,
                        child: Text('ID降順'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 検索結果
          Expanded(
            child:
                searchQuery.isEmpty
                    ? const Center(child: Text('検索キーワードを入力してください'))
                    : searchResults.when(
                      data: (results) {
                        if (results.isEmpty) {
                          return const Center(child: Text('検索結果がありません'));
                        }

                        return ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (context, index) {
                            final result = results[index];

                            if (result is Tuning) {
                              // チューニングの表示
                              return ListTile(
                                leading: const Icon(Icons.music_note),
                                title: Text(result.name),
                                subtitle: Text('チューニング: ${result.strings}'),
                                onTap: () {
                                  // チューニングの詳細ページに遷移
                                  context.push(
                                    '/tuningList/codeFormList/${result.id}',
                                  );
                                },
                              );
                            } else if (result is CodeForm) {
                              // コードフォームの表示
                              return ListTile(
                                leading: const Icon(Icons.queue_music),
                                title: Text(result.label ?? '名称なし'),
                                subtitle: Text(
                                  'フレットポジション: ${result.fretPositions}',
                                ),
                                onTap: () {
                                  // コードフォームの詳細ページに遷移
                                  context.push(
                                    '/tuningList/codeFormList/${result.tuningId}/codeFormDetail',
                                    extra: result.id,
                                  );
                                },
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        );
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (error, stack) => Center(child: Text('エラー: $error')),
                    ),
          ),
        ],
      ),
    );
  }
}
