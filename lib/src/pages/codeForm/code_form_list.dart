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

    return Scaffold(
      appBar: AppBar(
        title: Text('CodeFormList tuningId=$tuningId'),
        actions: [
          // 表示モード切り替えボタン
          IconButton(
            icon: Icon(
              viewMode == ViewMode.list
                  ? Icons
                      .view_module // 詳細表示モードへ切り替えるアイコン
                  : Icons.view_list,
            ), // リスト表示モードへ切り替えるアイコン
            onPressed: () {
              // 表示モードを切り替え
              ref.read(viewModeProvider.notifier).state =
                  viewMode == ViewMode.list ? ViewMode.detail : ViewMode.list;
            },
            tooltip: viewMode == ViewMode.list ? '詳細表示に切り替え' : 'リスト表示に切り替え',
          ),
        ],
      ),
      body: Center(
        child: Column(
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
                    return const Center(child: Text('登録されたコードフォームがありません'));
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
                child: const Text('新しいコードフォームを追加'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // リスト表示モード
  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<CodeForm> codeForms,
  ) {
    return ListView.builder(
      itemCount: codeForms.length,
      itemBuilder: (context, index) {
        final codeForm = codeForms[index];
        return ListTile(
          title: Text('${codeForm.label} (${codeForm.fretPositions})'),
          subtitle: codeForm.memo != null ? Text(codeForm.memo!) : null,
          onTap: () {
            // 詳細画面へ遷移
            context.push(
              '/tuningList/codeFormList/$tuningId/codeFormDetail',
              extra: codeForm.id,
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CodeFormUpdateDialog(codeForm: codeForm),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => CodeFormDeleteDialog(codeForm: codeForm),
                  );
                },
              ),
            ],
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
    return ListView.builder(
      itemCount: codeForms.length,
      itemBuilder: (context, index) {
        final codeForm = codeForms[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // チューニングIDを表示
                Text(
                  'チューニングID: ${codeForm.tuningId}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  codeForm.label ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text('フレットポジション: ${codeForm.fretPositions}'),
                if (codeForm.memo != null && codeForm.memo!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('メモ: ${codeForm.memo}'),
                  ),
                const SizedBox(height: 16),
                _buildChordDiagram(codeForm),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        // 編集画面へ遷移
                        context.push(
                          '/tuningList/codeFormList/${codeForm.tuningId}/codeFormEdit/${codeForm.id}',
                        );
                      },
                      child: const Text('編集'),
                    ),
                    TextButton(
                      onPressed: () {
                        // 削除確認ダイアログを表示
                        _showDeleteConfirmDialog(context, ref, codeForm.id);
                      },
                      child: const Text('削除'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // コードダイアグラムを表示するウィジェット
  Widget _buildChordDiagram(CodeForm codeForm) {
    // フレットポジションからコードダイアグラムを構築
    final positions = codeForm.fretPositions.split('');

    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            positions.map((pos) {
              return Column(
                children: [
                  Text(
                    pos == 'X' ? 'X' : pos,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: pos == 'X' ? Colors.red : Colors.black,
                    ),
                  ),
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade400),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  // 削除確認ダイアログ
  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    int codeFormId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('コードフォームの削除'),
            content: const Text('このコードフォームを削除してもよろしいですか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () {
                  // コードフォームを削除
                  ref
                      .read(codeFormNotifierProvider.notifier)
                      .deleteCodeForm(codeFormId);
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('削除'),
              ),
            ],
          ),
    );
  }
}
