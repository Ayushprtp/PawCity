import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/providers/review_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class VeterinarianProfileScreen extends ConsumerWidget {
  const VeterinarianProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo data — would normally come from router extra or provider
    return PawScaffold(
      title: 'Veterinarian',
      showBottomNav: false,
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Hero Card
        Container(
          width: double.infinity, padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(gradient: AppGradients.dashboardHero, borderRadius: AppEffects.asymCardRadius, boxShadow: AppEffects.softShadow),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 32, backgroundColor: Colors.white24, child: Icon(Icons.local_hospital_rounded, size: 32, color: Colors.white)),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PawCare Vet Clinic', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSizes.xs),
                Text('Veterinary Clinic', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ])),
            ]),
            const SizedBox(height: AppSizes.lg),
            Row(children: [
              _heroBadge(context, Icons.star_rounded, '4.8', AppColors.amber),
              const SizedBox(width: AppSizes.md),
              _heroBadge(context, Icons.reviews_rounded, '120+ reviews', Colors.white38),
              const SizedBox(width: AppSizes.md),
              _heroBadge(context, Icons.verified_rounded, 'Verified', AppColors.severityLow),
            ]),
          ]),
        ),
        const SizedBox(height: AppSizes.sectionGap),

        // Info Cards
        Text('Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        PawAsymCard(child: Column(children: [
          _infoRow(context, Icons.location_on_rounded, 'Address', '123 Pet Street, Mumbai'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.access_time_rounded, 'Hours', 'Mon-Sat: 9AM - 8PM'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.phone_rounded, 'Phone', '+91 9876543210'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.pets_rounded, 'Pet Policy', 'All pets welcome'),
        ])),
        const SizedBox(height: AppSizes.sectionGap),

        // Services
        Text('Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        Wrap(spacing: AppSizes.sm, runSpacing: AppSizes.sm, children: ['General Checkup', 'Vaccination', 'Surgery', 'Dental Care', 'Emergency', 'Lab Tests'].map((s) =>
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
            decoration: BoxDecoration(color: AppColors.secondaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
            child: Text(s, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ),
        ).toList()),
        const SizedBox(height: AppSizes.sectionGap),

        // Book button
        PawGradientButton(label: 'Book Appointment', onPressed: () => context.go('/vet-booking')),
        const SizedBox(height: AppSizes.md),
        OutlinedButton.icon(
          onPressed: () => context.go('/write-review'),
          icon: const Icon(Icons.rate_review_rounded),
          label: const Text('Write a Review'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        ),
        const SizedBox(height: AppSizes.xxl),
      ])),
    );
  }

  Widget _heroBadge(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: AppSizes.xs), Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600))]),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.secondary),
      const SizedBox(width: AppSizes.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ])),
    ]);
  }
}