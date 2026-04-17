import 'package:flutter/material.dart';
import '../colors.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          dropdownColor: AppColors.secondaryFg,

          menuMaxHeight: 250,

          hint: Text(
            'Select $label',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),

          style: const TextStyle(color: AppColors.text),

          decoration: InputDecoration(
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

          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textMuted,
          ),

          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }
}