import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_providers.dart';
import 'package:tune_chord_sample/src/widgets/guitar_fretboard_widget.dart';
import 'package:tune_chord_sample/src/widgets/custom_text_field.dart';
import 'package:tune_chord_sample/src/widgets/chord_diagram_widget.dart';

class CodeFormRegister extends HookConsumerWidget {
  final int tuningId;
  const CodeFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fretPositions = useState<List<int>>(List.filled(6, 0));
    final selectedFret = useState<int>(0); // 表示するフレット位置
    final labelController = useTextEditingController();
    final memoController = useTextEditingController();
    final theme = Theme.of(context);

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: const Text('コードフォーム登録'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // チューニング情報表示
              tuningAsync.when(
                data: (tuning) => TuningInfoCard(
                  tuningName: tuning.name,
                  tuningStrings: tuning.strings,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('エラー: $error')),
              ),

              const SizedBox(height: 24),

              // フォーム部分
              const SectionHeader(
                title: 'コード情報',
                icon: Icons.music_note,
              ),

              const SizedBox(height: 16),

              // コード名入力フィールド
              CustomTextField(
                controller: labelController,
                labelText: 'コード名',
                hintText: 'Em, C, G7など',
              ),

              const SizedBox(height: 24),

              // フレットボード表示
              const SectionHeader(
                title: 'フレットポジション',
                icon: Icons.grid_view,
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
                      // リセット時にラベルもクリア
                      labelController.text = '';
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

              const SizedBox(height: 24),

              // メモ
              CustomTextField(
                controller: memoController,
                labelText: 'メモ（任意）',
                hintText: 'コードに関するメモを入力...',
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // 登録ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final fretString = fretPositions.value.join(',');
                    await ref
                        .read(codeFormNotifierProvider.notifier)
                        .addCodeForm(
                          tuningId: tuningId,
                          fretPositions: fretString,
                          label:
                              labelController.text.isEmpty
                                  ? null
                                  : labelController.text,
                          memo:
                              memoController.text.isEmpty
                                  ? null
                                  : memoController.text,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('登録する'),
                ),
              ),
            ],
          ),
        ),
      ),
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

