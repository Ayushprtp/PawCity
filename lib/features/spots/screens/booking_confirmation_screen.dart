import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Booking Confirmed',
      currentNavIndex: 3,
      showBottomNav: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(Icons.verified_rounded, size: 72),
              const SizedBox(height: AppSizes.md),
              Text(
                'Appointment Confirmed',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSizes.lg),
              const PawAsymCard(
                child: Column(
                  children: [
                    Text('Dr. Priya Sharma'),
                    SizedBox(height: AppSizes.xs),
                    Text('Tomorrow · 5:30 PM'),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.sectionGap),
              PawGradientButton(
                label: 'Go To My Appointments',
                onPressed: () => context.go('/appointments'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}