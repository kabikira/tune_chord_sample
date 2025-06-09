import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_delete_dialog.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_update_dialog.dart';

// TODO:あとで分ける
// 表示モードを管理するプロバイダー
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.list);

// TODO:あとでenumのファイルに分ける
// 表示モードの列挙型
enum ViewMode { list, detail }

class CodeFormList extends HookConsumerWidget {
  final int tuningId;
  const CodeFormList({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeFormAsync = ref.watch(codeFormNotifierProvider);
    final viewMode = ref.watch(viewModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      appBar: AppBar(
        title: const Text('コードフォーム一覧'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          // 表示モード切り替えボタン
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  // 表示モードを切り替え
                  ref.read(viewModeProvider.notifier).state =
                      viewMode == ViewMode.list
                          ? ViewMode.detail
                          : ViewMode.list;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    viewMode == ViewMode.list
                        ? Icons.view_module
                        : Icons.view_list,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: codeFormAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('エラー: $error')),
              data: (codeForms) {
                // チューニングIDに基づいてコードフォームをフィルタリング
                final filteredCodeForms =
                    codeForms
                        .where((form) => form.tuningId == tuningId)
                        .toList();

                if (filteredCodeForms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 64,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '登録されたコードフォームがありません',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 表示モードに応じてビューを切り替え
                return viewMode == ViewMode.list
                    ? _buildListView(context, ref, filteredCodeForms)
                    : _buildDetailView(context, ref, filteredCodeForms);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/tuningList/codeFormList/$tuningId/codeFormRegister',
                  extra: tuningId,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: theme.colorScheme.onPrimary),
                  const SizedBox(width: 8),
                  const Text('新しいコードフォームを追加'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // リスト表示モード
  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<CodeForm> codeForms,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: codeForms.length,
      itemBuilder: (context, index) {
        final codeForm = codeForms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // 詳細画面へ遷移
              context.push(
                '/tuningList/codeFormList/$tuningId/codeFormDetail',
                extra: codeForm.id,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          codeForm.label ?? 'コード名なし',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'フレットポジション: ${codeForm.fretPositions}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        if (codeForm.memo != null && codeForm.memo!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'メモ: ${codeForm.memo}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildInteractionButtons(context, codeForm),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 詳細表示モード - すべてのコードフォームの詳細を表示
  Widget _buildDetailView(
    BuildContext context,
    WidgetRef ref,
    List<CodeForm> codeForms,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: codeForms.length,
      itemBuilder: (context, index) {
        final codeForm = codeForms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            codeForm.label ?? 'コード名なし',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'フレットポジション: ${codeForm.fretPositions}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildInteractionButtons(context, codeForm),
                  ],
                ),
                const SizedBox(height: 16),
                _buildEnhancedChordDiagram(context, codeForm),
                const SizedBox(height: 16),
                if (codeForm.memo != null && codeForm.memo!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'メモ',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(codeForm.memo!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInteractionButtons(BuildContext context, CodeForm codeForm) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CodeFormUpdateDialog(codeForm: codeForm),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => CodeFormDeleteDialog(codeForm: codeForm),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  // 高品質なコードダイアグラムを表示するウィジェット
  Widget _buildEnhancedChordDiagram(BuildContext context, CodeForm codeForm) {
    final theme = Theme.of(context);
    final positions = codeForm.fretPositions.split('');

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'コードダイアグラム',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  positions.map((pos) {
                    final isX = pos == 'X';
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color:
                                isX
                                    ? Colors.red.withOpacity(0.1)
                                    : theme.colorScheme.primary.withOpacity(
                                      0.1,
                                    ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            isX ? 'X' : pos,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  isX ? Colors.red : theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
