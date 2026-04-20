import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/repositories/spots_repository.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_filter_chip_group.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

final _spotsProvider = FutureProvider<List<Spot>>((ref) async {
  return SpotsRepository().fetchSpots();
});

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(_spotsProvider);
    final categories = ['All', ...SpotCategory.values.map((c) => c.label)];

    return PawScaffold(
      title: 'Nearby Places',
      currentNavIndex: 0,
      showBottomNav: false,
      body: Column(children: [
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = _selectedCategory == cat;
              return ChoiceChip(label: Text(cat), selected: selected, onSelected: (_) => setState(() => _selectedCategory = cat));
            },
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Expanded(
          child: spotsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Unable to load places')),
            data: (spots) {
              final filtered = _selectedCategory == 'All'
                  ? spots
                  : spots.where((s) => s.category.label == _selectedCategory).toList();
              if (filtered.isEmpty) {
                return const Center(child: Text('No places found'));
              }
              return ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
                itemBuilder: (_, i) {
                  final spot = filtered[i];
                  return PawAsymCard(
                    onTap: () => context.go('/veterinarian-profile'),
                    child: Row(children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          color: _catColor(spot.category).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        ),
                        child: Center(child: Icon(_catIcon(spot.category), color: _catColor(spot.category), size: 28)),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(spot.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: AppSizes.xxs),
                        Text(spot.category.label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: _catColor(spot.category))),
                        if (spot.address != null) ...[
                          const SizedBox(height: AppSizes.xxs),
                          Text(spot.address!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ])),
                      if (spot.rating > 0) Column(children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.star_rounded, size: 14, color: AppColors.amber),
                          const SizedBox(width: 2),
                          Text(spot.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ]),
                        Text('(${spot.reviewCount})', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline)),
                      ]),
                    ]),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }

  Color _catColor(SpotCategory c) => switch (c) { SpotCategory.restaurant => AppColors.restaurant, SpotCategory.park => AppColors.park, SpotCategory.vet => AppColors.vet, SpotCategory.grooming => AppColors.grooming, SpotCategory.boarding => AppColors.boarding, SpotCategory.petStore => AppColors.petStore, _ => AppColors.secondary };
  IconData _catIcon(SpotCategory c) => switch (c) { SpotCategory.restaurant => Icons.restaurant_rounded, SpotCategory.park => Icons.park_rounded, SpotCategory.vet => Icons.local_hospital_rounded, SpotCategory.grooming => Icons.content_cut_rounded, SpotCategory.boarding => Icons.home_rounded, SpotCategory.petStore => Icons.store_rounded, _ => Icons.place_rounded };
}
