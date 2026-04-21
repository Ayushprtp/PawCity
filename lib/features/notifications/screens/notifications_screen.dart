import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/providers/notification_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_empty_state.dart';
import 'package:pawcity/shared/widgets/paw_error_state.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_skeleton.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncNotifs = ref.watch(notificationsProvider);
    return PawScaffold(
      title: 'Notifications',
      currentNavIndex: 0,
      showBottomNav: false,
      showBackButton: true,
      actions: [
        TextButton(
          onPressed: () async {
            await ref.read(notificationRepositoryProvider).markAllAsRead();
            ref.invalidate(notificationsProvider);
          },
          child: Text('Read all',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
        ),
      ],
      body: asyncNotifs.when(
        loading: () => ListView(
          children: List.generate(5, (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sm),
            child: PawRowSkeleton(),
          )),
        ),
        error: (_, __) => PawErrorState(
          icon: Icons.notifications_off_rounded,
          title: 'Can\'t load notifications',
          message: 'We couldn\'t fetch your notifications. Pull down to try again.',
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const PawEmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'All caught up!',
              message: 'You have no new notifications. Check back later.',
              iconColor: AppColors.primary,
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, i) {
              final n = items[i];
              return PawAsymCard(
                backgroundColor: n.isRead ? AppColors.surfaceContainerLowest : AppColors.secondaryContainer.withValues(alpha: 0.15),
                onTap: () async {
                  if (!n.isRead) {
                    await ref.read(notificationRepositoryProvider).markAsRead(n.id);
                    ref.invalidate(notificationsProvider);
                  }
                },
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(color: _color(n.type).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Icon(_icon(n.type), size: 20, color: _color(n.type)),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Expanded(child: Text(n.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700))),
                        if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                      ]),
                      const SizedBox(height: AppSizes.xs),
                      Text(n.body, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                      if (n.createdAt != null) ...[
                        const SizedBox(height: AppSizes.xs),
                        Text(timeago.format(n.createdAt!), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline)),
                      ],
                    ]),
                  ),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  IconData _icon(String t) => switch (t) { 'report_update' => Icons.campaign_rounded, 'review' => Icons.rate_review_rounded, 'pet_health' => Icons.health_and_safety_rounded, 'lost_pet' => Icons.search_rounded, _ => Icons.notifications_rounded };
  Color _color(String t) => switch (t) { 'report_update' => AppColors.tertiary, 'review' => AppColors.secondary, 'pet_health' => AppColors.primary, 'lost_pet' => AppColors.error, _ => AppColors.onSurfaceVariant };
}
