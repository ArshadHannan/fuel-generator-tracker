import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/default_button.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import 'remaining_fuel.dart';
import 'report_page.dart';

const _locations = ["Warehouse A", "Site B", "Factory Zone"];

String _numText(dynamic value) {
  if (value == null) return "";
  if (value is num) return value.toStringAsFixed(0);
  return value.toString();
}

class GeneratorUpdatePage extends StatefulWidget {
  final Map<String, dynamic> generator;

  const GeneratorUpdatePage({
    super.key,
    required this.generator,
  });

  @override
  State<GeneratorUpdatePage> createState() =>
      _GeneratorUpdatePageState();
}

class _GeneratorUpdatePageState extends State<GeneratorUpdatePage> {
  late TextEditingController nameController;
  late TextEditingController fuelCapacityController;
  late TextEditingController fuelUsageController;

  String? selectedLocation;

  bool submitted = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.generator["name"]?.toString());

    final currentLocation = widget.generator["location"]?.toString();
    selectedLocation =
        _locations.contains(currentLocation) ? currentLocation : null;

    fuelCapacityController = TextEditingController(
      text: _numText(widget.generator["fuelCapacity"]),
    );

    fuelUsageController = TextEditingController(
      text: _numText(widget.generator["fuelUsage"]),
    );

    for (final c in [
      nameController,
      fuelCapacityController,
      fuelUsageController,
    ]) {
      c.addListener(_onFieldEdited);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    fuelCapacityController.dispose();
    fuelUsageController.dispose();
    super.dispose();
  }

  void _onFieldEdited() {
    if (submitted) setState(() {});
  }

  String? get _nameError =>
      submitted && nameController.text.trim().isEmpty
          ? "Generator name is required"
          : null;

  String? get _locationError =>
      submitted && selectedLocation == null ? "Location is required" : null;

  String? get _fuelCapacityError => submitted &&
          double.tryParse(fuelCapacityController.text.trim()) == null
      ? "Enter a valid fuel capacity"
      : null;

  String? get _fuelUsageError => submitted &&
          double.tryParse(fuelUsageController.text.trim()) == null
      ? "Enter a valid fuel usage"
      : null;

  bool _validate() {
    return _nameError == null &&
        _locationError == null &&
        _fuelCapacityError == null &&
        _fuelUsageError == null;
  }

  void _onUpdatePressed() {
    if (saving) return;
    setState(() => submitted = true);
    if (!_validate()) return;
    showAppConfirmDialog(
      context: context,
      title: "Update generator?",
      confirmText: "Update",
      onConfirm: _updateGenerator,
    );
  }

  Future<void> _updateGenerator() async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance
          .collection('generators')
          .doc(widget.generator['id'] as String)
          .update({
        'name': nameController.text.trim(),
        'location': selectedLocation,
        'fuelCapacity': double.tryParse(fuelCapacityController.text.trim()),
        'fuelUsage': double.tryParse(fuelUsageController.text.trim()),
      });
      if (mounted) Navigator.pop(context, 'updated');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update generator")),
        );
        setState(() => saving = false);
      }
    }
  }

  Future<void> _deleteGenerator() async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance
          .collection('generators')
          .doc(widget.generator['id'] as String)
          .delete();
      if (mounted) Navigator.pop(context, 'deleted');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete generator")),
        );
        setState(() => saving = false);
      }
    }
  }

  Widget _buildRemainingFuelDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Remaining Fuel",
          style: TextStyle(color: AppColors.text, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryFg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: RemainingFuel(
            generatorId: widget.generator['id'] as String,
            capacity: (widget.generator['fuelCapacity'] as num?)?.toDouble() ?? 0,
            usageRate: (widget.generator['fuelUsage'] as num?)?.toDouble() ?? 0,
            builder: (context, remaining) => Text(
              "${remaining.toStringAsFixed(0)} L (calculated)",
              style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
            ),
          ),
        ),
      ],
    );
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
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    widget.generator["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppInputField(
                        label: "Generator Name",
                        controller: nameController,
                        errorText: _nameError,
                      ),

                      const SizedBox(height: 25),

                      AppDropdown(
                        label: "Location",
                        value: selectedLocation,
                        errorText: _locationError,
                        items: _locations,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      _buildRemainingFuelDisplay(),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Fuel Capacity",
                        controller: fuelCapacityController,
                        suffixText: "L ",
                        keyboardType: TextInputType.number,
                        errorText: _fuelCapacityError,
                      ),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Fuel Usage",
                        controller: fuelUsageController,
                        suffixText: "L/hr ",
                        keyboardType: TextInputType.number,
                        errorText: _fuelUsageError,
                      ),

                      const SizedBox(height: 50),

                      Row(
                        children: [
                          Expanded(
                            child: DefaultButton(
                              text: saving ? "Updating..." : "Update",
                              size: ButtonSize.md,
                              onPressed: _onUpdatePressed,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child:
                            DefaultButton(
                              text: saving ? "Deleting..." : "Delete",
                              variant: ButtonVariant.danger,
                              size: ButtonSize.md,
                              onPressed: () {
                                if (saving) return;
                                showAppConfirmDialog(
                                  context: context,
                                  title: "Delete this generator?",
                                  confirmText: "Delete",
                                  variant: DialogVariant.warning,
                                  onConfirm: _deleteGenerator,
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      DefaultButton(
                        text: "Generate Report",
                        variant: ButtonVariant.secondary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportPage(
                                generatorId: widget.generator['id'] as String,
                                generatorName:
                                    widget.generator['name'] as String,
                                capacity: (widget.generator['fuelCapacity']
                                            as num?)
                                        ?.toDouble() ??
                                    0,
                                usageRate: (widget.generator['fuelUsage']
                                            as num?)
                                        ?.toDouble() ??
                                    0,
                              ),
                            ),
                          );
                        },
                      ),


                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}