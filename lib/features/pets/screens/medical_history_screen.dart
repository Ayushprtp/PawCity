import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const records = [
      ('Rabies Vaccine', 'Completed · Feb 14, 2026'),
      ('General Checkup', 'Healthy · Jan 22, 2026'),
      ('Deworming', 'Completed · Dec 02, 2025'),
    ];

    return PawScaffold(
      title: 'Medical History',
      currentNavIndex: 4,
      showBottomNav: false,
      body: ListView.separated(
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final record = records[index];
          return PawAsymCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.$1, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.xs),
                Text(record.$2),
              ],
            ),
          );
        },
      ),
    );
  }
}