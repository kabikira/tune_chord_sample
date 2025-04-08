import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tune_chord_sample/src/db/app_database.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';

class TuningUpdate extends HookConsumerWidget {
  final Tuning tuning;

  const TuningUpdate({super.key, required this.tuning});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: tuning.name);
    final stringsController = useTextEditingController(text: tuning.strings);
    final isSaving = useState(false);

    return AlertDialog(
      title: const Text('Tuning Update'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Tuning Name'),
          ),
          TextField(
            controller: stringsController,
            decoration: const InputDecoration(
              labelText: 'Strings (例: E,A,D,G,B,E)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              isSaving.value
                  ? null
                  : () async {
                    final name = nameController.text.trim();
                    final strings = stringsController.text.trim();
                    if (name.isEmpty || strings.isEmpty) return;

                    isSaving.value = true;
                    await ref
                        .read(tuningNotifierProvider.notifier)
                        .updateTuning(
                          id: tuning.id,
                          name: name,
                          strings: strings,
                        );
                    isSaving.value = false;
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          child: const Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
