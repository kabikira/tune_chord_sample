import 'package:flutter/material.dart';

class TuningRegister extends StatelessWidget {
  const TuningRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tuning Register'),
      content: const Text('This is TuningRegister dialog'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
