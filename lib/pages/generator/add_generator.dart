import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import '../../components/dialogs/app_success_dialog.dart';

class AddGeneratorPage extends StatefulWidget {
  const AddGeneratorPage({super.key});

  @override
  State<AddGeneratorPage> createState() => _AddGeneratorPageState();
}

class _AddGeneratorPageState extends State<AddGeneratorPage> {
  DateTime? selectedDate;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              const SizedBox(height: 25),

              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text(
                    'Add Generator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Created Date
              AppDatePickerField(
                label: "Created Date",
                value: selectedDate,
                onChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              const SizedBox(height: 25),

              // Model Number
              const AppInputField(label: "Model Number"),

              const SizedBox(height: 25),

              // Location Dropdown
              AppDropdown(
                label: "Location",
                value: selectedLocation,
                items: const [
                  "Warehouse A",
                  "Site B",
                  "Factory Zone",
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
              ),

              const SizedBox(height: 25),

              // Tank Capacity
              const AppInputField(
                label: "Tank Capacity",
                suffixText: "Liters",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 25),

              // Fuel Usage
              const AppInputField(
                label: "Fuel Usage",
                suffixText: "Liters/hr",
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 50),

              // Save Button
              DefaultButton(
                text: "Save Generator",
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
          ),
        ),
      ),
    );
  }
}