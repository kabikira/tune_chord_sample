import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/widgets/code_form_widget.dart';

class CodeFormRegister extends ConsumerWidget {
  final int tuningId;
  const CodeFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: Text(l10n.codeFormRegistration),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: CodeFormWidget(
          tuningId: tuningId,
          submitButtonText: l10n.register,
          onSubmit: ({required String fretPositions, String? label, String? memo}) async {
            await ref.read(codeFormNotifierProvider.notifier).addCodeForm(
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

