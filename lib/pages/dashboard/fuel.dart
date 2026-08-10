import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../components/dialogs/app_confirm_dialog.dart';
import '../../components/dialogs/app_success_dialog.dart';
import '../../components/default_button.dart';
import '../../components/input_field.dart';
import '../../components/select_dropdown.dart';
import '../../components/date_picker_field.dart';
import '../generator/remaining_fuel.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
  String? selectedGeneratorName;
  DateTime? selectedDate;
  final litersController = TextEditingController();
  final priceController = TextEditingController();

  bool submitted = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    litersController.addListener(_onFieldEdited);
    priceController.addListener(_onFieldEdited);
    _loadLastPrice();
  }

  @override
  void dispose() {
    litersController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> _loadLastPrice() async {
    final snap = await FirebaseFirestore.instance
        .collection('fuel_logs')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (!mounted || snap.docs.isEmpty) return;
    final lastPrice = (snap.docs.first.data()['pricePerLiter'] as num?)
        ?.toDouble();
    if (lastPrice != null && priceController.text.isEmpty) {
      priceController.text = lastPrice.toStringAsFixed(2);
    }
  }

  void _onFieldEdited() {
    if (submitted) setState(() {});
  }

  String? get _generatorError => submitted && selectedGeneratorName == null
      ? "Select a generator"
      : null;

  String? get _dateError =>
      submitted && selectedDate == null ? "Date is required" : null;

  String? _litersError(double? remaining, double capacity) {
    if (!submitted) return null;
    final liters = double.tryParse(litersController.text.trim());
    if (liters == null || liters <= 0) return "Enter a valid number of liters";
    if (remaining != null && capacity > 0) {
      final spaceLeft = capacity - remaining;
      if (liters > spaceLeft) {
        return "Exceeds tank capacity (only ${spaceLeft.toStringAsFixed(1)} L of space left)";
      }
    }
    return null;
  }

  String? get _priceError =>
      submitted && double.tryParse(priceController.text.trim()) == null
          ? "Enter a valid price"
          : null;

  bool _validate(double? remaining, double capacity) {
    return _generatorError == null &&
        _dateError == null &&
        _litersError(remaining, capacity) == null &&
        _priceError == null;
  }

  void _onSavePressed(
    String generatorId,
    double? remaining,
    double capacity,
  ) {
    if (saving) return;
    setState(() => submitted = true);
    if (!_validate(remaining, capacity)) return;
    showAppConfirmDialog(
      context: context,
      title: "Are you sure?",
      confirmText: "Save",
      onConfirm: () => _saveFuel(generatorId),
    );
  }

  Future<void> _saveFuel(String generatorId) async {
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('fuel_logs').add({
        'generatorId': generatorId,
        'generatorName': selectedGeneratorName,
        'date': Timestamp.fromDate(selectedDate!),
        'liters': double.tryParse(litersController.text.trim()),
        'pricePerLiter': double.tryParse(priceController.text.trim()),
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      litersController.clear();
      priceController.clear();
      setState(() {
        selectedGeneratorName = null;
        selectedDate = null;
        submitted = false;
      });
      showSuccessDialog(context, "Saved successfully");
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save fuel details")),
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
            capacity: 0,
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
                  capacity: capacity,
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
    required double capacity,
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
          label: 'Number of Liters',
          suffixText: "L",
          keyboardType: TextInputType.number,
          controller: litersController,
          errorText: _litersError(remaining, capacity),
        ),
        const SizedBox(height: 25),

        AppInputField(
          label: 'Price per Liter',
          suffixText: "\$",
          keyboardType: TextInputType.number,
          controller: priceController,
          errorText: _priceError,
        ),
        const SizedBox(height: 50),

        DefaultButton(
          text: saving ? "Saving..." : "Save Fuel Details",
          size: ButtonSize.lg,
          onPressed: () =>
              _onSavePressed(generatorId, remaining, capacity),
        )
      ],
    );
  }
}
