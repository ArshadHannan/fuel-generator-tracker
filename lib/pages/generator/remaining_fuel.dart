import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

double _sumField(QuerySnapshot<Object?>? snapshot, String field) {
  final docs = snapshot?.docs ?? [];
  return docs.fold<double>(0, (acc, doc) {
    final data = doc.data() as Map<String, dynamic>;
    return acc + ((data[field] as num?)?.toDouble() ?? 0);
  });
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
        final totalHours = _sumField(runtimeSnapshot.data, 'hours');

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('fuel_logs')
              .where('generatorId', isEqualTo: generatorId)
              .snapshots(),
          builder: (context, fuelSnapshot) {
            final totalAdded = _sumField(fuelSnapshot.data, 'liters');

            final used = usageRate * totalHours;
            final remaining = (capacity - used + totalAdded)
                .clamp(0, capacity <= 0 ? 0 : capacity)
                .toDouble();

            return builder(context, remaining);
          },
        );
      },
    );
  }
}
