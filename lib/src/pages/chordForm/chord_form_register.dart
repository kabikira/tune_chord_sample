// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_notifier.dart';
import 'package:chord_fracture/src/pages/chordForm/chord_form_providers.dart';
import 'package:chord_fracture/src/widgets/chord_form_widget.dart';

class ChordFormRegister extends ConsumerWidget {
  final int tuningId;
  const ChordFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tuningAsync = ref.watch(singleTuningProvider(tuningId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: tuningAsync.when(
          data:
              (tuning) =>
                  Text('${tuning.strings} - ${l10n.chordFormRegistration}'),
          loading: () => Text(l10n.chordFormRegistration),
          error: (_, __) => Text(l10n.chordFormRegistration),
        ),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: ChordFormWidget(
          tuningId: tuningId,
          submitButtonText: l10n.register,
          onSubmit: ({
            required String fretPositions,
            String? label,
            String? memo,
          }) async {
            // 上限チェック（同一チューニングで10件まで）
            final forms =
                ref.read(chordFormNotifierProvider).valueOrNull ?? [];
            final count = forms.where((f) => f.tuningId == tuningId).length;
            if (count >= 10) {
              await showDialog(
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
            await ref
                .read(chordFormNotifierProvider.notifier)
                .addChordForm(
                  tuningId: tuningId,
                  fretPositions: fretPositions,
                  label: label,
                  memo: memo,
                );
          },
        ),
      ),
    );
  }
}
