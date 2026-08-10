import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../colors.dart';
import '../../components/default_button.dart';

class _ReportRow {
  final DateTime date;
  final double hours;
  final double fuelUsage;
  final double balance;

  _ReportRow({
    required this.date,
    required this.hours,
    required this.fuelUsage,
    required this.balance,
  });
}

DateTime _atMidnight(DateTime d) => DateTime(d.year, d.month, d.day);

String _fmtDate(DateTime d) =>
    "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

class ReportPage extends StatelessWidget {
  final String generatorId;
  final String generatorName;
  final double capacity;
  final double usageRate;

  const ReportPage({
    super.key,
    required this.generatorId,
    required this.generatorName,
    required this.capacity,
    required this.usageRate,
  });

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

              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  const Text(
                    'Report',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(
                child: SingleChildScrollView(
                  child: _buildReport(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('runtime_logs')
          .where('generatorId', isEqualTo: generatorId)
          .snapshots(),
      builder: (context, runtimeSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('fuel_logs')
              .where('generatorId', isEqualTo: generatorId)
              .snapshots(),
          builder: (context, fuelSnap) {
            if (!runtimeSnap.hasData || !fuelSnap.hasData) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final byDate = <DateTime, Map<String, double>>{};

            for (final doc in runtimeSnap.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final date = _atMidnight((data['date'] as Timestamp).toDate());
              final hours = (data['hours'] as num?)?.toDouble() ?? 0;
              final entry =
                  byDate.putIfAbsent(date, () => {'hours': 0, 'liters': 0});
              entry['hours'] = (entry['hours'] ?? 0) + hours;
            }

            for (final doc in fuelSnap.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final date = _atMidnight((data['date'] as Timestamp).toDate());
              final liters = (data['liters'] as num?)?.toDouble() ?? 0;
              final entry =
                  byDate.putIfAbsent(date, () => {'hours': 0, 'liters': 0});
              entry['liters'] = (entry['liters'] ?? 0) + liters;
            }

            final sortedDates = byDate.keys.toList()..sort();

            var runningBalance = capacity;
            final rows = <_ReportRow>[];
            double totalHours = 0;
            double totalLitersAdded = 0;

            for (final date in sortedDates) {
              final hours = byDate[date]!['hours'] ?? 0;
              final liters = byDate[date]!['liters'] ?? 0;
              final fuelUsedThatDay = hours * usageRate;

              runningBalance = (runningBalance - fuelUsedThatDay + liters)
                  .clamp(0, capacity <= 0 ? 0 : capacity)
                  .toDouble();

              rows.add(_ReportRow(
                date: date,
                hours: hours,
                fuelUsage: fuelUsedThatDay,
                balance: runningBalance,
              ));

              totalHours += hours;
              totalLitersAdded += liters;
            }

            final actualRate =
                totalHours > 0 ? totalLitersAdded / totalHours : null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(actualRate),
                const SizedBox(height: 16),
                DefaultButton(
                  text: "Download PDF",
                  variant: ButtonVariant.secondary,
                  onPressed: () => _downloadPdf(rows, actualRate),
                ),
                const SizedBox(height: 20),
                if (rows.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No activity logged yet",
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  _buildTable(rows),
                const SizedBox(height: 25),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _downloadPdf(List<_ReportRow> rows, double? actualRate) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Generator $generatorName",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              "Fuel usage (estimated): ${usageRate.toStringAsFixed(1)} liters per 1 hr",
            ),
            pw.Text(
              "Fuel usage (actual): ${actualRate != null ? '${actualRate.toStringAsFixed(1)} liters per 1 hr' : 'N/A'}",
            ),
            pw.Text("Fuel capacity: ${capacity.toStringAsFixed(0)} liters"),
            pw.SizedBox(height: 16),
            if (rows.isEmpty)
              pw.Text("No activity logged yet")
            else
              pw.TableHelper.fromTextArray(
                headers: [
                  'Date',
                  'Run time (hr)',
                  'Fuel usage (l)',
                  'Fuel balance (l)',
                ],
                data: rows
                    .map((row) => [
                          _fmtDate(row.date),
                          row.hours.toStringAsFixed(1),
                          row.fuelUsage.toStringAsFixed(1),
                          row.balance.toStringAsFixed(1),
                        ])
                    .toList(),
              ),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'report_$generatorName.pdf',
    );
  }

  Widget _buildHeaderCard(double? actualRate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryFg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Generator $generatorName",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Fuel usage (estimated): ${usageRate.toStringAsFixed(1)} liters per 1 hr",
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            "Fuel usage (actual): ${actualRate != null ? '${actualRate.toStringAsFixed(1)} liters per 1 hr' : 'N/A'}",
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            "Fuel capacity: ${capacity.toStringAsFixed(0)} liters",
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<_ReportRow> rows) {
    TableRow header() => TableRow(
          decoration: BoxDecoration(color: AppColors.secondaryFg),
          children: [
            _cell("Date", isHeader: true),
            _cell("Run time (hr)", isHeader: true),
            _cell("Fuel usage (l)", isHeader: true),
            _cell("Fuel balance (l)", isHeader: true),
          ],
        );

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      border: TableBorder.symmetric(
        inside: BorderSide(color: Colors.black, width: 1),
      ),
      children: [
        header(),
        for (final row in rows)
          TableRow(
            children: [
              _cell(_fmtDate(row.date)),
              _cell(row.hours.toStringAsFixed(1)),
              _cell(row.fuelUsage.toStringAsFixed(1)),
              _cell(row.balance.toStringAsFixed(1)),
            ],
          ),
      ],
    );
  }

  Widget _cell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isHeader ? Colors.white : AppColors.textMuted,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
