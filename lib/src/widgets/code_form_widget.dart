import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_providers.dart';
import 'package:tune_chord_sample/src/widgets/guitar_fretboard_widget.dart';
import 'package:tune_chord_sample/src/widgets/custom_text_field.dart';
import 'package:tune_chord_sample/src/widgets/tuning_info_card.dart';
import 'package:tune_chord_sample/src/widgets/fret_control_widget.dart';
import 'package:tune_chord_sample/src/widgets/code_form_action_buttons.dart';

class CodeFormWidget extends HookConsumerWidget {
  final int tuningId;
  final String? initialLabel;
  final String? initialMemo;
  final List<int>? initialFretPositions;
  final String submitButtonText;
  final Future<void> Function({
    required String fretPositions,
    String? label,
    String? memo,
  })
  onSubmit;

  const CodeFormWidget({
    super.key,
    required this.tuningId,
    required this.submitButtonText,
    required this.onSubmit,
    this.initialLabel,
    this.initialMemo,
    this.initialFretPositions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final fretPositions = useState<List<int>>(
      initialFretPositions ?? List.filled(6, 0),
    );
    final selectedFret = useState<int>(0);
    final labelController = useTextEditingController(text: initialLabel ?? '');
    final memoController = useTextEditingController(text: initialMemo ?? '');

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
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
            error: (error, _) => Center(child: Text(l10n.errorMessage(error.toString()))),
          ),

          const SizedBox(height: 24),

          // フォーム部分
          SectionHeader(title: l10n.chordInfo, icon: Icons.music_note),

          const SizedBox(height: 16),

          // コード名入力フィールド
          CustomTextField(
            controller: labelController,
            labelText: l10n.chordName,
            hintText: l10n.chordNameExample,
          ),

          const SizedBox(height: 24),

          // フレットボード表示
          SectionHeader(title: l10n.fretPosition, icon: Icons.grid_view),
          const SizedBox(height: 12),

          // フレット操作UI
          FretControlWidget(
            selectedFret: selectedFret.value,
            canGoToPrevious: selectedFret.value > 0,
            canGoToNext: selectedFret.value < 24,
            onPreviousFret: () => selectedFret.value--,
            onNextFret: () => selectedFret.value++,
            onReset: () {
              fretPositions.value = List.filled(6, 0);
              selectedFret.value = 0;
              labelController.text = '';
            },
          ),

          const SizedBox(height: 16),

          // ギターフレットボード
          GuitarFretboardWidget(
            fretPositions: fretPositions,
            startFret: selectedFret.value,
            tuningAsync: tuningAsync,
            onHelpPressed: () => _showHelpDialog(context, l10n),
          ),

          const SizedBox(height: 24),

          // メモ
          CustomTextField(
            controller: memoController,
            labelText: l10n.memoOptional,
            hintText: l10n.memoPlaceholder,
            maxLines: 3,
          ),

          const SizedBox(height: 32),

          // アクションボタン
          CodeFormActionButtons(
            submitButtonText: submitButtonText,
            onSubmit: () async {
              final fretString = fretPositions.value.join(',');
              await onSubmit(
                fretPositions: fretString,
                label:
                    labelController.text.isEmpty ? null : labelController.text,
                memo: memoController.text.isEmpty ? null : memoController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  // ヘルプダイアログを表示
  void _showHelpDialog(BuildContext context, AppLocalizations l10n) {
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
                Text(l10n.fretboardHelp),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ${l10n.fretboardHelpTapString}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '• ${l10n.fretboardHelpOpenString}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: theme.textTheme.bodyMedium),
                    Expanded(
                      child: Text(
                        l10n.fretboardHelpMuteString,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• ${l10n.fretboardHelpTapAgain}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '• ${l10n.fretboardHelpArrowKeys}',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.close,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
    );
  }
}
