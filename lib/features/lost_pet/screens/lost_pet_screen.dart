import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/lost_pet_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pawcity/core/theme/app_colors_extension.dart';

class LostPetScreen extends ConsumerWidget {
  const LostPetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(lostPetAlertsProvider);
    return PawScaffold(
      title: 'Lost & Found',
      currentNavIndex: 1,
      showBottomNav: false,
      showBackButton: true,
      actions: [
        IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.push('/lost-pet/report')),
      ],
      body: alertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load alerts')),
        data: (alerts) {
          if (alerts.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(padding: const EdgeInsets.all(AppSizes.xl), decoration: BoxDecoration(color: context.colors.errorContainer.withValues(alpha: 0.2), shape: BoxShape.circle), child: Icon(Icons.pets_rounded, size: 48, color: context.colors.error)),
              const SizedBox(height: AppSizes.lg),
              Text('No Active Alerts', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sm),
              Text('When a pet goes missing, alerts will appear here.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant), textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.sectionGap),
              PawGradientButton(label: 'Report Lost Pet', onPressed: () => context.push('/lost-pet/report')),
            ]));
          }
          return ListView.separated(
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
            itemBuilder: (context, i) {
              final a = alerts[i];
              return PawAsymCard(
                onTap: () {},
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (a.petPhotoUrl != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppSizes.radiusLg), bottomRight: Radius.circular(AppSizes.radiusLg)),
                      child: Image.network(a.petPhotoUrl!, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 160, color: context.colors.surfaceContainerHigh, child: Center(child: Icon(Icons.pets_rounded, size: 48, color: context.colors.outlineVariant)))),
                    )
                  else
                    Container(height: 100, width: double.infinity, decoration: const BoxDecoration(gradient: AppGradients.softSurface, borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSizes.radiusLg), bottomRight: Radius.circular(AppSizes.radiusLg))), child: Center(child: Text(a.petType.emoji, style: const TextStyle(fontSize: 40)))),
                  const SizedBox(height: AppSizes.md),
                  Row(children: [
                    Expanded(child: Text(a.petName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700))),
                    PawStatusBadge(label: a.isFound ? 'Found' : 'Missing', color: a.isFound ? context.colors.severityLow : context.colors.error),
                  ]),
                  const SizedBox(height: AppSizes.xs),
                  Text('${a.petType.label}${a.petBreed != null ? ' · ${a.petBreed}' : ''}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
                  const SizedBox(height: AppSizes.sm),
                  Text(a.petDescription, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSizes.md),
                  Row(children: [
                    Icon(Icons.location_on_rounded, size: 14, color: context.colors.outline),
                    const SizedBox(width: AppSizes.xs),
                    Expanded(child: Text(a.lastSeenAddress ?? 'Location reported', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.outline))),
                    if (a.createdAt != null) Text(timeago.format(a.createdAt!), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: context.colors.outline)),
                  ]),
                  if (a.rewardAmount != null && a.rewardAmount! > 0) ...[
                    const SizedBox(height: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                      decoration: BoxDecoration(gradient: AppGradients.warmAccent, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                      child: Text('Reward: ₹${a.rewardAmount!.toStringAsFixed(0)}', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: context.colors.onSurface)),
                    ),
                  ],
                ]),
              );
            },
          );
        },
      ),
    );
  }
}
