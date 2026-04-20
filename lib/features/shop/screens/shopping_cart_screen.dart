import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final _items = [
    _CartItem('Premium Dog Food', 'Royal Canin · 3kg', 1890, 1),
    _CartItem('Chew Toy Bundle', 'Set of 5 durable toys', 599, 2),
    _CartItem('Pet Shampoo', 'Organic lavender · 500ml', 450, 1),
  ];

  double get _subtotal => _items.fold(0, (s, i) => s + i.price * i.qty);
  double get _delivery => _subtotal > 999 ? 0 : 49;
  double get _total => _subtotal + _delivery;

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Cart (${_items.fold<int>(0, (s, i) => s + i.qty)})',
      showBottomNav: false,
      showBackButton: true,
      body: _items.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.outlineVariant),
              const SizedBox(height: AppSizes.lg),
              Text('Your cart is empty', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sectionGap),
              PawGradientButton(label: 'Browse Shop', onPressed: () => context.go('/shop')),
            ]))
          : Column(children: [
              Expanded(child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
                itemBuilder: (_, i) {
                  final item = _items[i];
                  return PawAsymCard(
                    child: Row(children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(gradient: AppGradients.softSurface, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                        child: const Center(child: Icon(Icons.shopping_bag_rounded, color: AppColors.primary, size: 28)),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text(item.desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: AppSizes.xs),
                        Text('₹${item.price}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w800)),
                      ])),
                      // Qty controls
                      Container(
                        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () { setState(() { if (item.qty > 1) {
                            item.qty--;
                          } else {
                            _items.removeAt(i);
                          } }); }, iconSize: 16, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
                          Text('${item.qty}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () => setState(() => item.qty++), iconSize: 16, constraints: const BoxConstraints(minWidth: 32, minHeight: 32)),
                        ]),
                      ),
                    ]),
                  );
                },
              )),
              // Summary
              PawAsymCard(
                child: Column(children: [
                  _summaryRow(context, 'Subtotal', '₹${_subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: AppSizes.xs),
                  _summaryRow(context, 'Delivery', _delivery == 0 ? 'FREE' : '₹${_delivery.toStringAsFixed(0)}'),
                  const Divider(height: AppSizes.lg),
                  _summaryRow(context, 'Total', '₹${_total.toStringAsFixed(0)}', isBold: true),
                  const SizedBox(height: AppSizes.md),
                  PawGradientButton(label: 'Checkout', onPressed: () => context.push('/checkout')),
                ]),
              ),
            ]),
    );
  }

  Widget _summaryRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isBold ? AppColors.onSurface : AppColors.onSurfaceVariant, fontWeight: isBold ? FontWeight.w700 : null)),
      Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.w800 : FontWeight.w600, color: isBold ? AppColors.primary : AppColors.onSurface)),
    ]);
  }
}

class _CartItem {
  final String name, desc;
  final int price;
  int qty;
  _CartItem(this.name, this.desc, this.price, this.qty);
}