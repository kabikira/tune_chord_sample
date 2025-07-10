import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/search/search_notifier.dart';

// 検索対象の種類
enum SearchType { tuning, codeForm, tag, both }

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      appBar: AppBar(
        title: const Text('検索'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 検索ボックス
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: '検索キーワードを入力',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  suffixIcon:
                      searchQuery.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                            onPressed: () {
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: theme.textTheme.bodyMedium,
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              ),
            ),

            const SizedBox(height: 16),

            // 検索オプション
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '検索オプション',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // 検索タイプ選択
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '検索対象',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.8,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SearchType>(
                                  isExpanded: true,
                                  value: searchType,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: theme.colorScheme.primary,
                                  ),
                                  elevation: 0,
                                  style: theme.textTheme.bodyMedium,
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  onChanged: (value) {
                                    if (value != null) {
                                      ref
                                          .read(searchTypeProvider.notifier)
                                          .state = value;
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
                                    DropdownMenuItem(
                                      value: SearchType.tag,
                                      child: Text('タグのみ'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ソート順選択
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '並び順',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.8,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant
                                    .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SortOrder>(
                                  isExpanded: true,
                                  value: sortOrder,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: theme.colorScheme.primary,
                                  ),
                                  elevation: 0,
                                  style: theme.textTheme.bodyMedium,
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  onChanged: (value) {
                                    if (value != null) {
                                      ref
                                          .read(sortOrderProvider.notifier)
                                          .state = value;
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 検索結果
            Expanded(
              child:
                  searchQuery.isEmpty
                      ? _buildEmptyState(
                        theme,
                        Icons.search,
                        '検索キーワードを入力してください',
                      )
                      : searchResults.when(
                        data: (results) {
                          if (results.isEmpty) {
                            return _buildEmptyState(
                              theme,
                              Icons.search_off,
                              '検索結果がありません',
                            );
                          }

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: ListView.separated(
                                itemCount: results.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      indent: 72,
                                      color: theme.colorScheme.outline
                                          .withOpacity(0.1),
                                    ),
                                itemBuilder: (context, index) {
                                  final result = results[index];

                                  if (result is Tuning) {
                                    // チューニングの表示
                                    return _buildTuningResultTile(
                                      context,
                                      theme,
                                      ref,
                                      result,
                                    );
                                  } else if (result is CodeForm) {
                                    // コードフォームの表示
                                    return _buildCodeFormResultTile(
                                      context,
                                      theme,
                                      ref,
                                      result,
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
                        loading:
                            () => Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                        error:
                            (error, stack) => _buildEmptyState(
                              theme,
                              Icons.error_outline,
                              'エラー: $error',
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTuningResultTile(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    Tuning tuning,
  ) {
    return InkWell(
      onTap: () {
        context.push('/tuningList/codeFormList/${tuning.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.music_note,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tuning.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'チューニング: ${tuning.strings}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, child) {
                      final tagsAsync = ref.watch(tuningTagsProvider(tuning.id));
                      return tagsAsync.when(
                        data: (tags) => tags.isNotEmpty
                            ? _buildTagsRow(theme, tags)
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeFormResultTile(
    BuildContext context,
    ThemeData theme,
    WidgetRef ref,
    CodeForm codeForm,
  ) {
    return InkWell(
      onTap: () {
        context.push(
          '/tuningList/codeFormList/${codeForm.tuningId}/codeFormDetail',
          extra: codeForm.id,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.1),
              child: Icon(
                Icons.queue_music,
                color: theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    codeForm.label ?? '名称なし',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'フレットポジション: ${codeForm.fretPositions}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Consumer(
                    builder: (context, ref, child) {
                      final tagsAsync = ref.watch(codeFormTagsProvider(codeForm.id));
                      return tagsAsync.when(
                        data: (tags) => tags.isNotEmpty
                            ? _buildTagsRow(theme, tags)
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsRow(ThemeData theme, List<Tag> tags) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            tag.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
