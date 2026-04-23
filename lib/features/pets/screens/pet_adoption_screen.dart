import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_filter_chip_group.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class PetAdoptionScreen extends StatefulWidget {
  const PetAdoptionScreen({super.key});
  @override
  State<PetAdoptionScreen> createState() => _PetAdoptionScreenState();
}

class _PetAdoptionScreenState extends State<PetAdoptionScreen> {
  String _filter = 'All';

  final _pets = [
    const _AdoptPet('Buddy', 'Golden Retriever', '2 years', 'Male', '🐕', 'Friendly and energetic, loves kids'),
    const _AdoptPet('Whiskers', 'Persian Cat', '1 year', 'Female', '🐈', 'Calm and affectionate indoor cat'),
    const _AdoptPet('Max', 'Labrador', '3 years', 'Male', '🐕', 'Well-trained, great with other pets'),
    const _AdoptPet('Luna', 'Indie', '6 months', 'Female', '🐕', 'Rescued puppy, vaccinated and healthy'),
    const _AdoptPet('Milo', 'Tabby Cat', '4 years', 'Male', '🐈', 'Independent and low maintenance'),
  ];

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Adopt a Pet',
      showBottomNav: false,
      showBackButton: true,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Hero
        Container(
          width: double.infinity, padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(gradient: AppGradients.dashboardHero, borderRadius: AppEffects.asymCardRadius),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Find Your Companion 🐾', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: AppSizes.xs),
            Text('Give a loving home to a pet in need', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: AppSizes.lg),
        PawFilterChipGroup(options: const ['All', 'Dogs', 'Cats', 'Others'], selected: _filter, onSelected: (v) => setState(() => _filter = v)),
        const SizedBox(height: AppSizes.lg),
        Expanded(child: ListView.separated(
          itemCount: _pets.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
          itemBuilder: (_, i) {
            final p = _pets[i];
            return PawAsymCard(
              onTap: () {},
              padding: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  height: 120, width: double.infinity,
                  decoration: const BoxDecoration(gradient: AppGradients.softSurface, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizes.radiusLg), topRight: Radius.circular(AppSizes.radiusXl))),
                  child: Center(child: Text(p.emoji, style: const TextStyle(fontSize: 48))),
                ),
                Padding(padding: const EdgeInsets.all(AppSizes.cardPadding), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(p.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                      decoration: BoxDecoration(color: context.colors.severityLow.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                      child: Text('Available', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.severityLow, fontWeight: FontWeight.w700)),
                    ),
                  ]),
                  const SizedBox(height: AppSizes.xs),
                  Text('${p.breed} · ${p.age} · ${p.gender}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
                  const SizedBox(height: AppSizes.sm),
                  Text(p.desc, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSizes.md),
                  Row(children: [
                    Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.favorite_border_rounded, size: 16), label: const Text('Save'))),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.pets_rounded, size: 16), label: const Text('Adopt'), style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary, foregroundColor: Colors.white))),
                  ]),
                ])),
              ]),
            );
          },
        )),
      ]),
    );
  }
}

class _AdoptPet {
  final String name, breed, age, gender, emoji, desc;
  const _AdoptPet(this.name, this.breed, this.age, this.gender, this.emoji, this.desc);
}