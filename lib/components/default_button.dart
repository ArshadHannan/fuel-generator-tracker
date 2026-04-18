import 'package:flutter/material.dart';
import '../colors.dart';

enum ButtonVariant { primary, secondary }

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final double height;
  final bool fullWidth;

  const DefaultButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.height = 38,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == ButtonVariant.primary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
          isPrimary ? AppColors.primary : AppColors.secondaryFg,
          foregroundColor:
          isPrimary ? Colors.black : AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPrimary ? Colors.black : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}