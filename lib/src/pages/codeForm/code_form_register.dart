import 'package:flutter/material.dart';

class CodeFormRegister extends StatelessWidget {
  final int tuningId;

  const CodeFormRegister({super.key, required this.tuningId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CodeFormRegister tuningId=$tuningId')),
      body: const Center(child: Text('CodeFormRegister')),
    );
  }
}
