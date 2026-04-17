import 'package:flutter/material.dart';
import '../../colors.dart';

class GeneratorList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final ScrollController controller;

  const GeneratorList({
    super.key,
    required this.items,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      thickness: 4,
      radius: const Radius.circular(10),
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final gen = items[index];
          return _buildCard(gen);
        },
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> gen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryFg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/generator.png',
            width: 24,
            height: 24,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gen["name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  gen["location"],
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // ✅ Right section (center aligned)
          SizedBox(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  gen["remaining"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                const Text(
                  "Remaining",
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}