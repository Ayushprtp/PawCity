import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Shopping Cart',
      currentNavIndex: 2,
      showBottomNav: false,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: const [
                _CartItem(name: 'Orthopedic Pet Bed', price: '₹2,499'),
                SizedBox(height: AppSizes.md),
                _CartItem(name: 'Hydration Travel Bottle', price: '₹699'),
              ],
            ),
          ),
          const PawAsymCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total'), Text('₹3,198')],
                ),
                SizedBox(height: AppSizes.md),
                PawGradientButton(
                  label: 'Proceed to Checkout',
                  onPressed: null,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.md),
          PawGradientButton(
            label: 'Checkout',
            onPressed: () => context.go('/checkout'),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({required this.name, required this.price});

  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    return PawAsymCard(
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(Icons.shopping_bag_rounded),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: AppSizes.xs),
                Text(price),
              ],
            ),
          ),
          const Icon(Icons.delete_outline_rounded),
        ],
      ),
    );
  }
}