import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import '../../components/dialogs/app_success_dialog.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';
import '../generator/remaining_fuel.dart';

class RuntimePage extends StatefulWidget {
  const RuntimePage({super.key});

  @override
  State<RuntimePage> createState() => _RuntimePageState();
}

class _RuntimePageState extends State<RuntimePage> {
  String? selectedGeneratorName;
  DateTime? selectedDate;
  final hoursController = TextEditingController();

  bool submitted = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    hoursController.addListener(_onFieldEdited);
  }

  @override
  void dispose() {
    hoursController.dispose();
    super.dispose();
  }

  void _onFieldEdited() {
    if (submitted) setState(() {});
  }

  String? get _generatorError => submitted && selectedGeneratorName == null
      ? "Select a generator"
      : null;

  String? get _dateError =>
      submitted && selectedDate == null ? "Date is required" : null;

  String? _hoursError(double? remaining, double usageRate) {
    if (!submitted) return null;
    final hours = double.tryParse(hoursController.text.trim());
    if (hours == null) return "Enter a valid number of hours";
    if (remaining != null && usageRate > 0) {
      final fuelNeeded = hours * usageRate;
      if (fuelNeeded > remaining) {
        return "Not enough fuel remaining (${remaining.toStringAsFixed(1)} L left)";
      }
    }
    return null;
  }

  bool _validate(double? remaining, double usageRate) {
    return _generatorError == null &&
        _dateError == null &&
        _hoursError(remaining, usageRate) == null;
  }

  void _onSavePressed(
    String generatorId,
    double? remaining,
    double usageRate,
  ) {
    if (saving) return;
    setState(() => submitted = true);
    if (!_validate(remaining, usageRate)) return;
    showAppConfirmDialog(
      context: context,
      title: "Are you sure?",
      confirmText: "Save",
      onConfirm: () => _saveRuntime(generatorId),
    );
  }

  Future<void> _saveRuntime(String generatorId) async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('runtime_logs').add({
        'generatorId': generatorId,
        'generatorName': selectedGeneratorName,
        'date': Timestamp.fromDate(selectedDate!),
        'hours': double.tryParse(hoursController.text.trim()),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      hoursController.clear();
      setState(() {
        selectedGeneratorName = null;
        selectedDate = null;
        submitted = false;
      });
      showSuccessDialog(context, "Saved successfully");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save runtime details")),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('generators').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];
        final generatorsByName = <String, Map<String, dynamic>>{
          for (final doc in docs)
            if (((doc.data() as Map<String, dynamic>)['name'] as String?)
                    ?.isNotEmpty ??
                false)
              (doc.data() as Map<String, dynamic>)['name'] as String: {
                'id': doc.id,
                'capacity': ((doc.data() as Map<String, dynamic>)['fuelCapacity']
                            as num?)
                        ?.toDouble() ??
                    0,
                'usageRate': ((doc.data() as Map<String, dynamic>)['fuelUsage']
                            as num?)
                        ?.toDouble() ??
                    0,
              },
        };
        final generatorNames = generatorsByName.keys.toList();
        final selected = selectedGeneratorName != null
            ? generatorsByName[selectedGeneratorName]
            : null;

        if (selected == null) {
          return _buildForm(
            generatorNames: generatorNames,
            generatorId: '',
            remaining: null,
            usageRate: 0,
          );
        }

        final generatorId = selected['id'] as String;
        final capacity = selected['capacity'] as double;
        final usageRate = selected['usageRate'] as double;

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('runtime_logs')
              .where('generatorId', isEqualTo: generatorId)
              .snapshots(),
          builder: (context, runtimeSnapshot) {
            final totalHours = sumField(runtimeSnapshot.data, 'hours');

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('fuel_logs')
                  .where('generatorId', isEqualTo: generatorId)
                  .snapshots(),
              builder: (context, fuelSnapshot) {
                final totalAdded = sumField(fuelSnapshot.data, 'liters');
                final remaining = calculateRemaining(
                  capacity: capacity,
                  usageRate: usageRate,
                  totalHours: totalHours,
                  totalAdded: totalAdded,
                );

                return _buildForm(
                  generatorNames: generatorNames,
                  generatorId: generatorId,
                  remaining: remaining,
                  usageRate: usageRate,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildForm({
    required List<String> generatorNames,
    required String generatorId,
    required double? remaining,
    required double usageRate,
  }) {
    return Column(
      children: [
        AppDropdown(
          label: "Generator",
          value: selectedGeneratorName,
          errorText: _generatorError,
          items: generatorNames,
          onChanged: (value) {
            setState(() {
              selectedGeneratorName = value;
            });
          },
        ),
        const SizedBox(height: 25),

        AppDatePickerField(
          label: "Date",
          value: selectedDate,
          errorText: _dateError,
          onChanged: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
        const SizedBox(height: 25),

        AppInputField(
          label: 'Number of Hours',
          suffixText: "Hrs",
          keyboardType: TextInputType.number,
          controller: hoursController,
          errorText: _hoursError(remaining, usageRate),
        ),
        const SizedBox(height: 50),

        DefaultButton(
          text: saving ? "Saving..." : "Save Runtime Details",
          size: ButtonSize.lg,
          onPressed: () =>
              _onSavePressed(generatorId, remaining, usageRate),
        )
      ],
    );
  }
}
