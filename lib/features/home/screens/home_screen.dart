import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/constants/app_strings.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pawcity/services/health_service.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

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
      _Reminder(
        accent: context.colors.secondary,
        icon: Icons.vaccines_rounded,
        title: 'Annual Boosters',
        date: 'Oct 24, 10:00 AM',
        place: 'Pawsitive Care Vet',
        timing: 'In 3 Days',
      ),
      _Reminder(
        accent: context.colors.tertiary,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: actions.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.push(item.$3),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: context.colors.primaryContainer.withValues(alpha: 0.38),
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        ),
                        child: Icon(item.$2, color: context.colors.primary),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        item.$1,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          LayoutBuilder(
            builder: (context, constraints) {
              final tiles = [
                _MetricTile(
                  icon: Icons.monitor_weight_rounded,
                  iconColor: context.colors.secondary,
                  iconBackground: context.colors.secondaryContainer,
                  label: 'Weight',
                  value: '62 lbs',
                  subvalue: 'Target: 60 lbs',
                  onTap: () {},
                ),
                _MetricTile(
                  icon: Icons.directions_run_rounded,
                  iconColor: context.colors.tertiary,
                  iconBackground: context.colors.tertiaryContainer,
                  label: 'Activity',
                  value: _isLoadingHealth ? '...' : '${(_distanceWalked / 1000).toStringAsFixed(1)} km',
                  subvalue: '/ 5.0 km goal',
                  onTap: () {},
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
                badge: 'Training',
                title: "Mastering the 'Stay' command outdoors",
                subtitle: 'Read 3 min',
                icon: Icons.park_rounded,
                iconColor: context.colors.secondary,
                imageUrl: 'https://placedog.net/600/600?id=3',
              );
              final right = _smallTipCard(
                context,
                badge: 'Wellness',
                title: 'Mental stimulation games',
                subtitle: 'Keep her sharp on rainy days.',
                icon: Icons.psychology_rounded,
                iconColor: context.colors.tertiary,
                imageUrl: 'https://placedog.net/600/600?id=4',
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
            },
          ),
          const SizedBox(height: AppSizes.sectionGap),
          _aiInsightsCard(context),
        ],
      ),
    );
  }

  // ─── AI Insights ───

  void _showAiInsights(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          expand: false,
          builder: (_, scrollCtrl) {
            return SingleChildScrollView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(AppSizes.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: context.colors.outlineVariant, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(gradient: AppGradients.dashboardHero, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('PawCity AI', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      Text('Personalized insights for Luna', style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
                    ])),
                  ]),
                  const SizedBox(height: AppSizes.xl),
                  _insightTile(ctx, icon: Icons.directions_walk_rounded, color: context.colors.secondary, title: 'Next Walk Suggestion',
                    body: "Based on Luna's activity pattern, the best time for her next walk is around 5:30 PM today. The weather is clear and foot traffic in Riverside Park is low right now.", confidence: 0.92),
                  const SizedBox(height: AppSizes.md),
                  _insightTile(ctx, icon: Icons.mood_rounded, color: context.colors.tertiary, title: 'Mood Analysis',
                    body: "Luna's energy levels have been steady this week. Based on walk duration and play frequency, she seems content. Consider adding a puzzle toy session to boost mental stimulation.", confidence: 0.85),
                  const SizedBox(height: AppSizes.md),
                  _insightTile(ctx, icon: Icons.campaign_rounded, color: context.colors.error, title: 'Community Alert',
                    body: '3 Paw Patrol reports were filed near your usual walk route (Elm St area) this week. Consider an alternate route through Oak Park for safer walks.', confidence: 0.78),
                  const SizedBox(height: AppSizes.md),
                  _insightTile(ctx, icon: Icons.medical_services_rounded, color: context.colors.primary, title: 'Health Reminder',
                    body: "Luna's annual vaccination is due in 8 days. Based on nearby vet availability, Dr. Sarah Jenkins at PawCare Clinic has slots open next Tuesday at 10:30 AM.", confidence: 0.95),
                  const SizedBox(height: AppSizes.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(color: context.colors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Row(children: [
                      Icon(Icons.info_outline_rounded, size: 16, color: context.colors.onSurfaceVariant),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(child: Text('Insights are generated from walk history, community reports, and health records.',
                        style: Theme.of(ctx).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant))),
                    ]),
                  ),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _insightTile(BuildContext context, {
    required IconData icon, required Color color, required String title,
    required String body, required double confidence,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: context.colors.outlineVariant.withValues(alpha: 0.18)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xxs),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
            child: Text('${(confidence * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: AppSizes.md),
        Text(body, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant, height: 1.5)),
      ]),
    );
  }

  Widget _aiInsightsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAiInsights(context),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            context.colors.primaryDark.withValues(alpha: 0.95),
            context.colors.primary.withValues(alpha: 0.85),
          ]),
          borderRadius: AppEffects.asymCardRadius,
          boxShadow: AppEffects.softShadow,
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('AI Pet Insights', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSizes.xs),
            Text('Walk predictions, mood analysis & community alerts tailored for Luna.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
          ])),
          const SizedBox(width: AppSizes.sm),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 16),
        ]),
      ),
    );
  }

  // ─── Hero Card ───

  Widget _heroCard(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: AppEffects.asymCardRadius,
          boxShadow: AppEffects.softShadow,
          image: const DecorationImage(
            image: CachedNetworkImageProvider('https://placedog.net/1000/600?id=1'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.black.withValues(alpha: 0.8),
                Colors.black.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: AppEffects.asymCardRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider('https://i.pravatar.cc/150?img=1'),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
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
                ],
              ),
              const SizedBox(height: AppSizes.xl),
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
                  foregroundColor: context.colors.primary,
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
        ),
      ),
    );
  }

  Widget _reminderCard(BuildContext context, _Reminder reminder) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 290,
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: context.colors.outlineVariant.withValues(alpha: 0.18),
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
              Icon(Icons.place_rounded, size: 16, color: context.colors.onSurfaceVariant),
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
    ));
  }

  Widget _addReminderCard(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              border: Border.all(color: context.colors.outlineVariant, style: BorderStyle.solid),
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
    ));
  }

  Widget _featuredTipCard(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: AppEffects.asymCardRadius,
          image: const DecorationImage(
            image: CachedNetworkImageProvider('https://placedog.net/800/400?id=2'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                context.colors.primaryDark.withValues(alpha: 0.92),
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
                  color: context.colors.primary,
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
                      color: context.colors.surfaceContainerLowest,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                'As weather cools down, Luna may need fewer calories. Here is a safe way to adjust portions.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.colors.surfaceContainerHighest,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallTipCard(
    BuildContext context, {
    required String badge,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          color: context.colors.surfaceContainerLowest,
          image: imageUrl != null
              ? DecorationImage(
                  image: CachedNetworkImageProvider(imageUrl),
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.cardPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(icon, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    badge,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
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
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String label;
  final String value;
  final String subvalue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PawAsymCard(
      onTap: onTap ?? () {},
      backgroundColor: context.colors.surfaceContainerLow,
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
                        color: context.colors.onSurfaceVariant,
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
