import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/pages/chordForm/chord_form_notifier.dart';
import 'package:tune_chord_sample/src/widgets/chord_form_widget.dart';

class ChordFormRegister extends ConsumerWidget {
  final int tuningId;
  const ChordFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: Text(l10n.chordFormRegistration),
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
          onSubmit: ({required String fretPositions, String? label, String? memo}) async {
            await ref.read(chordFormNotifierProvider.notifier).addChordForm(
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

