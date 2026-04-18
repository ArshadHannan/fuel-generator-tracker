import 'package:flutter/material.dart';
import '../../colors.dart';
import '../default_button.dart';

enum DialogVariant { primary, warning }

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final DialogVariant variant;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = "Cancel",
    this.variant = DialogVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 Variant handling
    final bool isWarning = variant == DialogVariant.warning;

    final Color accentColor =
    isWarning ? AppColors.dangerText : AppColors.primary;

    final ButtonVariant buttonVariant =
    isWarning ? ButtonVariant.danger : ButtonVariant.primary;

    final IconData icon =
    isWarning ? Icons.warning_amber_rounded : Icons.question_mark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2),
              ),
              child: Icon(
                icon,
                color: accentColor,
                size: 24,
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // 🔹 Buttons
            Row(
              children: [
                Expanded(
                  child: DefaultButton(
                    text: cancelText,
                    size: ButtonSize.md,
                    variant: ButtonVariant.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DefaultButton(
                    text: confirmText,
                    size: ButtonSize.md,
                    variant: buttonVariant, // 🔥 dynamic
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Helper updated
void showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String confirmText,
  required VoidCallback onConfirm,
  DialogVariant variant = DialogVariant.primary,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AppConfirmDialog(
      title: title,
      confirmText: confirmText,
      onConfirm: onConfirm,
      variant: variant,
    ),
  );
}