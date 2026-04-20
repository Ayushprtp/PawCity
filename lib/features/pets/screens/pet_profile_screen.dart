import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Pet Profile',
      currentNavIndex: 4,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Luna · Golden Retriever',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  const Text('2 years · 28 kg · Active'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Health Summary', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSizes.sm),
                  const Text('Vaccinations up to date · Next checkup in 18 days'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            PawGradientButton(
              label: 'Open Medical History',
              onPressed: () => context.go('/medical-history'),
            ),
          ],
        ),
      ),
    );
  }
}