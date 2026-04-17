import 'package:flutter/material.dart';
import '../colors.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String? hint;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        // Input
        TextField(
          style: const TextStyle(color: AppColors.text),
          decoration: InputDecoration(
            hintText: hint ?? "Enter $label",
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),

            filled: true,
            fillColor: AppColors.secondaryFg,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}