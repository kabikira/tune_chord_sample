// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:drift/drift.dart' as drift;
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/db/app_database.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_notifier.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_providers.dart';
import 'package:chord_fracture/src/utils/fret_position_utils.dart';
import 'package:chord_fracture/src/widgets/chord_form_widget.dart';

class ChordFormEdit extends ConsumerWidget {
  final int chordFormId;
  final int tuningId;

  const ChordFormEdit({
    super.key,
    required this.chordFormId,
    required this.tuningId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final database = ref.read(appDatabaseProvider);
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: tuningAsync.when(
          data: (tuning) => Text('${tuning.strings} - ${l10n.chordFormEdit}'),
          loading: () => Text(l10n.chordFormEdit),
          error: (_, __) => Text(l10n.chordFormEdit),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<ChordForm?>(
          future: _getChordForm(database, chordFormId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(l10n.errorMessage),
              );
            }

            final chordForm = snapshot.data;
            if (chordForm == null) {
              return Center(child: Text(l10n.chordFormNotFound));
            }

            // fretPositionsを文字列からList<int>に変換
            final fretPositions = FretPositionUtils.parseFretPositions(
              chordForm.fretPositions,
            );

            return ChordFormWidget(
              tuningId: tuningId,
              submitButtonText: l10n.update,
              initialLabel: chordForm.label,
              initialMemo: chordForm.memo,
              initialFretPositions: fretPositions,
              onSubmit: ({
                required String fretPositions,
                String? label,
                String? memo,
              }) async {
                final updatedChordForm = chordForm.copyWith(
                  fretPositions: fretPositions,
                  label:
                      label != null
                          ? drift.Value(label)
                          : const drift.Value.absent(),
                  memo:
                      memo != null
                          ? drift.Value(memo)
                          : const drift.Value.absent(),
                );
                await ref
                    .read(chordFormNotifierProvider.notifier)
                    .updateChordForm(updatedChordForm);
              },
            );
          },
        ),
      ),
    );
  }

  Future<ChordForm?> _getChordForm(AppDatabase database, int id) async {
    try {
      final allChordForms = await database.getAllChordForms();
      return allChordForms.where((form) => form.id == id).firstOrNull;
    } catch (e) {
      return null;
    }
  }
}
