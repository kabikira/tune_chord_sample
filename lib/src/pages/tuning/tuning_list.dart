import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tune_chord_sample/l10n/app_localizations.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';
import 'package:tune_chord_sample/src/pages/tuning/tuning_register.dart';

class TuningList extends StatelessWidget {
  const TuningList({super.key});

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).toString();
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('TuningList')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const TuningRegister(),
                );
              },
              child: const Text('Show TuningRegister Dialog'),
            ),
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
    );
  }
}
