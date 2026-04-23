import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class ServicesGroomingScreen extends StatelessWidget {
  const ServicesGroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      _Svc('Full Grooming', 'Bath, haircut, nail trim, ear cleaning', Icons.content_cut_rounded, 1200, context.colors.grooming),
      _Svc('Bath & Dry', 'Shampoo, conditioner, blow dry', Icons.water_drop_rounded, 600, context.colors.vet),
      _Svc('Nail Trimming', 'Professional nail clipping & filing', Icons.carpenter_rounded, 300, context.colors.tertiary),
      _Svc('Dental Care', 'Teeth brushing & breath freshener', Icons.sentiment_satisfied_rounded, 500, context.colors.severityLow),
      _Svc('De-shedding', 'Undercoat removal treatment', Icons.air_rounded, 800, context.colors.amber),
      _Svc('Spa Package', 'Premium pamper with massage & aromatherapy', Icons.spa_rounded, 2000, context.colors.primary),
    ];

    return PawScaffold(
      title: 'Services & Grooming',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Hero banner
        Container(
          width: double.infinity, padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(gradient: AppGradients.warmAccent, borderRadius: AppEffects.asymCardRadius),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Pamper Your Pet ✨', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSizes.xs),
            Text('Professional grooming services at your doorstep', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurface.withValues(alpha: 0.7))),
          ]),
        ),
        const SizedBox(height: AppSizes.sectionGap),
        Text('Available Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        ...services.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.md),
          child: PawAsymCard(
            onTap: () => context.push('/vet-booking'),
            child: Row(children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(color: s.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                child: Icon(s.icon, color: s.color, size: 24),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSizes.xxs),
                Text(s.desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
              ])),
              Column(children: [
                Text('₹${s.price}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: context.colors.primary)),
                const SizedBox(height: AppSizes.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                  decoration: BoxDecoration(color: context.colors.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                  child: Text('Book', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.primary, fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          ),
        )),
        const SizedBox(height: AppSizes.xxl),
      ])),
    );
  }
}

class _Svc {
  final String name, desc;
  final IconData icon;
  final int price;
  final Color color;
  const _Svc(this.name, this.desc, this.icon, this.price, this.color);
}