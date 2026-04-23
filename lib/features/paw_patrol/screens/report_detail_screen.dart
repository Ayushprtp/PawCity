import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const updates = [
      ('Submitted', 'Reporter', '12:08 PM'),
      ('Under Review', 'City NGO', '12:40 PM'),
      ('Assigned', 'Rapid Response Team', '1:12 PM'),
    ];

    return PawScaffold(
      title: 'Report Detail',
      currentNavIndex: 1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Injured stray near Central Park',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      PawStatusBadge.severity(context, 'High'),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  const Text('Status timeline'),
                  const SizedBox(height: AppSizes.sm),
                  ...updates.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.sm),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_outline_rounded, size: AppSizes.iconSm),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(child: Text('${entry.$1} · ${entry.$2}')),
                          Text(entry.$3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            PawAsymCard(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Claim This Report'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Update Status'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}