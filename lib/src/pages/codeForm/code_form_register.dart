import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/pages/codeForm/code_form_notifier.dart';

class CodeFormRegister extends HookConsumerWidget {
  final int tuningId;
  const CodeFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fretPositions = useState<List<int>>(List.filled(6, 0));
    return Scaffold(
      appBar: AppBar(title: Text('CodeFormRegister tuningId=$tuningId')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildFretBoard(fretPositions),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final fretString = fretPositions.value.join(',');
                await ref
                    .read(codeFormNotifierProvider.notifier)
                    .addCodeForm(
                      tuningId: tuningId,
                      fretPositions: fretString,
                      label: 'Em',
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('登録する'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFretBoard(ValueNotifier<List<int>> fretPositions) {
    const stringCount = 6;
    const fretCount = 5;
    return Column(
      children: List.generate(stringCount, (stringIndex) {
        return Row(
          children: List.generate(fretCount, (fretIndex) {
            final isPressed = fretPositions.value[stringIndex] == fretIndex;
            return GestureDetector(
              onTap: () {
                fretPositions.value = [
                  for (int i = 0; i < stringCount; i++)
                    if (i == stringIndex)
                      fretPositions.value[i] == fretIndex ? 0 : fretIndex
                    else
                      fretPositions.value[i],
                ];
              },
              child: Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: isPressed ? Colors.blueAccent : Colors.white,
                ),
                child:
                    isPressed
                        ? const Center(
                          child: Icon(
                            Icons.circle,
                            size: 12,
                            color: Colors.black,
                          ),
                        )
                        : null,
              ),
            );
          }),
        );
      }),
    );
  }
}
