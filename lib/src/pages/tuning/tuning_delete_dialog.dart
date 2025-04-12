import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';

class TuningDeleteDialog extends HookConsumerWidget {
  final Tuning tuning;

  const TuningDeleteDialog({super.key, required this.tuning});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('削除確認'),
      content: Text('「${tuning.name}」を削除しますか？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // キャンセル
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: () async {
            await ref
                .read(tuningNotifierProvider.notifier)
                .deleteTuning(tuning.id);
            if (context.mounted) {
              Navigator.of(context).pop(); // ダイアログ閉じる
            }
          },
          child: const Text('削除', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
