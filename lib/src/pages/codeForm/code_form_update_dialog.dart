import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/widgets/guitar_fretboard_widget.dart';
import 'package:tune_chord_sample/src/widgets/custom_text_field.dart';
import 'package:tune_chord_sample/src/widgets/dialog_action_buttons.dart';
import 'package:tune_chord_sample/src/widgets/chord_diagram_widget.dart';

class CodeFormUpdateDialog extends HookConsumerWidget {
  final CodeForm codeForm;

  const CodeFormUpdateDialog({super.key, required this.codeForm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // フレットポジションをリストに変換
    final initialPositions =
        codeForm.fretPositions
            .split(',')
            .map((s) => int.tryParse(s) ?? 0)
            .toList();
    // 足りない分を0で埋める
    while (initialPositions.length < 6) {
      initialPositions.add(0);
    }

    final fretPositions = useState<List<int>>(initialPositions);
    final selectedFret = useState<int>(0); // 表示するフレット位置
    final labelController = useTextEditingController(text: codeForm.label);
    final memoController = useTextEditingController(text: codeForm.memo ?? '');
    final isSaving = useState(false);
    final theme = Theme.of(context);

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(codeForm.tuningId));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'コードフォームを編集',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // チューニング情報表示
              tuningAsync.when(
                data:
                    (tuning) => TuningInfoCard(
                      tuningName: tuning.name,
                      tuningStrings: tuning.strings,
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('エラー: $error')),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: labelController,
                labelText: 'コード名',
                hintText: 'C, Am7, Em/G など',
              ),

              const SizedBox(height: 24),

              // フレットボード表示
              Text(
                'フレットポジション',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // フレット操作UI
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // フレット位置表示と移動ボタン
                  Card(
                    elevation: 0,
                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                selectedFret.value > 0
                                    ? () => selectedFret.value--
                                    : null,
                            icon: const Icon(Icons.chevron_left),
                            color: theme.colorScheme.primary,
                            tooltip: '前のフレット',
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'フレット ${selectedFret.value}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed:
                                selectedFret.value < 24
                                    ? () => selectedFret.value++
                                    : null,
                            icon: const Icon(Icons.chevron_right),
                            color: theme.colorScheme.primary,
                            tooltip: '次のフレット',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // コードダイアグラムのリセットボタン
                  TextButton.icon(
                    onPressed: () {
                      fretPositions.value = List.filled(6, 0);
                      selectedFret.value = 0;
                    },
                    icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
                    label: Text(
                      'リセット',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ギターフレットボード
              GuitarFretboardWidget(
                fretPositions: fretPositions,
                startFret: selectedFret.value,
                tuningAsync: tuningAsync,
                onHelpPressed: () => _showHelpDialog(context),
              ),

              const SizedBox(height: 16),

              CustomTextField(
                controller: memoController,
                labelText: 'メモ',
                hintText: '任意のメモを入力できます',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      actions: [
        DialogActionButtons(
          confirmText: '更新',
          isLoading: isSaving.value,
          onConfirm:
              isSaving.value
                  ? null
                  : () async {
                    isSaving.value = true;

                    final fretString = fretPositions.value.join(',');
                    final updatedCodeForm = CodeForm(
                      id: codeForm.id,
                      tuningId: codeForm.tuningId,
                      fretPositions: fretString,
                      label: labelController.text,
                      memo:
                          memoController.text.isEmpty
                              ? null
                              : memoController.text,
                      createdAt: codeForm.createdAt,
                      updatedAt: DateTime.now(),
                      isFavorite: codeForm.isFavorite,
                      userId: codeForm.userId,
                    );

                    await ref
                        .read(codeFormNotifierProvider.notifier)
                        .updateCodeForm(updatedCodeForm);

                    isSaving.value = false;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
        ),
      ],
    );
  }

  // ヘルプダイアログを表示
  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.help_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('フレットボードの使い方'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 弦をタップして押さえる位置を指定', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('• フレット 0 はオープン弦を表します', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: theme.textTheme.bodyMedium),
                    Expanded(
                      child: Text(
                        'フレット 0 での長押しで弦をミュート（X）します',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• 同じ位置を再度タップすると解除されます',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '• 左右の矢印でフレット位置を移動できます',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '閉じる',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
    );
  }
}

// 単一のチューニングを取得するためのプロバイダー
final singleTuningProvider = FutureProvider.family<Tuning, int>((
  ref,
  tuningId,
) async {
  final db = ref.watch(appDatabaseProvider);
  final tunings = await db.getAllTunings();
  return tunings.firstWhere(
    (tuning) => tuning.id == tuningId,
    orElse: () => throw Exception('チューニングが見つかりません'),
  );
});
