import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class ShopNewArrivalsScreen extends StatelessWidget {
  const ShopNewArrivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const arrivals = [
      _Arrival(
        name: 'Smart Feeder Pro',
        price: '₹10,999',
        blurb: 'Programmable dispenser with portion control.',
        tags: ['Tech', 'Bestseller'],
      ),
      _Arrival(
        name: 'Cloud Nine Lounger',
        price: '₹7,299',
        blurb: 'Memory foam base with washable plush cover.',
        tags: ['Beds'],
      ),
      _Arrival(
        name: 'Artisan Bowl Set',
        price: '₹3,599',
        blurb: 'Hand-glazed ceramic bowls with bamboo stand.',
        tags: ['Dining', 'Eco'],
      ),
    ];

    return PawScaffold(
      title: 'New Arrivals',
      currentNavIndex: 2,
      showBottomNav: false,
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: () => context.push('/cart'),
          icon: const Icon(Icons.shopping_cart_outlined),
        ),
      ],
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(height: AppSizes.sectionGap),
          Text('Curated Picks for You', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.md),
          for (var i = 0; i < arrivals.length; i++) ...[
            _arrivalCard(context, arrivals[i]),
            if (i != arrivals.length - 1) const SizedBox(height: AppSizes.md),
          ],
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      height: 252,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            context.colors.surfaceContainerLowest.withValues(alpha: 0.94),
            context.colors.surfaceContainerHigh,
          ],
        ),
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: context.colors.secondaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              'New Arrivals',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.colors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'The Spring Comfort Collection',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Elevate nap time with premium loungers, smart feeding, and daily-use essentials.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSizes.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryCta,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: FilledButton(
              onPressed: () => context.push('/cart'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xl,
                  vertical: AppSizes.md,
                ),
              ),
              child: const Text('Shop the Collection'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrivalCard(BuildContext context, _Arrival item) {
    return PawAsymCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppGradients.softSurface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusLg),
                topRight: Radius.circular(AppSizes.radiusLg),
                bottomLeft: Radius.circular(AppSizes.radiusMd),
                bottomRight: Radius.circular(AppSizes.radiusXl),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.inventory_2_rounded,
                    size: 42,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Positioned(
                  right: AppSizes.md,
                  bottom: AppSizes.md,
                  child: InkResponse(
                    onTap: () => context.push('/cart'),
                    radius: 24,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        boxShadow: AppEffects.softShadow,
                      ),
                      child: Icon(
                        Icons.add_shopping_cart_rounded,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                item.price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(item.blurb, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSizes.md),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: item.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: tag == 'Eco'
                          ? context.colors.primaryContainer.withValues(alpha: 0.35)
                          : context.colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: tag == 'Eco'
                                ? context.colors.primary
                                : context.colors.onSurfaceVariant,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _Arrival {
  const _Arrival({
    required this.name,
    required this.price,
    required this.blurb,
    required this.tags,
  });

  final String name;
  final String price;
  final String blurb;
  final List<String> tags;
}
