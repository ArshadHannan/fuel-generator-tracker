import 'package:flutter/material.dart';
import '../colors.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 25),

            // 🔥 Same header style (centered title)
            const Stack(
              alignment: Alignment.center,
              children: [
                // 👈 Empty left space to match layout symmetry
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(width: 24), // keeps title centered visually
                ),

                Text(
                  'About App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔽 Future content here
          ],
        ),
      ),
    );
  }
}