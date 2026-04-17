import 'package:flutter/material.dart';
import '../components/input_field.dart';
import '../components/full_width_button.dart';
import '../components/select_dropdown.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Title
            const Text(
              'Fuel Tracker Generator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            // Inputs
            AppDropdown(
              label: "Generator",
              value: selectedType,
              items: const ["FG P200-3", "CAT-1000", "PER-25L","CAT-8KS1", "FGL P446", "KL 4RxT", "GTR 4493"],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
            ),
            const SizedBox(height: 25),

            const AppInputField(label: 'Fuel Capacity'),
            const SizedBox(height: 25),

            const AppInputField(label: 'Number of Hours'),
            const SizedBox(height: 50),

            FullWidthButton(
              text: "Save Runtime Details",
              onPressed: () {
                // TODO: handle save
              },
            ),
          ],
        ),
      ),
    );
  }
}