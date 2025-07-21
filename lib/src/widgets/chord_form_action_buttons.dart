import 'package:flutter/material.dart';

class ChordFormActionButtons extends StatelessWidget {
  final VoidCallback onSubmit;
  final String submitButtonText;
  final bool isEnabled;

  const ChordFormActionButtons({
    super.key,
    required this.onSubmit,
    required this.submitButtonText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onSubmit : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(submitButtonText),
      ),
    );
  }
}
