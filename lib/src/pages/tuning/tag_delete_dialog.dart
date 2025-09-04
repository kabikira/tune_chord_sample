// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/db/app_database.dart';

class TagDeleteDialog extends HookConsumerWidget {
  final Tag tag;

  const TagDeleteDialog({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDeleting = ValueNotifier<bool>(false);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.delete_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Text(
            l10n.deleteTag, // タグの削除
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        l10n.deleteTagConfirmation(tag.name), // {tagName}を削除してもよろしいですか？
        style: theme.textTheme.bodyMedium,
      ),
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
            l10n.cancel, // キャンセル
            style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(179)),
          ),
        ),
        ElevatedButton(
          onPressed:
              isDeleting.value
                  ? null
                  : () async {
                    isDeleting.value = true;
                    try {
                      final db = ref.read(appDatabaseProvider);
                      await db.deleteTag(tag.id);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    } finally {
                      isDeleting.value = false;
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: 0,
          ),
          child:
              isDeleting.value
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onError,
                    ),
                  )
                  : Text(l10n.delete), // 削除
        ),
      ],
    );
  }
}
