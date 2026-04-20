import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class PetProfileScreen extends ConsumerWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(userPetsProvider);
    return PawScaffold(
      title: 'My Pets',
      currentNavIndex: 4,
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.go('/add-pet'))],
      body: petsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load pets')),
        data: (pets) {
          if (pets.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(padding: const EdgeInsets.all(AppSizes.xxl), decoration: BoxDecoration(gradient: AppGradients.softSurface, shape: BoxShape.circle), child: const Icon(Icons.pets_rounded, size: 56, color: AppColors.primary)),
              const SizedBox(height: AppSizes.lg),
              Text('No pets yet', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sm),
              Text('Add your first furry friend!', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: AppSizes.sectionGap),
              PawGradientButton(label: 'Add Pet', onPressed: () => context.go('/add-pet')),
            ]));
          }
          return ListView.separated(
            itemCount: pets.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.lg),
            itemBuilder: (_, i) {
              final pet = pets[i];
              return PawAsymCard(
                onTap: () => context.go('/medical-history?petId=${pet.id}'),
                padding: EdgeInsets.zero,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Hero image
                  Container(
                    height: 160, width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: AppGradients.dashboardHero,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.radiusLg), topRight: Radius.circular(AppSizes.radiusXl)),
                    ),
                    child: pet.photoUrl != null
                        ? ClipRRect(borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.radiusLg), topRight: Radius.circular(AppSizes.radiusXl)), child: Image.network(pet.photoUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Center(child: Text(pet.type.emoji, style: const TextStyle(fontSize: 56)))))
                        : Center(child: Text(pet.type.emoji, style: const TextStyle(fontSize: 56))),
                  ),
                  Padding(padding: const EdgeInsets.all(AppSizes.cardPadding), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(pet.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs), decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppSizes.radiusFull)), child: Text(pet.type.label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))),
                    ]),
                    const SizedBox(height: AppSizes.sm),
                    // Info chips row
                    Wrap(spacing: AppSizes.sm, runSpacing: AppSizes.sm, children: [
                      if (pet.breed != null) _infoChip(context, Icons.category_rounded, pet.breed!),
                      if (pet.gender != null) _infoChip(context, Icons.male_rounded, pet.gender!),
                      if (pet.weightKg != null) _infoChip(context, Icons.monitor_weight_rounded, '${pet.weightKg} kg'),
                      if (pet.color != null) _infoChip(context, Icons.palette_rounded, pet.color!),
                      if (pet.microchipId != null) _infoChip(context, Icons.qr_code_rounded, 'Chipped'),
                    ]),
                    const SizedBox(height: AppSizes.md),
                    // Quick actions
                    Row(children: [
                      _actionBtn(context, Icons.medical_services_rounded, 'Health', AppColors.vet, () => context.go('/medical-history?petId=${pet.id}')),
                      const SizedBox(width: AppSizes.sm),
                      _actionBtn(context, Icons.edit_rounded, 'Edit', AppColors.secondary, () {}),
                      const SizedBox(width: AppSizes.sm),
                      _actionBtn(context, Icons.qr_code_rounded, 'QR', AppColors.tertiary, () {}),
                    ]),
                  ])),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: AppColors.onSurfaceVariant), const SizedBox(width: AppSizes.xs), Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant))]),
    );
  }

  Widget _actionBtn(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(AppSizes.radiusMd), child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        child: Column(children: [Icon(icon, size: 20, color: color), const SizedBox(height: AppSizes.xs), Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600))]),
      )),
    );
  }
}