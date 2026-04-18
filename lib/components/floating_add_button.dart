import 'package:flutter/material.dart';
import '../colors.dart';

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onTap;
  final double bottom;
  final double right;

  const AppFloatingButton({
    super.key,
    required this.onTap,
    this.bottom = 20.0,
    this.right = 40,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ CHANGE 2: Added bottomInset to account for Android navigation bar
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: bottom + bottomInset,
      right: right,
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            height: 56,
            width: 56,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}