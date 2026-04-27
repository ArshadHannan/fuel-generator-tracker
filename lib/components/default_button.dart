import 'package:flutter/material.dart';
import '../colors.dart';

enum ButtonVariant { primary, secondary, danger }
enum ButtonSize { md, lg }

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  final ButtonVariant variant;
  final ButtonSize size;

  const DefaultButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.lg,
  });
  @override
  Widget build(BuildContext context) {
    final bool isLarge = size == ButtonSize.lg;

    // 🔥 Variant handling
    Color backgroundColor;
    Color textColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = AppColors.primary;
        textColor = Colors.black;
        break;

      case ButtonVariant.secondary:
        backgroundColor = AppColors.secondaryFg;
        textColor = AppColors.textMuted;
        break;

      case ButtonVariant.danger:
        backgroundColor = AppColors.dangerSoft;
        textColor = AppColors.dangerText;
        break;
    }

    return SizedBox(
      width: isLarge ? double.infinity : null,
      height: isLarge ? 48 : 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isLarge ? 16 : 14,
            color: textColor,
          ),
        ),
      ),
    );
  }
}