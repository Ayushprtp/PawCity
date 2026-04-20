import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class VeterinarianProfileScreen extends StatelessWidget {
  const VeterinarianProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Veterinarian Profile',
      currentNavIndex: 3,
      showBottomNav: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Priya Sharma', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSizes.xs),
                  const Text('Small Animal Specialist · 10 years experience'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            PawAsymCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Clinic Hours', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSizes.xs),
                  const Text('Mon-Sat · 9:00 AM to 8:00 PM'),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sectionGap),
            PawGradientButton(
              label: 'Confirm Booking',
              onPressed: () => context.go('/booking-confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}