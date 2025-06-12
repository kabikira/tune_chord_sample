import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormRegister extends HookConsumerWidget {
  final int tuningId;
  const CodeFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fretPositions = useState<List<int>>(List.filled(6, 0));
    final selectedFret = useState<int>(0); // 表示するフレット位置
    final labelController = useTextEditingController();
    final memoController = useTextEditingController();
    final theme = Theme.of(context);

    // チューニング情報を取得
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withAlpha(242),
      appBar: AppBar(
        title: const Text('コードフォーム登録'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // チューニング情報表示
              tuningAsync.when(
                data:
                    (tuning) => Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(128),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.music_note,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'チューニング',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(179),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tuning.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tuning.strings,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withAlpha(179),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('エラー: $error')),
              ),

              const SizedBox(height: 24),

              // フォーム部分
              Text(
                'コード情報',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 16),

              // コード名入力フィールド
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
                  hintText: 'Em, C, G7など',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withAlpha(77),
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
                    color: theme.colorScheme.surfaceVariant.withAlpha(77),
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
                              color: theme.colorScheme.primary.withAlpha(26),
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
                      // リセット時にラベルもクリア
                      labelController.text = '';
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

              const SizedBox(height: 24),

              // メモ
              Text(
                'メモ（任意）',
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
                  hintText: 'コードに関するメモを入力...',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant.withAlpha(77),
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

              const SizedBox(height: 32),

              // 登録ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (labelController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('コード名を入力してください')),
                      );
                      return;
                    }

                    final fretString = fretPositions.value.join(',');
                    await ref
                        .read(codeFormNotifierProvider.notifier)
                        .addCodeForm(
                          tuningId: tuningId,
                          fretPositions: fretString,
                          label: labelController.text,
                          memo:
                              memoController.text.isEmpty
                                  ? null
                                  : memoController.text,
                        );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('登録する'),
                ),
              ),
            ],
          ),
        ),
      ),
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
                                      ? theme.colorScheme.error.withAlpha(26)
                                      : theme.colorScheme.primary.withAlpha(26),
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
                  color: theme.colorScheme.surfaceVariant.withAlpha(77),
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
                color: const Color(0xFFEFDDC4), // フレットボードの木目の色
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(26),
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
                        color: theme.colorScheme.surfaceVariant,
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
                                  color: Colors.white.withAlpha(204),
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
                                                      ? Colors.grey.withAlpha(
                                                        77,
                                                      )
                                                      : const Color(0xFF666666),
                                            ),
                                            // ミュート表示（0フレットのみ）
                                            if (isMuted && currentFret == 0)
                                              Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withAlpha(
                                                    51,
                                                  ),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(51),
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
                                                      .withAlpha(51),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(51),
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
                  color: theme.colorScheme.primary.withAlpha(26),
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
                          color: theme.colorScheme.onSurface.withAlpha(179),
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
