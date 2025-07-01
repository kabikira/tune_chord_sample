import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/widgets/chord_diagram_widget.dart';

class CodeFormDetail extends HookConsumerWidget {
  final int codeFormId;

  const CodeFormDetail({super.key, required this.codeFormId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // codeFormNotifierProviderを使用してコードフォームデータを取得
    final codeFormsAsync = ref.watch(codeFormNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.codeFormDetail)),
      body: codeFormsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorMessage(e.toString()))),
        data: (codeForms) {
          // 指定されたcodeFormIdに一致するコードフォームを取得
          final codeForm = codeForms.firstWhere(
            (form) => form.id == codeFormId,
            orElse: () => throw Exception('コードフォームが見つかりません'),
          );

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  ChordDiagramWidget(codeForm: codeForm),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 編集画面へ遷移
                          context.go(
                            '/tuningList/codeFormList/${codeForm.tuningId}/codeFormDetail/codeFormEdit',
                            extra: codeForm.id,
                          );
                        },
                        child: Text(l10n.edit),
                      ),
                      TextButton(
                        onPressed: () {
                          // 削除確認ダイアログを表示
                          _showDeleteConfirmDialog(context, ref, codeForm.id);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
                  // 削除後に前の画面に戻る
                  context.pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('削除'),
              ),
            ],
          ),
    );
  }
}
