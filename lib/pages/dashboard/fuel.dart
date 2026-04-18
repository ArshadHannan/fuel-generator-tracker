import 'package:flutter/material.dart';
import '../../components/app_confirm_dialog.dart';
import '../../components/app_success_dialog.dart';
import '../../components/input_field.dart';
import '../../components/full_width_button.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
  String? selectedType;
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppDropdown(
          label: "Generator",
          value: selectedType,
          items: const [
            "FG P200-3",
            "CAT-1000",
            "PER-25L",
            "CAT-8KS1",
            "FGL P446",
            "KL 4RxT",
            "GTR 4493"
          ],
          onChanged: (value) {
            setState(() {
              selectedType = value;
            });
          },
        ),
        const SizedBox(height: 25),

        AppDatePickerField(
          label: "Date",
          value: selectedDate,
          onChanged: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 25),

        const AppInputField(label: 'Number of Liters'),
        const SizedBox(height: 25),

        const AppInputField(label: 'Number of Liters'),
        const SizedBox(height: 50),

        FullWidthButton(
          text: "Save Fuel Details",
          onPressed: () {
            showAppConfirmDialog(
              context: context,
              title: "Are you sure?",
              onConfirm: () {
                // Save logic here

                showSuccessDialog(context, "Saved successfully");
              },
            );
          },
        )
      ],
    );
  }
}