import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tune_chord_sample/src/config/route_paths.dart';

class CodeFormDetail extends StatelessWidget {
  const CodeFormDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CodeFormDetail')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push(RoutePaths.codeFormEdit);
              },
              child: const Text('Go to CodeFormEdit'),
            ),
          ],
        ),
      ),
    );
  }
}
