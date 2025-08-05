// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:resonance/l10n/app_localizations.dart';
import 'package:resonance/src/config/left_handed_provider.dart';
import 'package:resonance/src/config/resonance_colors.dart';
import 'package:resonance/src/db/app_database.dart';

class ChordDiagramWidget extends ConsumerWidget {
  final ChordForm codeForm;
  final bool isEnhanced;
  final String? title;

  const ChordDiagramWidget({
    super.key,
    required this.codeForm,
    this.isEnhanced = false,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isEnhanced) {
      return _buildEnhancedChordDiagram(context, ref);
    } else {
      return _buildSimpleChordDiagram(context, ref);
    }
  }

  Widget _buildSimpleChordDiagram(BuildContext context, WidgetRef ref) {
    final isLeftHanded = ref.watch(leftHandedNotifierProvider).value ?? false;
    final splitPositions = codeForm.fretPositions.split('');
    final positions = isLeftHanded ? splitPositions : splitPositions.reversed.toList();

    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: positions.map((pos) {
          final displayText = (pos == 'X' || pos == '-1') ? 'X' : pos;
          final isX = (pos == 'X' || pos == '-1');
          return Column(
            children: [
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isX ? Colors.red : Colors.black,
                ),
              ),
              Expanded(
                child: Container(width: 2, color: Colors.grey.shade400),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEnhancedChordDiagram(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLeftHanded = ref.watch(leftHandedNotifierProvider).value ?? false;
    final splitPositions = codeForm.fretPositions.split('');
    final positions = isLeftHanded ? splitPositions : splitPositions.reversed.toList();

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: ResonanceColors.offWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            title ?? 'コードダイアグラム',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: positions.map((pos) {
                final displayText = (pos == 'X' || pos == '-1') ? 'X' : pos;
                final isX = (pos == 'X' || pos == '-1');
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isX
                            ? Colors.red.withValues(alpha: 0.1)
                            : theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        displayText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isX ? Colors.red : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FretPositionDisplay extends StatelessWidget {
  final List<int> fretPositions;
  final String? label;

  const FretPositionDisplay({
    super.key,
    required this.fretPositions,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? l10n.currentComposition,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fretPositions
                .map((p) => p == -1 ? 'X' : p.toString())
                .join(','),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class TuningInfoCard extends StatelessWidget {
  final String tuningName;
  final String tuningStrings;
  final IconData? icon;

  const TuningInfoCard({
    super.key,
    required this.tuningName,
    required this.tuningStrings,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
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
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.music_note,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tuningInfo,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tuningName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tuningStrings,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
