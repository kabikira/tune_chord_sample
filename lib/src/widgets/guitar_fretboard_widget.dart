import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

class GuitarFretboardWidget extends HookConsumerWidget {
  final ValueNotifier<List<int>> fretPositions;
  final int startFret;
  final AsyncValue<Tuning> tuningAsync;
  final VoidCallback? onHelpPressed;

  const GuitarFretboardWidget({
    super.key,
    required this.fretPositions,
    required this.startFret,
    required this.tuningAsync,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: Row(
                children: [
                  // 左側のフレット番号列
                  Container(
                    width: 30,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      border: Border.all(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(visibleFrets, (fretIndex) {
                        final currentFret = startFret + fretIndex;
                        return Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            '$currentFret',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // フレットボード本体
                  Expanded(
                    child: Column(
                      children: List.generate(visibleFrets, (fretIndex) {
                        final currentFret = startFret + fretIndex;
                        final isFirstFret = currentFret == 0;
                        final showFretMarker = _shouldShowFretMarker(
                          currentFret,
                        );

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
                            ),

                            // 弦と押さえる位置
                            Row(
                              children: List.generate(stringCount, (
                                stringIndex,
                              ) {
                                // 逆順（低音が下、高音が上）にするために反転
                                final reversedIndex =
                                    stringCount - 1 - stringIndex;
                                final position =
                                    fretPositions.value[reversedIndex];
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
                                      final newPositions = [
                                        for (int i = 0; i < stringCount; i++)
                                          if (i == reversedIndex)
                                            fretPositions.value[i] ==
                                                    currentFret
                                                ? 0
                                                : currentFret
                                          else
                                            fretPositions.value[i],
                                      ];
                                      fretPositions.value = newPositions;
                                    },
                                    onLongPress:
                                        currentFret == 0
                                            ? () {
                                              // 0フレット（ナット）での長押しでミュート/ミュート解除を切り替え
                                              final newPositions = [
                                                for (
                                                  int i = 0;
                                                  i < stringCount;
                                                  i++
                                                )
                                                  if (i == reversedIndex)
                                                    fretPositions.value[i] == -1
                                                        ? 0
                                                        : -1
                                                  else
                                                    fretPositions.value[i],
                                              ];
                                              fretPositions.value =
                                                  newPositions;
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
                                                    color: const Color(
                                                      0xFFDDDDDD,
                                                    ),
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
                                                  color: Colors.black
                                                      .withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      blurRadius: 3,
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'X',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  color: theme
                                                      .colorScheme
                                                      .primary
                                                      .withValues(alpha: 0.1),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      blurRadius: 3,
                                                      offset: const Offset(
                                                        0,
                                                        1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    currentFret.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                ],
              ),
            ),

            const SizedBox(height: 16),

            // コードダイアグラム表示
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
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
                  if (onHelpPressed != null)
                    IconButton(
                      onPressed: onHelpPressed,
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
}