import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';

class PawPatrolScreen extends StatelessWidget {
  const PawPatrolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const alerts = [
      _PatrolAlert(
        title: 'Injured stray near Central Park',
        severity: 'High',
        meta: '1.1 km • 12 min ago',
        status: 'Submitted',
        upvotes: 14,
      ),
      _PatrolAlert(
        title: 'Aggressive pack spotted on West Street',
        severity: 'Critical',
        meta: '2.8 km • 20 min ago',
        status: 'In Progress',
        upvotes: 42,
      ),
      _PatrolAlert(
        title: 'Abandonment reported near Metro Gate',
        severity: 'Medium',
        meta: '4.2 km • 1 hr ago',
        status: 'Under Review',
        upvotes: 19,
      ),
    ];

    return PawScaffold(
      title: 'Paw Patrol',
      currentNavIndex: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.map_rounded),
          onPressed: () => context.go('/paw-patrol/map'),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () => context.go('/paw-patrol/report'),
        ),
      ],
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(height: AppSizes.sectionGap),
          Row(
            children: [
              _filterChip(context, 'Nearby', selected: true),
              const SizedBox(width: AppSizes.sm),
              _filterChip(context, 'My City'),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded, size: 18),
                label: const Text('Filter'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          PawAsymCard(
            backgroundColor: AppColors.surfaceContainerLow,
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: const Icon(Icons.location_on_rounded, color: AppColors.secondary),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'Reports are prioritized by severity first, then distance from your current location.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          for (var i = 0; i < alerts.length; i++) ...[
            _alertCard(context, alerts[i]),
            if (i != alerts.length - 1) const SizedBox(height: AppSizes.md),
          ],
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.errorContainer.withValues(alpha: 0.28),
            AppColors.surfaceContainerLowest,
          ],
        ),
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.32),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Text(
                  'Animal Welfare Report',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'See something, say something.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Your report helps local NGOs and authorities intervene in neglect, abuse, and emergency situations.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: AppGradients.primaryCta,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: FilledButton.icon(
              onPressed: () => context.go('/paw-patrol/report'),
              icon: const Icon(Icons.send_rounded),
              label: const Text('Submit Urgent Report'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.xl,
                  vertical: AppSizes.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryContainer.withValues(alpha: 0.35) : null,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
      ),
    );
  }

  Widget _alertCard(BuildContext context, _PatrolAlert alert) {
    return PawAsymCard(
      onTap: () => context.go('/paw-patrol/detail'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              PawStatusBadge.severity(alert.severity),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            alert.meta,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            children: [
              _statusChip(context, alert.status),
              const Spacer(),
              const Icon(Icons.thumb_up_alt_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSizes.xs),
              Text(
                '${alert.upvotes}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(BuildContext context, String label) {
    Color chipColor;
    switch (label.toLowerCase()) {
      case 'in progress':
        chipColor = AppColors.statusInProgress;
        break;
      case 'under review':
        chipColor = AppColors.statusReview;
        break;
      case 'resolved':
        chipColor = AppColors.statusResolved;
        break;
      default:
        chipColor = AppColors.statusSubmitted;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _PatrolAlert {
  const _PatrolAlert({
    required this.title,
    required this.severity,
    required this.meta,
    required this.status,
    required this.upvotes,
  });

  final String title;
  final String severity;
  final String meta;
  final String status;
  final int upvotes;
}
