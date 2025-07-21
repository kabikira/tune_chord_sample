// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_hooks/flutter_hooks.dart';

// Project imports:
import 'package:resonance/l10n/app_localizations.dart';
import 'package:resonance/src/config/validation_constants.dart';

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
    final currentLengthWithoutSharps = currentText.replaceAll('#', '').length;
    final textLengthWithoutSharps = text.replaceAll('#', '').length;
    if (currentLengthWithoutSharps + textLengthWithoutSharps >
        ValidationConstants.maxTuningStringLength) {
      return;
    }
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
