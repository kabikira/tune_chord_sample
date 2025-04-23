import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormList extends HookConsumerWidget {
  final int tuningId;
  const CodeFormList({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeFormAsync = ref.watch(codeFormNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('CodeFormList tuningId=$tuningId')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: codeFormAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('エラー: $error')),
                data: (codeForms) {
                  // Filter code forms by tuning ID
                  // TODO: これproviderでもつべき？
                  final filteredCodeForms =
                      codeForms
                          .where((form) => form.tuningId == tuningId)
                          .toList();

                  if (filteredCodeForms.isEmpty) {
                    return const Center(child: Text('登録されたコードフォームがありません'));
                  }

                  return ListView.builder(
                    itemCount: filteredCodeForms.length,
                    itemBuilder: (context, index) {
                      final codeForm = filteredCodeForms[index];
                      return ListTile(
                        title: Text(
                          '${codeForm.label} (${codeForm.fretPositions})',
                        ),
                        subtitle:
                            codeForm.memo != null ? Text(codeForm.memo!) : null,
                        onTap: () {
                          context.push(
                            '/tuningList/codeFormList/$tuningId/codeFormDetail',
                            extra: codeForm.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    '/tuningList/codeFormList/$tuningId/codeFormRegister',
                    extra: tuningId,
                  );
                },
                child: const Text('新しいコードフォームを追加'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
