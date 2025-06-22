import 'package:flutter/material.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

class ChordDiagramWidget extends StatelessWidget {
  final CodeForm codeForm;
  final bool isEnhanced;
  final String? title;

  const ChordDiagramWidget({
    super.key,
    required this.codeForm,
    this.isEnhanced = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (isEnhanced) {
      return _buildEnhancedChordDiagram(context);
    } else {
      return _buildSimpleChordDiagram(context);
    }
  }

  Widget _buildSimpleChordDiagram(BuildContext context) {
    final positions = codeForm.fretPositions.split('');

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
          return Column(
            children: [
              Text(
                pos == 'X' ? 'X' : pos,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: pos == 'X' ? Colors.red : Colors.black,
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

  Widget _buildEnhancedChordDiagram(BuildContext context) {
    final theme = Theme.of(context);
    final positions = codeForm.fretPositions.split('');

    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
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
                final isX = pos == 'X';
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
                        isX ? 'X' : pos,
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
            label ?? '現在の構成:',
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
                    'チューニング',
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