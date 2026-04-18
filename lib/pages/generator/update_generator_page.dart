import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../components/input_field.dart';
import '../../components/default_button.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import '../../components/dialogs/app_success_dialog.dart';

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
  late TextEditingController locationController;
  late TextEditingController remainingController;
  late TextEditingController fuelCapacityController;
  late TextEditingController fuelUsageController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.generator["name"]);

    locationController =
        TextEditingController(text: widget.generator["location"]);

    remainingController =
        TextEditingController(text: widget.generator["remaining"]);

    fuelCapacityController = TextEditingController(
      text: widget.generator["fuelCapacity"]?.toString() ?? "",
    );

    fuelUsageController = TextEditingController(
      text: widget.generator["fuelUsage"]?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    remainingController.dispose();
    fuelCapacityController.dispose();
    fuelUsageController.dispose();
    super.dispose();
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

              // 🔹 Header
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
                      ),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Location",
                        controller: locationController,
                      ),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Remaining Fuel",
                        controller: remainingController,
                        suffixText: "L ",
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Fuel Capacity",
                        controller: fuelCapacityController,
                        suffixText: "L ",
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 25),

                      AppInputField(
                        label: "Fuel Usage",
                        controller: fuelUsageController,
                        suffixText: "L/hr ",
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 50),

                      Row(
                        children: [
                          Expanded(
                            child: DefaultButton(
                              text: "Update",
                              size: ButtonSize.md,
                              onPressed: () {
                                showAppConfirmDialog(
                                  context: context,
                                  title: "Update generator?",
                                  confirmText: "Update",
                                  onConfirm: () {
                                    showSuccessDialog(
                                        context, "Updated successfully");
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child:
                            DefaultButton(
                              text: "Delete",
                              variant: ButtonVariant.danger,
                              size: ButtonSize.md,
                              onPressed: () {
                                showAppConfirmDialog(
                                  context: context,
                                  title: "Delete this generator?",
                                  confirmText: "Delete",
                                  variant: DialogVariant.warning,
                                  onConfirm: () {
                                    showSuccessDialog(
                                        context, "Deleted successfully");

                                    Future.delayed(
                                        const Duration(seconds: 2), () {
                                      if (mounted) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
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
                          showSuccessDialog(
                              context, "Report generated");
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