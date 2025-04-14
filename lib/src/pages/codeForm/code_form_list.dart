import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CodeFormList extends StatelessWidget {
  final int tuningId;
  const CodeFormList({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CodeFormList tuningId=$tuningId')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('codeFormRegister');
              },
              child: const Text('Go to CodeFormRegister'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('codeFormDetail');
              },
              child: const Text('Go to CodeFormDetail'),
            ),
          ],
        ),
      ),
    );
  }
}
