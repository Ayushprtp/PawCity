import 'package:flutter/material.dart';
import 'package:pawcity/core/constants/app_sizes.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    required this.title,
    required this.body,
    required this.imageAsset,
    super.key,
  });

  final String title;
  final String body;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Image.asset(imageAsset, height: 240, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSizes.xl),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
