// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:resonance/l10n/app_localizations.dart';
import 'package:resonance/src/db/app_database.dart';
import 'package:resonance/src/pages/chordForm/chord_form_notifier.dart';
import 'package:resonance/src/utils/fret_position_utils.dart';
import 'package:resonance/src/widgets/chord_diagram_widget.dart';
import 'package:resonance/src/widgets/custom_text_field.dart';
import 'package:resonance/src/widgets/dialog_action_buttons.dart';
import 'package:resonance/src/widgets/guitar_fretboard_widget.dart';

class ChordFormUpdateDialog extends HookConsumerWidget {
  final ChordForm chordForm;

  const ChordFormUpdateDialog({super.key, required this.chordForm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // フレットポジションをリストに変換
    final initialPositions = FretPositionUtils.parseFretPositions(
      chordForm.fretPositions,
    );
    // 足りない分を0で埋める（万が一の場合）
    while (initialPositions.length < 6) {
      initialPositions.add(0);
    }

    final fretPositions = useState<List<int>>(initialPositions);
    final selectedFret = useState<int>(0); // 表示するフレット位置
    final labelController = useTextEditingController(text: chordForm.label);
    final memoController = useTextEditingController(text: chordForm.memo ?? '');
    final isSaving = useState(false);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(chordForm.tuningId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              l10n.chordFormEdit,
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
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text(l10n.errorOccurred)),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: labelController,
                  labelText: l10n.chordName,
                  hintText: l10n.chordNameExample,
                ),

                const SizedBox(height: 24),

                // フレットボード表示
                Text(
                  l10n.fretPosition,
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
                              tooltip: l10n.previousFret,
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
                                l10n.fretNumber(selectedFret.value),
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
                              tooltip: l10n.nextFret,
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
                      icon: Icon(
                        Icons.refresh,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        l10n.reset,
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
                  tuningAsync: tuningAsync,
                  onHelpPressed: () => _showHelpDialog(context),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: memoController,
                  labelText: l10n.memo,
                  hintText: l10n.memoPlaceholder,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        actions: [
          DialogActionButtons(
            confirmText: l10n.update,
            isLoading: isSaving.value,
            onConfirm:
                isSaving.value
                    ? null
                    : () async {
                      isSaving.value = true;

                      final fretString = fretPositions.value.join(',');
                      final updatedChordForm = ChordForm(
                        id: chordForm.id,
                        tuningId: chordForm.tuningId,
                        fretPositions: fretString,
                        label: labelController.text,
                        memo:
                            memoController.text.isEmpty
                                ? null
                                : memoController.text,
                        createdAt: chordForm.createdAt,
                        updatedAt: DateTime.now(),
                        isFavorite: chordForm.isFavorite,
                        userId: chordForm.userId,
                      );

                      await ref
                          .read(chordFormNotifierProvider.notifier)
                          .updateChordForm(updatedChordForm);

                      isSaving.value = false;
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
  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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

// 単一のチューニングを取得するためのプロバイダー
final singleTuningProvider = FutureProvider.family<Tuning, int>((
  ref,
  tuningId,
) async {
  final db = ref.watch(appDatabaseProvider);
  final tunings = await db.getAllTunings();
  return tunings.firstWhere(
    (tuning) => tuning.id == tuningId,
    orElse: () => throw Exception('Tuning not found'),
  );
});
