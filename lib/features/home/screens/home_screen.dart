import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/services/health_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double _distanceWalked = 0.0;
  bool _isLoadingHealth = true;

  @override
  void initState() {
    super.initState();
    _initHealthData();
  }

  Future<void> _initHealthData() async {
    final service = ref.read(healthServiceProvider);
    final granted = await service.requestPermissions();
    if (granted) {
      final dist = await service.getDistanceWalkedToday();
      if (mounted) {
        setState(() {
          _distanceWalked = dist;
          _isLoadingHealth = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoadingHealth = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Find Spots', Icons.place_rounded, '/paws-explore'),
      ('Paw Patrol', Icons.campaign_rounded, '/paw-patrol'),
      ('My Pets', Icons.pets_rounded, '/my-pets'),
      ('Lost Pet SOS', Icons.warning_amber_rounded, '/lost-pet'),
    ];

    final reminders = [
      const _Reminder(
        accent: AppColors.secondary,
        icon: Icons.vaccines_rounded,
        title: 'Annual Boosters',
        date: 'Oct 24, 10:00 AM',
        place: 'Pawsitive Care Vet',
        timing: 'In 3 Days',
      ),
      const _Reminder(
        accent: AppColors.tertiary,
        icon: Icons.content_cut_rounded,
        title: 'Grooming Session',
        date: 'Oct 30, 2:00 PM',
        place: 'The Fluffy Puppy',
        timing: 'Next Week',
      ),
    ];

    return PawScaffold(
      title: AppStrings.appName,
      currentNavIndex: 0,
      actions: [
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: () => context.push('/profile'),
          icon: const Icon(Icons.person_outline_rounded),
        ),
      ],
      body: ListView(
        children: [
          _heroCard(context),
          const SizedBox(height: AppSizes.sectionGap),
          Text(
            AppStrings.dashboardQuickActions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSizes.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSizes.md,
              crossAxisSpacing: AppSizes.md,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final item = actions[index];
              return PawAsymCard(
                onTap: () => context.push(item.$3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.38),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Icon(item.$2, color: AppColors.primary),
                    ),
                    Text(
                      item.$1,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: AppSizes.sectionGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final tiles = [
                const _MetricTile(
                  icon: Icons.monitor_weight_rounded,
                  iconColor: AppColors.secondary,
                  iconBackground: AppColors.secondaryContainer,
                  label: 'Weight',
                  value: '62 lbs',
                  subvalue: 'Target: 60 lbs',
                ),
                _MetricTile(
                  icon: Icons.directions_run_rounded,
                  iconColor: AppColors.tertiary,
                  iconBackground: AppColors.tertiaryContainer,
                  label: 'Activity',
                  value: _isLoadingHealth ? '...' : '${(_distanceWalked / 1000).toStringAsFixed(1)} km',
                  subvalue: '/ 5.0 km goal',
                ),
              ];

              if (constraints.maxWidth < 560) {
                return Column(
                  children: [
                    tiles[0],
                    const SizedBox(height: AppSizes.md),
                    tiles[1],
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: tiles[0]),
                  const SizedBox(width: AppSizes.md),
                  Expanded(child: tiles[1]),
                ],
              );
            },
          ),
          const SizedBox(height: AppSizes.sectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Upcoming Care',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: reminders.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.md),
              itemBuilder: (context, index) {
                if (index == reminders.length) {
                  return _addReminderCard(context);
                }

                final reminder = reminders[index];
                return _reminderCard(context, reminder);
              },
            ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          Text('Daily Paw-tips', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.lg),
          _featuredTipCard(context),
          const SizedBox(height: AppSizes.md),
          LayoutBuilder(
            builder: (context, constraints) {
              final left = _smallTipCard(
                context,
                background: AppColors.secondaryContainer,
                badge: 'Training',
                title: "Mastering the 'Stay' command outdoors",
                subtitle: 'Read 3 min',
                icon: Icons.park_rounded,
                iconColor: AppColors.secondary,
              );
              final right = _smallTipCard(
                context,
                background: AppColors.surfaceContainerLowest,
                badge: 'Wellness',
                title: 'Mental stimulation games',
                subtitle: 'Keep her sharp on rainy days.',
                icon: Icons.psychology_rounded,
                iconColor: AppColors.tertiary,
              );

              if (constraints.maxWidth < 560) {
                return Column(
                  children: [
                    left,
                    const SizedBox(height: AppSizes.md),
                    right,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: left),
                  const SizedBox(width: AppSizes.md),
                  Expanded(child: right),
                ],
              );
           ),\n          const SizedBox(height: AppSizes.sectionGap),\n          _aiInsightsCard(context),\n        ],\n      ),\n    );\n  }\n\n  void _showAiInsights(BuildContext context) {\n    showModalBottomSheet(\n      context: context,\n      isScrollControlled: true,\n      shape: const RoundedRectangleBorder(\n        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),\n      ),\n      builder: (ctx) {\n        return DraggableScrollableSheet(\n          initialChildSize: 0.7,\n          minChildSize: 0.4,\n          maxChildSize: 0.92,\n          expand: false,\n          builder: (_, scrollCtrl) {\n            return SingleChildScrollView(\n              controller: scrollCtrl,\n              padding: const EdgeInsets.all(AppSizes.xl),\n              child: Column(\n                crossAxisAlignment: CrossAxisAlignment.start,\n                children: [\n                  Center(\n                    child: Container(\n                      width: 40, height: 4,\n                      decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),\n                    ),\n                  ),\n                  const SizedBox(height: AppSizes.lg),\n                  Row(\n                    children: [\n                      Container(\n                        padding: const EdgeInsets.all(AppSizes.sm),\n                        decoration: BoxDecoration(\n                          gradient: AppGradients.dashboardHero,\n                          borderRadius: BorderRadius.circular(AppSizes.radiusMd),\n                        ),\n                        child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),\n                      ),\n                      const SizedBox(width: AppSizes.md),\n                      Expanded(\n                        child: Column(\n                          crossAxisAlignment: CrossAxisAlignment.start,\n                          children: [\n                            Text('PawCity AI', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),\n                            Text('Personalized insights for Luna', style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),\n                          ],\n                        ),\n                      ),\n                    ],\n                  ),\n                  const SizedBox(height: AppSizes.xl),\n\n                  // Next Walk Prediction\n                  _insightTile(\n                    ctx,\n                    icon: Icons.directions_walk_rounded,\n                    color: AppColors.secondary,\n                    title: 'Next Walk Suggestion',\n                    body: 'Based on Luna\\'s activity pattern, the best time for her next walk is around 5:30 PM today. The weather is clear and foot traffic in Riverside Park is low right now.',\n                    confidence: 0.92,\n                  ),\n                  const SizedBox(height: AppSizes.md),\n\n                  // Mood Analysis\n                  _insightTile(\n                    ctx,\n                    icon: Icons.mood_rounded,\n                    color: AppColors.tertiary,\n                    title: 'Mood Analysis',\n                    body: 'Luna\\'s energy levels have been steady this week. Based on walk duration and play frequency, she seems content. Consider adding a puzzle toy session to boost mental stimulation.',\n                    confidence: 0.85,\n                  ),\n                  const SizedBox(height: AppSizes.md),\n\n                  // Community Alert\n                  _insightTile(\n                    ctx,\n                    icon: Icons.campaign_rounded,\n                    color: AppColors.error,\n                    title: 'Community Alert',\n                    body: '3 Paw Patrol reports were filed near your usual walk route (Elm St area) this week. Consider an alternate route through Oak Park for safer walks.',\n                    confidence: 0.78,\n                  ),\n                  const SizedBox(height: AppSizes.md),\n\n                  // Health Prediction\n                  _insightTile(\n                    ctx,\n                    icon: Icons.medical_services_rounded,\n                    color: AppColors.vet,\n                    title: 'Health Reminder',\n                    body: 'Luna\\'s annual vaccination is due in 8 days. Based on nearby vet availability, Dr. Sarah Jenkins at PawCare Clinic has slots open next Tuesday at 10:30 AM.',\n                    confidence: 0.95,\n                  ),\n                  const SizedBox(height: AppSizes.xl),\n\n                  Container(\n                    padding: const EdgeInsets.all(AppSizes.md),\n                    decoration: BoxDecoration(\n                      color: AppColors.surfaceContainerLow,\n                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),\n                    ),\n                    child: Row(\n                      children: [\n                        const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.onSurfaceVariant),\n                        const SizedBox(width: AppSizes.sm),\n                        Expanded(\n                          child: Text(\n                            'Insights are generated from walk history, community reports, and health records.',\n                            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),\n                          ),\n                        ),\n                      ],\n                    ),\n                  ),\n                  const SizedBox(height: AppSizes.lg),\n                ],\n              ),\n            );\n          },\n        );\n      },\n    );\n  }\n\n  Widget _insightTile(BuildContext context, {\n    required IconData icon,\n    required Color color,\n    required String title,\n    required String body,\n    required double confidence,\n  }) {\n    return Container(\n      padding: const EdgeInsets.all(AppSizes.lg),\n      decoration: BoxDecoration(\n        color: AppColors.surfaceContainerLowest,\n        borderRadius: BorderRadius.circular(AppSizes.radiusLg),\n        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.18)),\n      ),\n      child: Column(\n        crossAxisAlignment: CrossAxisAlignment.start,\n        children: [\n          Row(\n            children: [\n              Container(\n                padding: const EdgeInsets.all(AppSizes.sm),\n                decoration: BoxDecoration(\n                  color: color.withValues(alpha: 0.12),\n                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),\n                ),\n                child: Icon(icon, color: color, size: 20),\n              ),\n              const SizedBox(width: AppSizes.md),\n              Expanded(\n                child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),\n              ),\n              Container(\n                padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xxs),\n                decoration: BoxDecoration(\n                  color: color.withValues(alpha: 0.12),\n                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),\n                ),\n                child: Text(\n                  '${(confidence * 100).toInt()}%',\n                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700),\n                ),\n              ),\n            ],\n          ),\n          const SizedBox(height: AppSizes.md),\n          Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant, height: 1.5)),\n        ],\n      ),\n    );\n  }\n\n  Widget _aiInsightsCard(BuildContext context) {\n    return GestureDetector(\n      onTap: () => _showAiInsights(context),\n      child: Container(\n        padding: const EdgeInsets.all(AppSizes.xl),\n        decoration: BoxDecoration(\n          gradient: LinearGradient(\n            begin: Alignment.topLeft,\n            end: Alignment.bottomRight,\n            colors: [\n              AppColors.primaryDark.withValues(alpha: 0.95),\n              AppColors.primary.withValues(alpha: 0.85),\n            ],\n          ),\n          borderRadius: AppEffects.asymCardRadius,\n          boxShadow: AppEffects.softShadow,\n        ),\n        child: Row(\n          children: [\n            Container(\n              padding: const EdgeInsets.all(AppSizes.md),\n              decoration: BoxDecoration(\n                color: Colors.white.withValues(alpha: 0.15),\n                borderRadius: BorderRadius.circular(AppSizes.radiusMd),\n              ),\n              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),\n            ),\n            const SizedBox(width: AppSizes.lg),\n            Expanded(\n              child: Column(\n                crossAxisAlignment: CrossAxisAlignment.start,\n                children: [\n                  Text('AI Pet Insights', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),\n                  const SizedBox(height: AppSizes.xs),\n                  Text(\n                    'Walk predictions, mood analysis & community alerts tailored for Luna.',\n                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),\n                  ),\n                ],\n              ),\n            ),\n            const SizedBox(width: AppSizes.sm),\n            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),\n          ],\n        ),\n      ),\n    );\n  }

  Widget _heroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.dashboardHero,
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              'Good Morning, Sarah',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.9,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Luna is doing great!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Her activity levels are up 15% this week. Keep up those evening park walks.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.94),
                ),
          ),
          const SizedBox(height: AppSizes.lg),
          FilledButton.icon(
            onPressed: () => _showAiInsights(context),
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: const Text('AI Pet Insights'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.xl,
                vertical: AppSizes.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reminderCard(BuildContext context, _Reminder reminder) {
    return Container(
      width: 290,
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: reminder.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Icon(reminder.icon, color: reminder.accent),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: reminder.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Text(
                  reminder.timing,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: reminder.accent,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            reminder.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(reminder.date, style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.place_rounded, size: 16, color: AppColors.onSurfaceVariant),
              const SizedBox(width: AppSizes.xs),
              Expanded(
                child: Text(
                  reminder.place,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addReminderCard(BuildContext context) {
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outlineVariant, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: const Icon(Icons.add_rounded),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Add Reminder',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Meds, walks, or playdates',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _featuredTipCard(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceContainerHigh,
            AppColors.primaryDark.withValues(alpha: 0.92),
          ],
        ),
        borderRadius: AppEffects.asymCardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Text(
              'Nutrition',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            'Transitioning to autumn diets',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.surfaceContainerLowest,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'As weather cools down, Luna may need fewer calories. Here is a safe way to adjust portions.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.surfaceContainerHighest,
                ),
          ),
        ],
      ),
    );
  }

  Widget _smallTipCard(
    BuildContext context, {
    required Color background,
    required String badge,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                badge,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.label,
    required this.value,
    required this.subvalue,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final String subvalue;

  @override
  Widget build(BuildContext context) {
    return PawAsymCard(
      backgroundColor: AppColors.surfaceContainerLow,
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                RichText(
                  text: TextSpan(
                    text: value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                    children: [
                      TextSpan(
                        text: '  $subvalue',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Reminder {
  const _Reminder({
    required this.accent,
    required this.icon,
    required this.title,
    required this.date,
    required this.place,
    required this.timing,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final String date;
  final String place;
  final String timing;
}
