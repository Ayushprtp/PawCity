import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class ReviewSubmittedScreen extends StatefulWidget {
  const ReviewSubmittedScreen({super.key});
  @override
  State<ReviewSubmittedScreen> createState() => _State();
}

class _State extends State<ReviewSubmittedScreen> with TickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward(); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(title: 'Review Submitted', showBottomNav: false, showBackButton: true, body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      ScaleTransition(scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut), child: Container(padding: const EdgeInsets.all(AppSizes.xxl), decoration: const BoxDecoration(gradient: AppGradients.dashboardHero, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 56, color: Colors.white))),
      const SizedBox(height: AppSizes.sectionGap),
      Text('Thank You! 🎉', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: AppSizes.sm),
      Text('Your review helps other pet parents.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
      const SizedBox(height: AppSizes.xxxl),
      PawGradientButton(label: 'Back to Home', onPressed: () => context.go('/home')),
    ])));
  }
}