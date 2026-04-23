import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});
  @override
  State<BookingConfirmationScreen> createState() => _State();
}

class _State extends State<BookingConfirmationScreen> with TickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() { super.initState(); _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward(); }
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(title: 'Booking Confirmed', showBottomNav: false, showBackButton: true, body: SingleChildScrollView(child: Column(children: [
      const SizedBox(height: AppSizes.xl),
      ScaleTransition(scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut), child: Container(padding: const EdgeInsets.all(AppSizes.xxl), decoration: const BoxDecoration(gradient: AppGradients.dashboardHero, shape: BoxShape.circle), child: const Icon(Icons.calendar_today_rounded, size: 48, color: Colors.white))),
      const SizedBox(height: AppSizes.sectionGap),
      Text('Booking Confirmed! 🎉', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
      const SizedBox(height: AppSizes.sm),
      Text('Your appointment has been scheduled', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant)),
      const SizedBox(height: AppSizes.sectionGap),
      PawAsymCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _row(context, Icons.local_hospital_rounded, 'Clinic', 'PawCare Vet Clinic'),
        const Divider(height: AppSizes.lg),
        _row(context, Icons.calendar_today_rounded, 'Date', 'April 25, 2026'),
        const Divider(height: AppSizes.lg),
        _row(context, Icons.access_time_rounded, 'Time', '10:00 AM'),
        const Divider(height: AppSizes.lg),
        _row(context, Icons.pets_rounded, 'Pet', 'Buddy (Golden Retriever)'),
        const Divider(height: AppSizes.lg),
        _row(context, Icons.medical_services_rounded, 'Service', 'General Checkup'),
      ])),
      const SizedBox(height: AppSizes.sectionGap),
      PawGradientButton(label: 'View Appointments', onPressed: () => context.go('/appointments')),
      const SizedBox(height: AppSizes.md),
      TextButton(onPressed: () => context.go('/home'), child: const Text('Back to Home')),
      const SizedBox(height: AppSizes.xxl),
    ])));
  }

  Widget _row(BuildContext ctx, IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: context.colors.secondary),
      const SizedBox(width: AppSizes.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(ctx).textTheme.labelSmall?.copyWith(color: context.colors.onSurfaceVariant)),
        Text(value, style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ])),
    ]);
  }
}