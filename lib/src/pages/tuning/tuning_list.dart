import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';

class TuningList extends StatelessWidget {
  const TuningList({super.key});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}
