import 'package:flutter/material.dart';
import '../colors.dart';

class AppInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? suffixText;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const AppInputField({
    super.key,
    required this.label,
    this.hint,
    this.suffixText,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 15,
          ),
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

            suffixIcon: suffixIcon != null
                ? Icon(
              suffixIcon,
              color: AppColors.textMuted,
              size: 18,
            )
                : (suffixText != null
                ? Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                widthFactor: 1,
                child: Text(
                  suffixText!,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),
            )
                : null),

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