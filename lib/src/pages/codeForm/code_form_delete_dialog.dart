import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormDeleteDialog extends HookConsumerWidget {
  final CodeForm codeForm;

  const CodeFormDeleteDialog({super.key, required this.codeForm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('コードフォームを削除'),
      content: Text('「${codeForm.label}」を削除してもよろしいですか？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(codeFormNotifierProvider.notifier)
                .deleteCodeForm(codeForm.id);
            Navigator.of(context).pop();
          },
          child: const Text('削除'),
        ),
      ],
    );
  }
}
