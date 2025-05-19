import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';

class TuningUpdateDialog extends HookConsumerWidget {
  final Tuning tuning;

  const TuningUpdateDialog({super.key, required this.tuning});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: tuning.name);
    final stringsController = useTextEditingController(text: tuning.strings);
    final isSaving = useState(false);
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'チューニングを編集',
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
              'チューニング名',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
            ),
            const SizedBox(height: 16),
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
              decoration: InputDecoration(
                hintText: '例: C,G,D,G,C,D',
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
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
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed:
              isSaving.value
                  ? null
                  : () async {
                    final name = nameController.text.trim();
                    final strings = stringsController.text.trim();
                    if (name.isEmpty || strings.isEmpty) return;

                    isSaving.value = true;
                    await ref
                        .read(tuningNotifierProvider.notifier)
                        .updateTuning(
                          id: tuning.id,
                          name: name,
                          strings: strings,
                        );
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
                  : const Text('更新'),
        ),
      ],
    );
  }
}
