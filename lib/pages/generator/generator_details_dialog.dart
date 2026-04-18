import 'package:flutter/material.dart';
import '../../colors.dart';

class GeneratorDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> gen;

  const GeneratorDetailsDialog({
    super.key,
    required this.gen,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryFg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/generator.png',
              width: 40,
              height: 40,
              color: AppColors.primary,
            ),

            const SizedBox(height: 16),

            //Title
            Text(
              gen["name"],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 16),

            // Info rows
            _infoRow("Location", gen["location"]),
            _infoRow("Remaining", gen["remaining"]),
            const SizedBox(height: 16),

            const Text(
              "Generator details loaded successfully",
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

void showGeneratorDetails(BuildContext context, Map<String, dynamic> gen) {
  showDialog(
    context: context,
    builder: (_) => GeneratorDetailsDialog(gen: gen),
  );
}