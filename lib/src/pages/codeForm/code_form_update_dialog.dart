import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormUpdateDialog extends HookConsumerWidget {
  final CodeForm codeForm;

  const CodeFormUpdateDialog({super.key, required this.codeForm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelController = TextEditingController(text: codeForm.label);
    final fretPositionsController = TextEditingController(
      text: codeForm.fretPositions,
    );
    final memoController = TextEditingController(text: codeForm.memo ?? '');

    return AlertDialog(
      title: const Text('コードフォームを編集'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: 'ラベル'),
            ),
            TextField(
              controller: fretPositionsController,
              decoration: const InputDecoration(labelText: 'フレットポジション'),
            ),
            TextField(
              controller: memoController,
              decoration: const InputDecoration(labelText: 'メモ'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            final updatedCodeForm = CodeForm(
              id: codeForm.id,
              tuningId: codeForm.tuningId,
              fretPositions: fretPositionsController.text,
              label: labelController.text,
              memo: memoController.text.isEmpty ? null : memoController.text,
              createdAt: codeForm.createdAt,
              updatedAt: DateTime.now(),
              isFavorite: codeForm.isFavorite,
            );

            ref
                .read(codeFormNotifierProvider.notifier)
                .updateCodeForm(updatedCodeForm);
            Navigator.of(context).pop();
          },
          child: const Text('更新'),
        ),
      ],
    );
  }
}
