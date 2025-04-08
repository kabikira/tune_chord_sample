import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_notifier.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_register.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_update.dart'; // ← 追加

class TuningList extends HookConsumerWidget {
  const TuningList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tuningAsync = ref.watch(tuningNotifierProvider);

    Intl.defaultLocale = Localizations.localeOf(context).toString();
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('TuningList')),
      body: Column(
        children: [
          Expanded(
            child: tuningAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('エラー: $e')),
              data: (tunings) {
                if (tunings.isEmpty) {
                  return const Center(child: Text('登録されたチューニングがありません'));
                }
                return ListView.builder(
                  itemCount: tunings.length,
                  itemBuilder: (_, index) {
                    final tuning = tunings[index];
                    return ListTile(
                      title: Text(tuning.name),
                      subtitle: Text(tuning.strings),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => TuningUpdate(tuning: tuning),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.push(RoutePaths.codeFormList);
                  },
                  child: const Text('Go to CodeFormList'),
                ),
                const TextField(),
                Text(DateFormat.yMEd().format(DateTime.now())),
                Text(l10n.helloWorld),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (_) => const TuningRegister());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
