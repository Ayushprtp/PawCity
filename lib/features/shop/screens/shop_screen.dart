import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const products = [
      _Product(
        name: 'Organic Beef Kibble',
        category: 'Food & Treats',
        price: '₹2,099',
        rating: '4.9',
        reviews: '128',
        badge: 'Best Seller',
        imageUrl: 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=400&q=80',
      ),
      _Product(
        name: 'Tough-Tug Rope Toy',
        category: 'Toys & Play',
        price: '₹849',
        rating: '4.7',
        reviews: '85',
        imageUrl: 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=400&q=80',
      ),
      _Product(
        name: 'Daily Coat Supplements',
        category: 'Health & Wellness',
        price: '₹1,699',
        rating: '4.8',
        reviews: '210',
        badge: '15% Off',
        imageUrl: 'https://images.unsplash.com/photo-1585664811087-47f65abbad64?w=400&q=80',
      ),
      _Product(
        name: 'Soothing Oatmeal Shampoo',
        category: 'Health & Wellness',
        price: '₹1,199',
        rating: '4.9',
        reviews: '315',
        imageUrl: 'https://images.unsplash.com/photo-1583337130417-13104dec14a1?w=400&q=80',
      ),
      _Product(
        name: 'Cozy Fleece Bed',
        category: 'Beds & Comfort',
        price: '₹3,499',
        rating: '4.8',
        reviews: '167',
        badge: 'New',
        imageUrl: 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=400&q=80',
      ),
      _Product(
        name: 'Interactive Puzzle Feeder',
        category: 'Toys & Play',
        price: '₹1,299',
        rating: '4.6',
        reviews: '93',
        imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400&q=80',
      ),
      _Product(
        name: 'Premium Leather Collar',
        category: 'Accessories',
        price: '₹1,899',
        rating: '4.9',
        reviews: '241',
        imageUrl: 'https://images.unsplash.com/photo-1599443015574-be5fe8a05783?w=400&q=80',
      ),
      _Product(
        name: 'Salmon & Sweet Potato Mix',
        category: 'Food & Treats',
        price: '₹2,599',
        rating: '4.7',
        reviews: '178',
        badge: 'Popular',
        imageUrl: 'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=400&q=80',
      ),
    ];

    return PawScaffold(
      title: 'Paw City Shop',
      currentNavIndex: 3,
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
          Text('Categories', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 108,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryCircle(context, 'Food', Icons.restaurant_rounded),
                const SizedBox(width: AppSizes.md),
                _categoryCircle(context, 'Toys', Icons.toys_rounded),
                const SizedBox(width: AppSizes.md),
                _categoryCircle(context, 'Beds', Icons.king_bed_rounded),
                const SizedBox(width: AppSizes.md),
                _categoryCircle(context, 'Health', Icons.health_and_safety_rounded),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Trending Treats & Toys',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/shop/new-arrivals'),
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('Filters'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.md,
              crossAxisSpacing: AppSizes.md,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) => _productCard(context, products[index]),
          ),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      height: 232,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.surfaceContainerLowest.withValues(alpha: 0.96),
            AppColors.surfaceContainerHigh,
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
              color: AppColors.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              'Spring Sale',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'New toys for sunny days',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Keep your pet active with durable, playful essentials curated for warm-weather adventures.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _categoryCircle(BuildContext context, String label, IconData icon) {
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _productCard(BuildContext context, _Product product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.radiusLg),
                      topRight: Radius.circular(AppSizes.radiusMd),
                      bottomLeft: Radius.circular(AppSizes.radiusMd),
                      bottomRight: Radius.circular(AppSizes.radiusXl),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (product.imageUrl != null)
                        Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.shopping_bag_rounded, size: 34, color: AppColors.onSurfaceVariant),
                          ),
                        )
                      else
                        const Center(
                          child: Icon(Icons.shopping_bag_rounded, size: 34, color: AppColors.onSurfaceVariant),
                        ),
                      if (product.badge != null)
                        Positioned(
                          top: AppSizes.sm,
                          right: AppSizes.sm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: AppSizes.xxs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                            ),
                            child: Text(
                              product.badge!,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: product.badge == '15% Off'
                                        ? AppColors.error
                                        : AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.xs,
              AppSizes.md,
              AppSizes.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSizes.xxs),
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.tertiaryContainer),
                    const SizedBox(width: AppSizes.xxs),
                    Text(
                      '${product.rating} (${product.reviews})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.price,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    InkResponse(
                      onTap: () => context.push('/cart'),
                      radius: 20,
                      child: Container(
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Product {
  const _Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviews,
    this.badge,
    this.imageUrl,
  });

  final String name;
  final String category;
  final String price;
  final String rating;
  final String reviews;
  final String? badge;
  final String? imageUrl;
}
