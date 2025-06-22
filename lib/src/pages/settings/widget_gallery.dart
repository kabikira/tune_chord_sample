import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/widgets/chord_diagram_widget.dart';
import 'package:tune_chord_sample/src/widgets/custom_text_field.dart';
import 'package:tune_chord_sample/src/widgets/dialog_action_buttons.dart';
import 'package:tune_chord_sample/src/widgets/guitar_fretboard_widget.dart';
import 'package:tune_chord_sample/src/widgets/tuning_info_card.dart'
    as new_tuning;
import 'package:tune_chord_sample/src/widgets/fret_control_widget.dart';
import 'package:tune_chord_sample/src/widgets/code_form_action_buttons.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

class WidgetGallery extends HookConsumerWidget {
  const WidgetGallery({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textController = useTextEditingController(text: 'サンプルテキスト');
    final fretPositions = useState<List<int>>([3, 2, 0, 0, 3, 3]);

    // サンプルデータ
    final sampleCodeForm = CodeForm(
      id: 1,
      tuningId: 1,
      fretPositions: '320033',
      label: 'G Major',
      memo: 'サンプルコード',
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final sampleTuning = Tuning(
      id: 1,
      name: 'Standard',
      strings: 'E,A,D,G,B,E',
      memo: 'スタンダードチューニング',
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: const Text('ウィジェット一覧'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ChordDiagramWidget
            _buildWidgetSection(
              context,
              title: 'ChordDiagramWidget',
              description: 'コードダイアグラムを表示するウィジェット',
              child: Column(
                children: [
                  ChordDiagramWidget(
                    codeForm: sampleCodeForm,
                    isEnhanced: false,
                  ),
                  const SizedBox(height: 16),
                  ChordDiagramWidget(
                    codeForm: sampleCodeForm,
                    isEnhanced: true,
                    title: 'Enhanced版',
                  ),
                  const SizedBox(height: 16),
                  FretPositionDisplay(
                    fretPositions: [3, 2, 0, 0, 3, 3],
                    label: 'フレットポジション表示',
                  ),
                  const SizedBox(height: 16),
                  TuningInfoCard(
                    tuningName: sampleTuning.name,
                    tuningStrings: sampleTuning.strings,
                    icon: Icons.music_note,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // CustomTextField
            _buildWidgetSection(
              context,
              title: 'CustomTextField',
              description: 'カスタムテキストフィールドとセクション',
              child: Column(
                children: [
                  CustomTextField(
                    controller: textController,
                    labelText: 'ラベル付きフィールド',
                    hintText: 'ヒントテキスト',
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(hintText: 'シンプルなフィールド', maxLines: 3),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'セクションヘッダー', icon: Icons.settings),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // DialogActionButtons
            _buildWidgetSection(
              context,
              title: 'DialogActionButtons',
              description: 'ダイアログアクションボタンとインタラクションボタン',
              child: Column(
                children: [
                  DialogActionButtons(
                    cancelText: 'キャンセル',
                    confirmText: '確認',
                    onCancel: () {},
                    onConfirm: () {},
                  ),
                  const SizedBox(height: 16),
                  DialogActionButtons(
                    cancelText: 'キャンセル',
                    confirmText: '削除',
                    isDestructive: true,
                    onCancel: () {},
                    onConfirm: () {},
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InteractionButtons(
                        onEdit: () {},
                        onDelete: () {},
                        editTooltip: '編集',
                        deleteTooltip: '削除',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // GuitarFretboardWidget
            _buildWidgetSection(
              context,
              title: 'GuitarFretboardWidget',
              description: 'ギターフレットボードウィジェット',
              child: GuitarFretboardWidget(
                fretPositions: ValueNotifier(fretPositions.value),
                startFret: 0,
                tuningAsync: AsyncValue.data(sampleTuning),
                onHelpPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('ヘルプが押されました')));
                },
              ),
            ),

            const SizedBox(height: 32),

            // TuningInfoCard (New)
            _buildWidgetSection(
              context,
              title: 'TuningInfoCard (New)',
              description: '新しいチューニング情報表示カード',
              child: new_tuning.TuningInfoCard(
                tuningName: sampleTuning.name,
                tuningStrings: sampleTuning.strings,
              ),
            ),

            const SizedBox(height: 32),

            // FretControlWidget
            _buildWidgetSection(
              context,
              title: 'FretControlWidget',
              description: 'フレット位置制御ウィジェット',
              child: FretControlWidget(
                selectedFret: 3,
                canGoToPrevious: true,
                canGoToNext: true,
                onPreviousFret: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('前のフレット')));
                },
                onNextFret: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('次のフレット')));
                },
                onReset: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('リセット')));
                },
              ),
            ),

            const SizedBox(height: 32),

            // CodeFormActionButtons
            _buildWidgetSection(
              context,
              title: 'CodeFormActionButtons',
              description: 'コードフォーム用アクションボタン',
              child: Column(
                children: [
                  CodeFormActionButtons(
                    submitButtonText: '登録する',
                    onSubmit: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('登録ボタンが押されました')),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CodeFormActionButtons(
                    submitButtonText: '更新する',
                    isEnabled: false,
                    onSubmit: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // CodeFormWidget
            _buildWidgetSection(
              context,
              title: 'CodeFormWidget',
              description: 'コードフォーム入力ウィジェット（完全版）',
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'CodeFormWidget\n（実際の動作には\nプロバイダーが必要）',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
