// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/src/config/chord_fracture_colors.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/db/app_database.dart';

/// チューニング文字列をシャープ記号を考慮して解析する関数
List<String> _parseStringNames(String strings) {
  // コンマ区切りの場合はそのまま分割
  if (strings.contains(',')) {
    return strings.split(',');
  }

  // シャープ記号を考慮して解析
  final result = <String>[];
  int i = 0;

  while (i < strings.length) {
    final char = strings[i];

    // 次の文字がシャープ記号かチェック
    if (i + 1 < strings.length && strings[i + 1] == '#') {
      // シャープ記号を含む音名として結合
      result.add('$char#');
      i += 2; // 2文字分進める
    } else {
      // 通常の音名
      result.add(char);
      i += 1;
    }
  }

  return result;
}

class TuningDisplayWidget extends StatelessWidget {
  final AsyncValue<Tuning> tuningAsync;
  final ValueNotifier<List<int>> fretPositions;

  const TuningDisplayWidget({
    super.key,
    required this.tuningAsync,
    required this.fretPositions,
  });

  @override
  Widget build(BuildContext context) {
    const stringCount = 6;
    final theme = Theme.of(context);

    return tuningAsync.when(
      data: (tuning) {
        final stringNames = _parseStringNames(tuning.strings);
        return Row(
          children: List.generate(stringCount, (stringIndex) {
            final position = fretPositions.value[stringIndex]; // 6弦→1弦の並びに変更
            final isStringMuted = position == -1;

            return Expanded(
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                        isStringMuted
                            ? theme.colorScheme.error.withValues(alpha: 0.1)
                            : theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      isStringMuted
                          ? 'X'
                          : (stringIndex < stringNames.length
                              ? stringNames[stringIndex]
                              : ''),
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
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

class MuteControlWidget extends StatelessWidget {
  final int startFret;

  const MuteControlWidget({super.key, required this.startFret});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (startFret != 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_off, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.muteStringLongPress,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FretWidget extends StatelessWidget {
  final int currentFret;
  final int startFret;
  final ValueNotifier<List<int>> fretPositions;

  const FretWidget({
    super.key,
    required this.currentFret,
    required this.startFret,
    required this.fretPositions,
  });

  @override
  Widget build(BuildContext context) {
    const stringCount = 6;
    final theme = Theme.of(context);

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // フレット番号表示部分
          Container(
            width: 30,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$currentFret',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          // フレットボード部分
          Expanded(
            child: Row(
              children: List.generate(stringCount, (stringIndex) {
                return StringWidget(
                  stringIndex: stringIndex, // 6弦→1弦の並びに変更
                  currentFret: currentFret,
                  fretPositions: fretPositions,
                  stringThickness:
                      1.0 +
                      (0.5 *
                          (stringCount - 1 - stringIndex) /
                          (stringCount - 1)),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class StringWidget extends StatelessWidget {
  final int stringIndex;
  final int currentFret;
  final ValueNotifier<List<int>> fretPositions;
  final double stringThickness;

  const StringWidget({
    super.key,
    required this.stringIndex,
    required this.currentFret,
    required this.fretPositions,
    required this.stringThickness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final position = fretPositions.value[stringIndex];
    final isPressed = position == currentFret;
    final isMuted = position == -1;
    final isFirstFret = currentFret == 0;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(),
        onLongPress: () => _handleLongPress(),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border:
                isFirstFret
                    ? null
                    : Border(
                      right: BorderSide(color: theme.dividerColor, width: 1),
                    ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: stringThickness,
                  color:
                      isMuted
                          ? theme.disabledColor.withValues(alpha: 0.3)
                          : theme.disabledColor,
                ),
                if (isMuted && currentFret == 0)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'X',
                        style: TextStyle(
                          color: ChordFractureColors.offWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                if (isPressed && !isMuted)
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color:
                          theme.brightness == Brightness.dark
                              ? ChordFractureColors.a.withValues(alpha: 0.7)
                              : ChordFractureColors.primary.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        currentFret.toString(),
                        style: TextStyle(
                          color:
                              theme.brightness == Brightness.dark
                                  ? ChordFractureColors.background
                                  : theme.colorScheme.onPrimary,
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
  }

  void _handleTap() {
    const stringCount = 6;
    final position = fretPositions.value[stringIndex];
    final isMuted = position == -1;

    if (isMuted && currentFret != 0) return;

    final newPositions = [
      for (int i = 0; i < stringCount; i++)
        if (i == stringIndex)
          fretPositions.value[i] == currentFret ? 0 : currentFret
        else
          fretPositions.value[i],
    ];
    fretPositions.value = newPositions;
  }

  void _handleLongPress() {
    const stringCount = 6;
    final position = fretPositions.value[stringIndex];

    final newPositions = [
      for (int i = 0; i < stringCount; i++)
        if (i == stringIndex)
          position == -1
              ? 0
              : -1 // ミュート状態なら解除、そうでなければミュート
        else
          fretPositions.value[i],
    ];
    fretPositions.value = newPositions;
  }
}

class FretboardGridWidget extends HookWidget {
  final ValueNotifier<List<int>> fretPositions;
  final int maxFrets;
  final int startFret;
  final ValueChanged<int>? onStartFretChanged;

  const FretboardGridWidget({
    super.key,
    required this.fretPositions,
    this.maxFrets = 24,
    this.startFret = 0,
    this.onStartFretChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double fretHeight = 48.0;
    const int visibleFrets = 5;

    final theme = Theme.of(context);

    // States and refs
    final currentStartFret = useState<int>(startFret);
    final isUpdatingFromExternal = useRef<bool>(false);
    final isUserScrolling = useRef<bool>(false);
    final debounceTimer = useRef<Timer?>(null);

    // Scroll controller with initial offset
    final scrollController = useScrollController(
      initialScrollOffset: startFret * fretHeight,
    );

    // Scroll listener effect
    useEffect(() {
      void onScroll() {
        if (isUpdatingFromExternal.value) return;

        isUserScrolling.value = true;
        debounceTimer.value?.cancel();

        final newStartFret = (scrollController.offset / fretHeight)
            .floor()
            .clamp(0, maxFrets - visibleFrets);

        if (newStartFret != currentStartFret.value) {
          currentStartFret.value = newStartFret;
          onStartFretChanged?.call(currentStartFret.value);

          // Brief debounce to reset user scrolling state
          debounceTimer.value =
              Timer(const Duration(milliseconds: 50), () {
            isUserScrolling.value = false;
          });
        }
      }

      scrollController.addListener(onScroll);
      return () {
        scrollController.removeListener(onScroll);
        debounceTimer.value?.cancel();
      };
    }, [scrollController, maxFrets]);

    // Sync external startFret changes
    useEffect(() {
      if (startFret != currentStartFret.value && !isUserScrolling.value) {
        isUpdatingFromExternal.value = true;
        currentStartFret.value = startFret;
        scrollController
            .animateTo(
              startFret * fretHeight,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            )
            .whenComplete(() {
          isUpdatingFromExternal.value = false;
        });
      }
      return null;
    }, [startFret, scrollController]);

    return Container(
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
      height: visibleFrets * fretHeight,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            isUserScrolling.value = true;
          } else if (scrollNotification is ScrollEndNotification) {
            debounceTimer.value?.cancel();
            debounceTimer.value = Timer(
              const Duration(milliseconds: 100),
              () {
                isUserScrolling.value = false;
              },
            );
          }
          return false;
        },
        child: ListView.builder(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: maxFrets,
          itemBuilder: (context, index) {
            return FretWidget(
              currentFret: index,
              startFret: currentStartFret.value,
              fretPositions: fretPositions,
            );
          },
        ),
      ),
    );
  }
}

class ChordCompositionWidget extends StatelessWidget {
  final ValueNotifier<List<int>> fretPositions;
  final VoidCallback? onHelpPressed;

  const ChordCompositionWidget({
    super.key,
    required this.fretPositions,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.currentComposition,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                fretPositions.value
                    .map((p) => p == -1 ? 'X' : p.toString())
                    .join(','), // 6弦→1弦の並びに変更
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (onHelpPressed != null)
            IconButton(
              onPressed: onHelpPressed,
              icon: Icon(Icons.help_outline, color: theme.colorScheme.primary),
              tooltip: AppLocalizations.of(context)!.help,
            ),
        ],
      ),
    );
  }
}

class GuitarFretboardWidget extends HookConsumerWidget {
  final ValueNotifier<List<int>> fretPositions;
  final AsyncValue<Tuning> tuningAsync;
  final VoidCallback? onHelpPressed;
  final ValueNotifier<int>? startFretNotifier;
  final ValueChanged<int>? onStartFretChanged;
  final bool showTuningDisplay;
  final bool showChordComposition;
  final bool showMuteControl;

  const GuitarFretboardWidget({
    super.key,
    required this.fretPositions,
    required this.tuningAsync,
    this.onHelpPressed,
    this.startFretNotifier,
    this.onStartFretChanged,
    this.showTuningDisplay = true,
    this.showChordComposition = true,
    this.showMuteControl = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internalStartFretNotifier = useState(0);
    final effectiveStartFretNotifier =
        startFretNotifier ?? internalStartFretNotifier;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showTuningDisplay) ...[
              TuningDisplayWidget(
                tuningAsync: tuningAsync,
                fretPositions: fretPositions,
              ),
              const SizedBox(height: 16),
            ],
            if (showMuteControl)
              MuteControlWidget(startFret: effectiveStartFretNotifier.value),
            FretboardGridWidget(
              fretPositions: fretPositions,
              startFret: effectiveStartFretNotifier.value,
              onStartFretChanged: (newStartFret) {
                effectiveStartFretNotifier.value = newStartFret;
                onStartFretChanged?.call(newStartFret);
              },
            ),
            if (showChordComposition) ...[
              const SizedBox(height: 16),
              ChordCompositionWidget(
                fretPositions: fretPositions,
                onHelpPressed: onHelpPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
