import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';
import 'package:tune_chord_sample/src/widgets/code_form_widget.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';

class CodeFormEdit extends ConsumerWidget {
  final int codeFormId;
  final int tuningId;
  
  const CodeFormEdit({
    super.key, 
    required this.codeFormId,
    required this.tuningId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final database = ref.read(appDatabaseProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: const Text('コードフォーム編集'),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<CodeForm?>(
          future: _getCodeForm(database, codeFormId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(child: Text('エラー: ${snapshot.error}'));
            }
            
            final codeForm = snapshot.data;
            if (codeForm == null) {
              return const Center(child: Text('コードフォームが見つかりません'));
            }

            // fretPositionsを文字列からList<int>に変換
            final fretPositions = codeForm.fretPositions
                .split(',')
                .map((s) => int.tryParse(s) ?? 0)
                .toList();

            return CodeFormWidget(
              tuningId: tuningId,
              submitButtonText: '更新する',
              initialLabel: codeForm.label,
              initialMemo: codeForm.memo,
              initialFretPositions: fretPositions,
              onSubmit: ({required String fretPositions, String? label, String? memo}) async {
                final updatedCodeForm = codeForm.copyWith(
                  fretPositions: fretPositions,
                  label: label != null ? drift.Value(label) : const drift.Value.absent(),
                  memo: memo != null ? drift.Value(memo) : const drift.Value.absent(),
                );
                await ref.read(codeFormNotifierProvider.notifier).updateCodeForm(updatedCodeForm);
              },
            );
          },
        ),
      ),
    );
  }

  Future<CodeForm?> _getCodeForm(AppDatabase database, int id) async {
    try {
      final allCodeForms = await database.getAllCodeForms();
      return allCodeForms.where((form) => form.id == id).firstOrNull;
    } catch (e) {
      return null;
    }
  }
}
