import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Checkout',
      currentNavIndex: 2,
      showBottomNav: false,
      showBackButton: true,
      body: ListView(
        children: [
          _summaryCard(context),
          const SizedBox(height: AppSizes.sectionGap),
          const _Section(title: 'Shipping Address', value: '22 Park Avenue, Bengaluru'),
          const SizedBox(height: AppSizes.md),
          const _Section(title: 'Payment Method', value: 'UPI • **** 4432'),
          const SizedBox(height: AppSizes.md),
          const _Section(title: 'Delivery', value: 'Express • Tomorrow'),
          const SizedBox(height: AppSizes.sectionGap),
          PawGradientButton(
            label: 'Place Order',
            onPressed: () => context.push('/review-submitted'),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceContainerLowest,
            AppColors.surfaceContainerHigh,
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.radiusLg),
          topRight: Radius.circular(AppSizes.radiusXl),
          bottomLeft: Radius.circular(AppSizes.radiusXl),
          bottomRight: Radius.circular(AppSizes.radiusLg),
        ),
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            '2 items • Estimated delivery tomorrow',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSizes.lg),
          _row(context, 'Orthopedic Pet Bed', '₹2,499'),
          const SizedBox(height: AppSizes.sm),
          _row(context, 'Hydration Travel Bottle', '₹699'),
          const SizedBox(height: AppSizes.sm),
          _row(context, 'Shipping', '₹0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.md),
            child: Divider(height: 1),
          ),
          _row(
            context,
            'Total',
            '₹3,198',
            valueStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: valueStyle ?? Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PawAsymCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
