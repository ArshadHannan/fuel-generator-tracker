import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';
import '../../components/dialogs/app_confirm_dialog.dart';

class AddGeneratorPage extends StatefulWidget {
  const AddGeneratorPage({super.key});

  @override
  State<AddGeneratorPage> createState() => _AddGeneratorPageState();
}

class _AddGeneratorPageState extends State<AddGeneratorPage> {
  DateTime? selectedDate;
  String? selectedLocation;

  final modelNumberController = TextEditingController();
  final tankCapacityController = TextEditingController();
  final fuelUsageController = TextEditingController();

  bool saving = false;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    modelNumberController.addListener(_onFieldEdited);
    tankCapacityController.addListener(_onFieldEdited);
    fuelUsageController.addListener(_onFieldEdited);
  }

  @override
  void dispose() {
    modelNumberController.dispose();
    tankCapacityController.dispose();
    fuelUsageController.dispose();
    super.dispose();
  }

  void _onFieldEdited() {
    if (submitted) setState(() {});
  }

  String? get _dateError =>
      submitted && selectedDate == null ? "Created date is required" : null;

  String? get _modelError => submitted && modelNumberController.text.trim().isEmpty
      ? "Model number is required"
      : null;

  String? get _locationError =>
      submitted && selectedLocation == null ? "Location is required" : null;

  String? get _tankCapacityError => submitted &&
          double.tryParse(tankCapacityController.text.trim()) == null
      ? "Enter a valid tank capacity"
      : null;

  String? get _fuelUsageError => submitted &&
          double.tryParse(fuelUsageController.text.trim()) == null
      ? "Enter a valid fuel usage"
      : null;

  bool _validate() {
    return _dateError == null &&
        _modelError == null &&
        _locationError == null &&
        _tankCapacityError == null &&
        _fuelUsageError == null;
  }

  void _onSavePressed() {
    if (saving) return;
    setState(() => submitted = true);
    if (!_validate()) return;
    showAppConfirmDialog(
      context: context,
      title: "Are you sure?",
      confirmText: "Save",
      onConfirm: _saveGenerator,
    );
  }

  Future<void> _saveGenerator() async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('generators').add({
        'createdDate': selectedDate != null
            ? Timestamp.fromDate(selectedDate!)
            : null,
        'name': modelNumberController.text.trim(),
        'location': selectedLocation,
        'fuelCapacity': double.tryParse(tankCapacityController.text.trim()),
        'fuelUsage': double.tryParse(fuelUsageController.text.trim()),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save generator")),
        );
        setState(() => saving = false);
      }
    }
  }

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
                errorText: _dateError,
                onChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              const SizedBox(height: 25),

              // Model Number
              AppInputField(
                label: "Model Number",
                controller: modelNumberController,
                errorText: _modelError,
              ),

              const SizedBox(height: 25),

              // Location Dropdown
              AppDropdown(
                label: "Location",
                value: selectedLocation,
                errorText: _locationError,
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
              AppInputField(
                label: "Tank Capacity",
                suffixText: "Liters",
                keyboardType: TextInputType.number,
                controller: tankCapacityController,
                errorText: _tankCapacityError,
              ),

              const SizedBox(height: 25),

              // Fuel Usage
              AppInputField(
                label: "Fuel Usage",
                suffixText: "Liters/hr",
                keyboardType: TextInputType.number,
                controller: fuelUsageController,
                errorText: _fuelUsageError,
              ),

              const SizedBox(height: 50),

              // Save Button
              DefaultButton(
                text: saving ? "Saving..." : "Save Generator",
                size: ButtonSize.lg,
                onPressed: _onSavePressed,
              )


            ],
          ),
        ),
      ),
    );
  }
}