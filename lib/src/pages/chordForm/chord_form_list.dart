// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/db/app_database.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_delete_dialog.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_notifier.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_providers.dart';
import 'package:chord_fracture/src/pages/tuning/tuning_notifier.dart';
import 'package:chord_fracture/src/utils/date_utils.dart' as utils;
import 'package:chord_fracture/src/utils/fret_position_utils.dart';
import 'package:chord_fracture/src/widgets/dialog_action_buttons.dart';
import 'package:chord_fracture/src/widgets/guitar_fretboard_widget.dart';

// TODO:あとで分ける
// 表示モードを管理するプロバイダー
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.list);

// TODO:あとでenumのファイルに分ける
// 表示モードの列挙型
enum ViewMode { list, detail }

class ChordFormList extends HookConsumerWidget {
  final int tuningId;
  const ChordFormList({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chordFormAsync = ref.watch(chordFormNotifierProvider);
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));
    final viewMode = ref.watch(viewModeProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: tuningAsync.when(
          data: (tuning) => Text('${tuning.strings} - ${l10n.chordFormList}'),
          loading: () => Text(l10n.chordFormList),
          error: (_, __) => Text(l10n.chordFormList),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          // 表示モード切り替えボタン
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: () {
                  // 表示モードを切り替え
                  ref.read(viewModeProvider.notifier).state =
                      viewMode == ViewMode.list
                          ? ViewMode.detail
                          : ViewMode.list;
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    viewMode == ViewMode.list
                        ? Icons.view_module
                        : Icons.view_list,
                    color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chordFormAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(l10n.errorOccurred)),
              data: (chordForms) {
                // チューニングIDに基づいてコードフォームをフィルタリング
                final filteredChordForms =
                    chordForms
                        .where((form) => form.tuningId == tuningId)
                        .toList();

                if (filteredChordForms.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 64,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noChordFormsFound,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 表示モードに応じてビューを切り替え
                return viewMode == ViewMode.list
                    ? _buildListView(context, ref, filteredChordForms, l10n)
                    : _buildDetailView(context, ref, filteredChordForms, l10n);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final l10n = AppLocalizations.of(context)!;
          final forms = ref.read(chordFormNotifierProvider).valueOrNull ?? [];
          final count = forms.where((f) => f.tuningId == tuningId).length;
          if (count >= 10) {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: Text(l10n.chordFormLimitReachedTitle),
                content: Text(l10n.chordFormLimitReachedShort),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(l10n.ok),
                  ),
                ],
              ),
            );
            return;
          }
          context.push(
            '/tuningList/chordFormList/$tuningId/chordFormRegister',
            extra: tuningId,
          );
        },
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }

  // リスト表示モード
  Widget _buildListView(
    BuildContext context,
    WidgetRef ref,
    List<ChordForm> chordForms,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chordForms.length,
      itemBuilder: (context, index) {
        final chordForm = chordForms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // 詳細画面へ遷移
              context.push(
                '/tuningList/chordFormList/$tuningId/chordFormDetail',
                extra: chordForm.id,
              );
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chordForm.label ?? '',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.fretPositionLabel(
                                FretPositionUtils.parseFretPositions(
                                      chordForm.fretPositions,
                                    )
                                    .map((p) => p == -1 ? 'X' : p.toString())
                                    .join(','),
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            if (chordForm.memo != null &&
                                chordForm.memo!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'メモ: ${chordForm.memo!}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      InteractionButtons(
                        onEdit: () {
                          context.push(
                            '/tuningList/chordFormList/$tuningId/chordFormEdit',
                            extra: chordForm.id,
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) =>
                                    ChordFormDeleteDialog(chordForm: chordForm),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.registrationDate}: ${utils.DateUtils.formatDate(chordForm.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.update,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.updateDate}: ${utils.DateUtils.formatDate(chordForm.updatedAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 詳細表示モード - すべてのコードフォームの詳細を表示
  Widget _buildDetailView(
    BuildContext context,
    WidgetRef ref,
    List<ChordForm> chordForms,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chordForms.length,
      itemBuilder: (context, index) {
        final chordForm = chordForms[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chordForm.label ?? '',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.fretPositionLabel(
                                FretPositionUtils.parseFretPositions(
                                      chordForm.fretPositions,
                                    )
                                    .map((p) => p == -1 ? 'X' : p.toString())
                                    .join(','),
                              ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InteractionButtons(
                        onEdit: () {
                          context.push(
                            '/tuningList/chordFormList/$tuningId/chordFormEdit',
                            extra: chordForm.id,
                          );
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) =>
                                    ChordFormDeleteDialog(chordForm: chordForm),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.registrationDate}: ${utils.DateUtils.formatDate(chordForm.createdAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.update,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${l10n.updateDate}: ${utils.DateUtils.formatDate(chordForm.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Consumer(
                  builder: (context, ref, child) {
                    final tuningAsync = ref.watch(tuningNotifierProvider);
                    return tuningAsync.when(
                      data: (tunings) {
                        final tuning = tunings.firstWhere(
                          (t) => t.id == chordForm.tuningId,
                          orElse: () => throw Exception('Not find tuning'),
                        );

                        final fretPositions = ValueNotifier<List<int>>(
                          FretPositionUtils.parseFretPositions(
                            chordForm.fretPositions,
                          ),
                        );

                        return GuitarFretboardWidget(
                          fretPositions: fretPositions,
                          tuningAsync: AsyncValue.data(tuning),
                          showMuteControl: false,
                          showTuningDisplay: false,
                          showChordComposition: false,
                        );
                      },
                      loading:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      error:
                          (error, stack) =>
                              Center(child: Text('error: $error')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
