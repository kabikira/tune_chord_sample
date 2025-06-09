import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';
import 'package:tune_chord_sample/src/config/validation_constants.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';

class TuningKeyboard extends HookWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ThemeData theme;
  final AppLocalizations l10n;

  const TuningKeyboard({
    required this.controller,
    required this.focusNode,
    required this.theme,
    required this.l10n,
    super.key,
  });

  void insertText(String text) {
    final currentText = controller.text;
    if (currentText.length + text.length >
        ValidationConstants.maxTuningLength) return;
    final newText = currentText + text;
    controller.text = newText;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: newText.length),
    );
  }

  void deleteText() {
    final currentText = controller.text;
    if (currentText.isNotEmpty) {
      final newText = currentText.substring(0, currentText.length - 1);
      controller.text = newText;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    }
  }

  Widget buildKey(String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => insertText(label),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [buildKey("A"), buildKey("B"), buildKey("C")]),
          Row(children: [buildKey("D"), buildKey("E"), buildKey("F")]),
          Row(children: [buildKey("G"), buildKey("#"), buildKey("")]),
          Row(
            children: [
              buildKey("⌫", onTap: deleteText),
              buildKey(" "),
              buildKey(
                l10n.complete,
                onTap: () {
                  focusNode.unfocus();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TuningRegister extends HookConsumerWidget {
  const TuningRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final stringsController = useTextEditingController();
    final stringsFocusNode = useFocusNode();
    final isSaving = useState(false);
    final selectedTagIds = useState<List<int>>([]);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // タグ一覧を取得
    final tagsAsync = ref.watch(tagsProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.music_note, color: theme.colorScheme.primary),
          const Gap(8),
          Text(
            l10n.registerTuning, // チューニングを登録
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
              l10n.stringTuning, // 弦のチューニング
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            TextField(
              controller: stringsController,
              focusNode: stringsFocusNode,
              readOnly: true,
              showCursor: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  ValidationConstants.maxTuningLength,
                ),
              ],
              maxLength: ValidationConstants.maxTuningLength,
              decoration: InputDecoration(
                hintText: l10n.tuningExample, // 例: CGDGCD
                filled: true,
                fillColor: theme.colorScheme.surfaceContainer.withValues(
                  alpha: 0.3,
                ),
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
              onTap: () {
                stringsFocusNode.requestFocus();
                showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.transparent,
                  builder: (BuildContext context) {
                    return TuningKeyboard(
                      controller: stringsController,
                      focusNode: stringsFocusNode,
                      theme: theme,
                      l10n: l10n,
                    );
                  },
                ).whenComplete(() => stringsFocusNode.unfocus());
              },
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      l10n.tuningInputDescription, // 低音から高音の順に入力してください
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            Text(
              l10n.tags, // タグ
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(8),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final controller = TextEditingController();
                    final result = await showDialog<String>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text(l10n.newTag), // 新規タグ
                          content: TextField(
                            controller: controller,
                            autofocus: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(
                                ValidationConstants.maxTagLength,
                              ),
                            ],
                            maxLength: ValidationConstants.maxTagLength,
                            decoration: InputDecoration(
                              hintText: l10n.newTag, // 新規タグ
                            ),
                          ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.cancel), // キャンセル
                              ),
                              TextButton(
                                onPressed: () {
                                  final text = controller.text.trim();
                                  if (text.isNotEmpty &&
                                      text.length <=
                                          ValidationConstants.maxTagLength) {
                                    Navigator.pop(
                                      context,
                                      text,
                                    );
                                  }
                                },
                                child: Text(l10n.complete), // 完了
                              ),
                            ],
                          ),
                    );
                    if (result != null) {
                      final db = ref.read(appDatabaseProvider);
                      final tagId = await db.addTag(
                        TagsCompanion(name: drift.Value(result)),
                      );
                      selectedTagIds.value = [...selectedTagIds.value, tagId];
                    }
                  },
                  icon: Icon(Icons.add, color: theme.colorScheme.primary),
                ),
              ],
            ),
            const Gap(8),
            tagsAsync.when(
              data:
                  (tags) => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        tags.map((tag) {
                          final isSelected = selectedTagIds.value.contains(
                            tag.id,
                          );
                          return FilterChip(
                            label: Text(tag.name),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                selectedTagIds.value = [
                                  ...selectedTagIds.value,
                                  tag.id,
                                ];
                              } else {
                                selectedTagIds.value =
                                    selectedTagIds.value
                                        .where((id) => id != tag.id)
                                        .toList();
                              }
                            },
                            backgroundColor: theme.colorScheme.surfaceContainer
                                .withValues(alpha: 0.3),
                            selectedColor: theme.colorScheme.primaryContainer,
                            checkmarkColor:
                                theme.colorScheme.onPrimaryContainer,
                            labelStyle: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  isSelected
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurface,
                            ),
                          );
                        }).toList(),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('エラーが発生しました: $error'),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
              isSaving.value
                  ? null
                  : () async {
                    final name = nameController.text.trim();
                    final strings = stringsController.text.trim();
                    if (strings.isEmpty) return;

                    isSaving.value = true;
                    await ref
                        .read(tuningNotifierProvider.notifier)
                        .addTuning(name, strings, tagIds: selectedTagIds.value);
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
                  : Text(l10n.complete), // 完了
        ),
      ],
    );
  }
}
