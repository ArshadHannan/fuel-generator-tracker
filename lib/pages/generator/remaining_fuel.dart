import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

double sumField(QuerySnapshot<Object?>? snapshot, String field) {
  final docs = snapshot?.docs ?? [];
  return docs.fold<double>(0, (acc, doc) {
    final data = doc.data() as Map<String, dynamic>;
    return acc + ((data[field] as num?)?.toDouble() ?? 0);
  });
}

double calculateRemaining({
  required double capacity,
  required double usageRate,
  required double totalHours,
  required double totalAdded,
}) {
  final used = usageRate * totalHours;
  return (capacity - used + totalAdded)
      .clamp(0, capacity <= 0 ? 0 : capacity)
      .toDouble();
}

class RemainingFuel extends StatelessWidget {
  final String generatorId;
  final double capacity;
  final double usageRate;
  final Widget Function(BuildContext context, double remaining) builder;

  const RemainingFuel({
    super.key,
    required this.generatorId,
    required this.capacity,
    required this.usageRate,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
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

            return builder(context, remaining);
          },
        );
      },
    );
  }
}
