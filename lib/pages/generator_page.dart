import 'package:flutter/material.dart';
import '../colors.dart';

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0), // ✅ same
        child: Column(
          children: [
            const SizedBox(height: 25), // ✅ same top spacing

            // Title
            const Text(
              'Generators',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25), // ✅ same spacing rhythm

            // 🔽 Your generator content here
            Expanded(
              child: Center(
                child: Text(
                  'Generator List / Content',
                  style: TextStyle(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}