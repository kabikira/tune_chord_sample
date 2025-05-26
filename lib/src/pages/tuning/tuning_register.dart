import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';

class TuningKeyboard extends HookWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ThemeData theme;

  const TuningKeyboard({
    required this.controller,
    required this.focusNode,
    required this.theme,
    super.key,
  });

  void insertText(String text) {
    final currentText = controller.text;
    final newText = currentText + text;
    controller.text = newText;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
  }

  void deleteText() {
    final currentText = controller.text;
    if (currentText.isNotEmpty) {
      final newText = currentText.substring(0, currentText.length - 1);
      controller.text = newText;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    }
  }

  Widget buildKey(String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => insertText(label),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withAlpha(77),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [buildKey("A"), buildKey("B"), buildKey("C")]),
          Row(children: [buildKey("D"), buildKey("E"), buildKey("F")]),
          Row(children: [buildKey("G"), buildKey("#"), buildKey("")]),
          Row(
            children: [
              buildKey("⌫", onTap: deleteText),
              buildKey(" "),
              buildKey(
                "完了",
                onTap: () {
                  focusNode.unfocus();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TuningRegister extends HookConsumerWidget {
  const TuningRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final stringsController = useTextEditingController();
    final stringsFocusNode = useFocusNode();
    final isSaving = useState(false);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.music_note, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'チューニングを登録',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '弦のチューニング',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: stringsController,
              focusNode: stringsFocusNode,
              readOnly: true,
              showCursor: true,
              decoration: InputDecoration(
                hintText: '例: CGDGCD',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainer.withAlpha(77),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onTap: () {
                stringsFocusNode.requestFocus();
                showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return TuningKeyboard(
                      controller: stringsController,
                      focusNode: stringsFocusNode,
                      theme: theme,
                    );
                  },
                ).whenComplete(() => stringsFocusNode.unfocus());
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '低音から高音の順に入力してください',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            'キャンセル',
            style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(179)),
          ),
        ),
        ElevatedButton(
          onPressed:
              isSaving.value
                  ? null
                  : () async {
                    final name = nameController.text.trim();
                    final strings = stringsController.text.trim();
                    if (strings.isEmpty) return;

                    isSaving.value = true;
                    await ref
                        .read(tuningNotifierProvider.notifier)
                        .addTuning(name, strings);
                    isSaving.value = false;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: 0,
          ),
          child:
              isSaving.value
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                  : const Text('保存'),
        ),
      ],
    );
  }
}
