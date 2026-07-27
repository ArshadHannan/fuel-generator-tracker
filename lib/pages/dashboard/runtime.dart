import 'package:cloud_firestore/cloud_firestore.dart';
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

  String? get _hoursError =>
      submitted && double.tryParse(hoursController.text.trim()) == null
          ? "Enter a valid number of hours"
          : null;

  bool _validate() {
    return _generatorError == null &&
        _dateError == null &&
        _hoursError == null;
  }

  void _onSavePressed(String generatorId) {
    if (saving) return;
    setState(() => submitted = true);
    if (!_validate()) return;
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
        final generatorNameToId = <String, String>{
          for (final doc in docs)
            (doc.data() as Map<String, dynamic>)['name'] as String? ?? '':
              doc.id,
        };
        final generatorNames = generatorNameToId.keys
            .where((name) => name.isNotEmpty)
            .toList();

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
              errorText: _hoursError,
            ),
            const SizedBox(height: 50),

            DefaultButton(
              text: saving ? "Saving..." : "Save Runtime Details",
              size: ButtonSize.lg,
              onPressed: () => _onSavePressed(
                generatorNameToId[selectedGeneratorName] ?? '',
              ),
            )
          ],
        );
      },
    );
  }
}
