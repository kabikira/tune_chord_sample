import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CodeFormDetail extends StatelessWidget {
  final int tuningId;

  const CodeFormDetail({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CodeFormDetail tuningId=$tuningId')),
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
