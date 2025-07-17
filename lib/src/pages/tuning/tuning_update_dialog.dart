import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/tuning/tag_delete_dialog.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';
import 'package:gap/gap.dart';
import 'package:flutter/services.dart';
import 'package:tune_chord_sample/src/config/validation_constants.dart';

class TuningUpdateDialog extends HookConsumerWidget {
  final Tuning tuning;

  const TuningUpdateDialog({super.key, required this.tuning});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: tuning.name);
    final stringsController = useTextEditingController(text: tuning.strings);
    final isSaving = useState(false);
    final selectedTagIds = useState<List<int>>([]);
    final stringsErrorMessage = useState<String?>(null);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // フォームバリデーション
    void validateForm() {
      final strings = stringsController.text.trim();
      
      // 弦のチューニングバリデーション
      final stringValidation = ValidationConstants.validateTuningString(strings);
      stringsErrorMessage.value = stringValidation != null 
          ? ValidationConstants.getErrorMessage(stringValidation, l10n)
          : null;
    }

    // タグ一覧を取得
    final tagsAsync = ref.watch(tagsProvider);

    // 既存のタグを取得
    useEffect(() {
      Future<void> loadExistingTags() async {
        final db = ref.read(appDatabaseProvider);
        final tuningTags = await db.getAllTuningTags();
        final existingTagIds =
            tuningTags
                .where((tag) => tag.tuningId == tuning.id)
                .map((tag) => tag.tagId)
                .toList();
        selectedTagIds.value = existingTagIds;
      }

      loadExistingTags();
      return null;
    }, []);

    // コントローラーのリスナー設定
    useEffect(() {
      void stringsListener() => validateForm();
      
      stringsController.addListener(stringsListener);
      
      return () {
        stringsController.removeListener(stringsListener);
      };
    }, []);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.edit, color: theme.colorScheme.primary),
          const Gap(8),
          Text(
            l10n.editTuning, // チューニングを編集
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
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  ValidationConstants.maxTuningLength,
                ),
              ],
              maxLength: ValidationConstants.maxTuningLength,
              decoration: InputDecoration(
                hintText: l10n.tuningExample, // 例: CGDGCD
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: stringsErrorMessage.value != null 
                        ? theme.colorScheme.error 
                        : theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                    width: 2,
                  ),
                ),
                errorText: stringsErrorMessage.value,
                errorStyle: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 12,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const Gap(24),
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
                      builder: (context) => AlertDialog(
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
                      final tagNotifier = ref.read(tagNotifierProvider);
                      final tagId = await tagNotifier.addTag(result);
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
                          return GestureDetector(
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => TagDeleteDialog(tag: tag),
                              );
                            },
                            child: FilterChip(
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
                              backgroundColor: theme
                                  .colorScheme
                                  .surfaceContainer
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
                    
                    // バリデーション強化
                    final stringValidation = ValidationConstants.validateTuningString(strings);
                    if (stringValidation != null) {
                      stringsErrorMessage.value = ValidationConstants.getErrorMessage(stringValidation, l10n);
                      return;
                    }
                    
                    // チューニング名の文字数バリデーション
                    if (name.length > ValidationConstants.maxTuningLength) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.tuningNameTooLong(ValidationConstants.maxTuningLength)),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                      return;
                    }

                    isSaving.value = true;
                    await ref
                        .read(tuningNotifierProvider.notifier)
                        .updateTuning(
                          id: tuning.id,
                          name: name,
                          strings: strings,
                          tagIds: selectedTagIds.value,
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
                  : Text(l10n.update), // 更新
        ),
      ],
    );
  }
}
