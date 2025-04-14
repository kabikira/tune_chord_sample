import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                context.push('codeFormEdit');
              },
              child: const Text('Go to CodeFormEdit'),
            ),
          ],
        ),
      ),
    );
  }
}
