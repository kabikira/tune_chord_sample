import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';

class CodeFormList extends StatelessWidget {
  const CodeFormList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CodeFormList')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(RoutePaths.codeFormRegister);
              },
              child: const Text('Go to CodeFormRegister'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push(RoutePaths.codeFormDetail);
              },
              child: const Text('Go to CodeFormDetail'),
            ),
          ],
        ),
      ),
    );
  }
}
