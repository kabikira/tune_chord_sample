import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';
import 'package:tune_chord_sample/src/utils/app_l10n.dart';

class TuningList extends StatelessWidget {
  const TuningList({super.key});

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = Localizations.localeOf(context).toString();
    final l10n = AppL10n.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('TuningList')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(RoutePaths.tuningRegister);
              },
              child: const Text('Go to TuningRegister'),
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
