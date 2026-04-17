import 'package:flutter/material.dart';
import '../../colors.dart';
import 'runtime.dart';
import 'fuel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final double totalWidth =
        MediaQuery.of(context).size.width - 80;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 25),

            const Text(
              'Fuel Tracker Generator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),


            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.secondaryFg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [

                  AnimatedAlign(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    alignment: selectedTab == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: totalWidth / 2,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),


                  Row(
                    children: [
                      _buildTab("Runtime", 0),
                      _buildTab("Fuel", 1),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),


            Expanded(
              child: SingleChildScrollView(
                child: selectedTab == 0
                    ? const RuntimePage()
                    : const FuelPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}