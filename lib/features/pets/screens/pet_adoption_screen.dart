import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class PetAdoptionScreen extends StatelessWidget {
  const PetAdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const pets = [
      ('Buddy', '2 years · Friendly · Vaccinated'),
      ('Mochi', '1 year · Calm · Indoor trained'),
      ('Rex', '3 years · Active · Rescue verified'),
    ];

    return PawScaffold(
      title: 'Pet Adoption',
      currentNavIndex: 4,
      showBottomNav: false,
      body: ListView.separated(
        itemCount: pets.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final pet = pets[index];
          return PawAsymCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pet.$1, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.xs),
                Text(pet.$2),
              ],
            ),
          );
        },
      ),
    );
  }
}