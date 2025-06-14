import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormUpdateDialog extends HookConsumerWidget {
  final CodeForm codeForm;

  const CodeFormUpdateDialog({super.key, required this.codeForm});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // フレットポジションをリストに変換
    final initialPositions =
        codeForm.fretPositions
            .split(',')
            .map((s) => int.tryParse(s) ?? 0)
            .toList();
    // 足りない分を0で埋める
    while (initialPositions.length < 6) {
      initialPositions.add(0);
    }

    final fretPositions = useState<List<int>>(initialPositions);
    final selectedFret = useState<int>(0); // 表示するフレット位置
    final labelController = useTextEditingController(text: codeForm.label);
    final memoController = useTextEditingController(text: codeForm.memo ?? '');
    final isSaving = useState(false);
    final theme = Theme.of(context);

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(codeForm.tuningId));

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'コードフォームを編集',
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
                    (tuning) => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.13,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.music_note,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'チューニング: ${tuning.name}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  tuning.strings,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('エラー: $error')),
              ),

              const SizedBox(height: 16),

              Text(
                'コード名',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: labelController,
                decoration: InputDecoration(
                  hintText: 'C, Am7, Em/G など',
                  filled: true,
                  fillColor: theme.colorScheme.surface.withValues(alpha: 0.9),
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

              const SizedBox(height: 24),

              // フレットボード表示
              Text(
                'フレットポジション',
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
                              'フレット ${selectedFret.value}',
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
                            tooltip: '次のフレット',
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
              ),

              const SizedBox(height: 16),

              // ギターフレットボード
              buildGuitarFretboard(
                context,
                fretPositions,
                selectedFret.value,
                tuningAsync,
              ),

              const SizedBox(height: 16),

              Text(
                'メモ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: memoController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '任意のメモを入力できます',
                  filled: true,
                  fillColor: theme.colorScheme.surface.withValues(alpha: 0.9),
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed:
              isSaving.value
                  ? null
                  : () async {
                    isSaving.value = true;

                    final fretString = fretPositions.value.join(',');
                    final updatedCodeForm = CodeForm(
                      id: codeForm.id,
                      tuningId: codeForm.tuningId,
                      fretPositions: fretString,
                      label: labelController.text,
                      memo:
                          memoController.text.isEmpty
                              ? null
                              : memoController.text,
                      createdAt: codeForm.createdAt,
                      updatedAt: DateTime.now(),
                      isFavorite: codeForm.isFavorite,
                      userId: codeForm.userId,
                    );

                    await ref
                        .read(codeFormNotifierProvider.notifier)
                        .updateCodeForm(updatedCodeForm);

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

  // ギターフレットボードの構築
  Widget buildGuitarFretboard(
    BuildContext context,
    ValueNotifier<List<int>> fretPositions,
    int startFret,
    AsyncValue<Tuning> tuningAsync,
  ) {
    const stringCount = 6; // 6弦ギター
    const visibleFrets = 5; // 表示するフレット数
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // チューニング表示
            tuningAsync.whenData((tuning) {
                  final stringNames = tuning.strings.split(',');
                  if (stringNames.length != stringCount) {
                    return const Text('チューニング情報が不正です');
                  }

                  return Row(
                    children: List.generate(stringCount, (stringIndex) {
                      // 逆順（低音が下、高音が上）にするために反転
                      final reversedIndex = stringCount - 1 - stringIndex;
                      final position = fretPositions.value[reversedIndex];

                      // ミュートされている弦はXで表示
                      final isStringMuted = position == -1;

                      // チューニング表示
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color:
                                  isStringMuted
                                      ? theme.colorScheme.error.withValues(
                                        alpha: 0.1,
                                      )
                                      : theme.colorScheme.primary.withValues(
                                        alpha: 0.1,
                                      ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                isStringMuted
                                    ? 'X'
                                    : stringNames[reversedIndex],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isStringMuted
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }).value ??
                const SizedBox.shrink(),

            const SizedBox(height: 16),

            // ミュートコントロール
            if (startFret == 0)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.volume_off,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '弦をミュート (長押し)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // フレットボード
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: List.generate(visibleFrets, (fretIndex) {
                  final currentFret = startFret + fretIndex;
                  final isFirstFret = currentFret == 0;
                  final showFretMarker = _shouldShowFretMarker(currentFret);

                  return Column(
                    children: [
                      // フレットマーカー（特定のフレットにマーク）
                      if (showFretMarker && !isFirstFret)
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                        ),

                      // フレット番号
                      Container(
                        width: double.infinity,
                        color:
                            isFirstFret
                                ? Colors
                                    .black // ナット
                                : const Color(0xFFAAAAAA), // フレット線
                        height: isFirstFret ? 4 : 2,
                        child:
                            isFirstFret
                                ? null
                                : Center(
                                  child: Text(
                                    '$currentFret',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                      ),

                      // 弦と押さえる位置
                      Row(
                        children: List.generate(stringCount, (stringIndex) {
                          // 逆順（低音が下、高音が上）にするために反転
                          final reversedIndex = stringCount - 1 - stringIndex;
                          final position = fretPositions.value[reversedIndex];
                          final isPressed = position == currentFret;
                          final isMuted = position == -1;

                          // 弦の太さを表現
                          final double stringThickness =
                              1.0 +
                              (0.5 *
                                  (stringCount - 1 - stringIndex) /
                                  (stringCount - 1));

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // ミュートされている場合は通常の押さえができない
                                if (isMuted && currentFret != 0) return;

                                // 押さえる位置を切り替え
                                fretPositions.value = [
                                  for (int i = 0; i < stringCount; i++)
                                    if (i == reversedIndex)
                                      fretPositions.value[i] == currentFret
                                          ? 0
                                          : currentFret
                                    else
                                      fretPositions.value[i],
                                ];
                              },
                              onLongPress:
                                  currentFret == 0
                                      ? () {
                                        // 0フレット（ナット）での長押しでミュート/ミュート解除を切り替え
                                        fretPositions.value = [
                                          for (int i = 0; i < stringCount; i++)
                                            if (i == reversedIndex)
                                              fretPositions.value[i] == -1
                                                  ? 0
                                                  : -1
                                            else
                                              fretPositions.value[i],
                                        ];
                                      }
                                      : null,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border:
                                      isFirstFret
                                          ? null
                                          : Border(
                                            right: BorderSide(
                                              color: const Color(0xFFDDDDDD),
                                              width: 1,
                                            ),
                                          ),
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // 弦を表示（ミュートの場合は色を変える）
                                      Container(
                                        height: stringThickness,
                                        color:
                                            isMuted
                                                ? Colors.grey.withValues(
                                                  alpha: 0.3,
                                                )
                                                : const Color(0xFF666666),
                                      ),
                                      // ミュート表示（0フレットのみ）
                                      if (isMuted && currentFret == 0)
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.error
                                                .withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'X',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      // 押さえるマーカー（通常のフレット）
                                      if (isPressed && !isMuted)
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.2),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 3,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              currentFret.toString(),
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.7),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // コードダイアグラム表示
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.51),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // コード構成表示
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '現在の構成:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fretPositions.value
                            .map((p) => p == -1 ? 'X' : p.toString())
                            .join(','),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  // 指使いのヘルプアイコン
                  IconButton(
                    onPressed: () {
                      // 指使いに関するヘルプダイアログ
                      _showHelpDialog(context);
                    },
                    icon: Icon(
                      Icons.help_outline,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'ヘルプ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // フレットマーカーを表示すべきかどうかを判定
  bool _shouldShowFretMarker(int fret) {
    // 一般的なギターのフレットマーカー位置（3, 5, 7, 9, 12, 15, 17, 19, 21, 24）
    return [3, 5, 7, 9, 12, 15, 17, 19, 21, 24].contains(fret);
  }

  // ヘルプダイアログを表示
  void _showHelpDialog(BuildContext context) {
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
                const Text('フレットボードの使い方'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• 弦をタップして押さえる位置を指定', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('• フレット 0 はオープン弦を表します', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: theme.textTheme.bodyMedium),
                    Expanded(
                      child: Text(
                        'フレット 0 での長押しで弦をミュート（X）します',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• 同じ位置を再度タップすると解除されます',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '• 左右の矢印でフレット位置を移動できます',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '閉じる',
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
    orElse: () => throw Exception('チューニングが見つかりません'),
  );
});
