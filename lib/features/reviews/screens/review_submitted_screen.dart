import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

class ReviewSubmittedScreen extends StatelessWidget {
  const ReviewSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Review Submitted',
      showBottomNav: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 72),
            const SizedBox(height: AppSizes.md),
            Text(
              'Thank you for helping the community',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.sectionGap),
            PawGradientButton(
              label: 'Back To Home',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }
}