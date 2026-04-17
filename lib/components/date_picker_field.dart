import 'package:flutter/material.dart';
import '../colors.dart';

class AppDatePickerField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime) onChanged;

  const AppDatePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;

    if (value == null) {
      displayText = "Select $label";
    } else {
      displayText = "${value!.day}/${value!.month}/${value!.year}";
    }

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

        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );

            if (picked != null) {
              onChanged(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondaryFg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  displayText,
                  style: TextStyle(
                    color: value == null
                        ? AppColors.textMuted
                        : AppColors.text,
                    fontSize: 15,
                  ),
                ),


                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}