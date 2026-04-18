import 'package:flutter/material.dart';
import '../colors.dart';

class AppSearchInput extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;

  const AppSearchInput({
    super.key,
    this.hint,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint ?? "Search",
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

        //Icon on right
        suffixIcon: const Icon(
          Icons.search,
          color: AppColors.textMuted,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}