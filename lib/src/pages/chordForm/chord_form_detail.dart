// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resonance/l10n/app_localizations.dart';
import 'package:resonance/src/pages/chordForm/chord_form_notifier.dart';
import 'package:resonance/src/pages/chordForm/chord_form_providers.dart';
import 'package:resonance/src/pages/tuning/tuning_notifier.dart';
import 'package:resonance/src/widgets/guitar_fretboard_widget.dart';

class ChordFormDetail extends HookConsumerWidget {
  final int chordFormId;

  const ChordFormDetail({super.key, required this.chordFormId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // chordFormNotifierProviderを使用してコードフォームデータを取得
    final chordFormsAsync = ref.watch(chordFormNotifierProvider);
    final tuningAsync = ref.watch(
      tuningStringsFromChordFormProvider(chordFormId),
    );

    return Scaffold(
      appBar: AppBar(
        title: tuningAsync.when(
          data:
              (tuning) =>
                  Text('${tuningAsync.value} - ${l10n.chordFormDetail}'),
          loading: () => Text(l10n.chordFormDetail),
          error: (_, __) => Text(l10n.chordFormDetail),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: chordFormsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorMessage(e.toString()))),
        data: (chordForms) {
          // 指定されたchordFormIdに一致するコードフォームを取得
          final chordForm = chordForms.firstWhere(
            (form) => form.id == chordFormId,
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
                    chordForm.label ?? '',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),
                  Text(l10n.chordFretPosition(chordForm.fretPositions)),
                  if (chordForm.memo != null && chordForm.memo!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(l10n.chordMemo(chordForm.memo!)),
                    ),

                  const SizedBox(height: 16),
                  // ギターフレットボード表示の追加
                  Consumer(
                    builder: (context, ref, child) {
                      final tuningAsync = ref.watch(tuningNotifierProvider);
                      return tuningAsync.when(
                        data: (tunings) {
                          final tuning = tunings.firstWhere(
                            (t) => t.id == chordForm.tuningId,
                            orElse: () => throw Exception(l10n.tuningNotFound),
                          );

                          final fretPositions = ValueNotifier<List<int>>(
                            chordForm.fretPositions.contains(',')
                                ? chordForm.fretPositions
                                    .split(',')
                                    .map(int.parse)
                                    .toList()
                                : [0, 0, 0, 0, 0, 0],
                          );

                          return GuitarFretboardWidget(
                            fretPositions: fretPositions,
                            tuningAsync: AsyncValue.data(tuning),
                            showMuteControl: false,
                          );
                        },
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (error, stack) => Center(
                              child: Text(l10n.errorOccurred(error.toString())),
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // 編集画面へ遷移
                          context.go(
                            '/tuningList/chordFormList/${chordForm.tuningId}/chordFormEdit',
                            extra: chordForm.id,
                          );
                        },
                        child: Text(l10n.edit),
                      ),
                      TextButton(
                        onPressed: () {
                          // 削除確認ダイアログを表示
                          _showDeleteConfirmDialog(context, ref, chordForm.id);
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
    int chordFormId,
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
                      .read(chordFormNotifierProvider.notifier)
                      .deleteChordForm(chordFormId);
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
