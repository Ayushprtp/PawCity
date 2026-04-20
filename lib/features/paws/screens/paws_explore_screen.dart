import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/repositories/spots_repository.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

final _bhopaSpotsProvider = FutureProvider<List<Spot>>((ref) async {
  return SpotsRepository().fetchSpots(city: 'Bhopal');
});

class PawsExploreScreen extends ConsumerStatefulWidget {
  const PawsExploreScreen({super.key});
  @override
  ConsumerState<PawsExploreScreen> createState() => _PawsExploreScreenState();
}

class _PawsExploreScreenState extends ConsumerState<PawsExploreScreen>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(_bhopaSpotsProvider);
    final categories = [
      'All',
      'Pet Store',
      'Park',
      'Cafe',
      'Vet',
      'Grooming',
    ];

    return PawScaffold(
      title: 'Paws Explore',
      currentNavIndex: 2,
      actions: [
        IconButton(
          onPressed: () => context.push('/map'),
          icon: const Icon(Icons.map_rounded),
          tooltip: 'Full Map',
        ),
      ],
      body: spotsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded,
                  size: 56, color: AppColors.outlineVariant),
              const SizedBox(height: AppSizes.md),
              Text('Unable to load spots',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.md),
              FilledButton(
                onPressed: () => ref.invalidate(_bhopaSpotsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (spots) {
          final filtered = _selectedCategory == 'All'
              ? spots
              : spots
                  .where((s) => s.category.label == _selectedCategory)
                  .toList();

          return Column(
            children: [
              // Map Preview Card
              _mapPreview(context, spots),
              const SizedBox(height: AppSizes.lg),

              // Category filter chips
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSizes.sm),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final selected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      selectedColor:
                          AppColors.primaryContainer.withValues(alpha: 0.5),
                      onSelected: (_) =>
                          setState(() => _selectedCategory = cat),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // Results header
              Row(
                children: [
                  Text(
                    '${filtered.length} places found',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    'Bhopal',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.location_on_rounded,
                      size: 14, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: AppSizes.md),

              // Spots list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_off_rounded,
                                size: 48, color: AppColors.outlineVariant),
                            const SizedBox(height: AppSizes.md),
                            Text('No spots in this category',
                                style:
                                    Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.md),
                        itemBuilder: (_, i) =>
                            _spotCard(context, filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _mapPreview(BuildContext context, List<Spot> spots) {
    return GestureDetector(
      onTap: () => context.push('/map'),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9), Color(0xFFA5D6A7)],
          ),
          boxShadow: AppEffects.softShadow,
        ),
        child: Stack(
          children: [
            // Decorative grid lines for map feel
            ...List.generate(6, (i) {
              return Positioned(
                left: 0,
                right: 0,
                top: (i * 40).toDouble(),
                child: Container(
                  height: 0.5,
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              );
            }),
            ...List.generate(8, (i) {
              return Positioned(
                top: 0,
                bottom: 0,
                left: (i * 50).toDouble(),
                child: Container(
                  width: 0.5,
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              );
            }),

            // Spot markers
            ...spots.take(8).toList().asMap().entries.map((entry) {
              final index = entry.key;
              final spot = entry.value;
              final rng = Random(spot.id.hashCode);
              final left = 20.0 + rng.nextDouble() * (MediaQuery.of(context).size.width - 120);
              final top = 20.0 + rng.nextDouble() * 140;
              return Positioned(
                left: left.clamp(20, MediaQuery.of(context).size.width - 80),
                top: top.clamp(15, 165),
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, child) {
                    final scale = 1.0 +
                        _pulseController.value * 0.08 * (index % 2 == 0 ? 1 : -1);
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: _mapPin(spot),
                ),
              );
            }),

            // City label
            Positioned(
              bottom: AppSizes.md,
              left: AppSizes.lg,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: AppSizes.xs),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x15000000),
                        blurRadius: 8,
                        offset: Offset(0, 2))
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.explore_rounded,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Bhopal • ${spots.length} spots',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Expand hint
            Positioned(
              bottom: AppSizes.md,
              right: AppSizes.lg,
              child: Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.fullscreen_rounded,
                    size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapPin(Spot spot) {
    final color = _catColor(spot.category);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(_catIcon(spot.category), size: 14, color: Colors.white),
        ),
        Container(
          width: 2,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }

  Widget _spotCard(BuildContext context, Spot spot) {
    final color = _catColor(spot.category);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/veterinarian-profile'),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.cardPadding),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Center(
                  child: Icon(_catIcon(spot.category),
                      color: color, size: 26),
                ),
              ),
              const SizedBox(width: AppSizes.md),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.name,
                      style:
                          Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                                AppSizes.radiusFull),
                          ),
                          child: Text(
                            spot.category.label,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (spot.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.verified_rounded,
                              size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                    if (spot.address != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        spot.address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),

              // Rating
              if (spot.rating > 0)
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 16, color: AppColors.amber),
                        const SizedBox(width: 2),
                        Text(
                          spot.rating.toStringAsFixed(1),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Text(
                      '(${spot.reviewCount})',
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.outline),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _catColor(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => AppColors.restaurant,
        SpotCategory.cafe => const Color(0xFF8D6E63),
        SpotCategory.park => AppColors.park,
        SpotCategory.vet => AppColors.vet,
        SpotCategory.grooming => AppColors.grooming,
        SpotCategory.boarding => AppColors.boarding,
        SpotCategory.petStore => AppColors.petStore,
        _ => AppColors.secondary
      };

  IconData _catIcon(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => Icons.restaurant_rounded,
        SpotCategory.cafe => Icons.local_cafe_rounded,
        SpotCategory.park => Icons.park_rounded,
        SpotCategory.vet => Icons.local_hospital_rounded,
        SpotCategory.grooming => Icons.content_cut_rounded,
        SpotCategory.boarding => Icons.home_rounded,
        SpotCategory.petStore => Icons.store_rounded,
        _ => Icons.place_rounded
      };
}
