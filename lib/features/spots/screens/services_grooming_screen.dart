import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ServicesGroomingScreen extends StatelessWidget {
  const ServicesGroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const providers = [
      ('Fluffy Spa Studio', '4.9 · Open today'),
      ('Happy Tail Grooming', '4.8 · 2.1 km away'),
      ('City Pet Care', '4.7 · Home service'),
    ];

    return PawScaffold(
      title: 'Grooming Services',
      currentNavIndex: 3,
      showBottomNav: false,
      body: ListView.separated(
        itemCount: providers.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final provider = providers[index];
          return PawAsymCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.$1, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.xs),
                Text(provider.$2),
              ],
            ),
          );
        },
      ),
    );
  }
}