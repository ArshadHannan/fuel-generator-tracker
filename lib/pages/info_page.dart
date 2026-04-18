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

            // Header
            const Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(width: 24),
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

            const SizedBox(height: 10),

            // Scrollable content only
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/info.png',
                        width: 60,
                        height: 60,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Info list
                    _buildInfoGroup(),

                    const SizedBox(height: 20),

                    // Description
                    _buildDescriptionCard(),

                    const SizedBox(height: 25), // prevents cutoff
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoGroup() {
    final items = [
      {
        "icon": "assets/app.png",
        "title": "App Name",
        "value": "Fuel Tracker",
      },
      {
        "icon": "assets/version.png",
        "title": "Version",
        "value": "1.0.23",
      },
      {
        "icon": "assets/build.png",
        "title": "Build Number",
        "value": "2025.03.12.4",
      },
      {
        "icon": "assets/android.png",
        "title": "Platform",
        "value": "Android",
      },
      {
        "icon": "assets/company.png",
        "title": "Developed By",
        "value": "Win Authority",
      },
    ];

    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        final isFirst = index == 0;
        final isLast = index == items.length - 1;

        return Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryFg,
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(12) : Radius.zero,
              bottom: isLast ? const Radius.circular(12) : Radius.zero,
            ),
          ),
          child: Column(
            children: [
              _buildInfoItem(item),

              if (!isLast)
                Container(
                  height: 1,
                  color: Colors.black,
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(
            item["icon"]!,
            width: 24,
            height: 24,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["title"]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item["value"]!,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryFg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "This app helps manage diesel generators by tracking runtime, fuel usage and refuelling data.",
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}