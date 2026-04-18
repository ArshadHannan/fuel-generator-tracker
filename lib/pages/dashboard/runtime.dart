import 'package:flutter/material.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import '../../components/dialogs/app_success_dialog.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';

class RuntimePage extends StatefulWidget {
  const RuntimePage({super.key});

  @override
  State<RuntimePage> createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {
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

        const AppInputField(
            label: 'Number of Hours',
            suffixText: "Hrs",
        ),
        const SizedBox(height: 50),

        DefaultButton(
          text: "Save Runtime Details",
          size: ButtonSize.lg,
          onPressed: () {
            showAppConfirmDialog(
              context: context,
              title: "Are you sure?",
              confirmText: "Save",
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