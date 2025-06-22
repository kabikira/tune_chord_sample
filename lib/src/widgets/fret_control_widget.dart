import 'package:flutter/material.dart';

class FretControlWidget extends StatelessWidget {
  final int selectedFret;
  final VoidCallback onPreviousFret;
  final VoidCallback onNextFret;
  final VoidCallback onReset;
  final bool canGoToPrevious;
  final bool canGoToNext;

  const FretControlWidget({
    super.key,
    required this.selectedFret,
    required this.onPreviousFret,
    required this.onNextFret,
    required this.onReset,
    this.canGoToPrevious = true,
    this.canGoToNext = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
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
                  onPressed: canGoToPrevious ? onPreviousFret : null,
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
                    'フレット $selectedFret',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: canGoToNext ? onNextFret : null,
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
          onPressed: onReset,
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
    );
  }
}