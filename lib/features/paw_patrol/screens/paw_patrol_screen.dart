import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';

class PawPatrolScreen extends ConsumerStatefulWidget {
  const PawPatrolScreen({super.key});

  @override
  ConsumerState<PawPatrolScreen> createState() => _PawPatrolScreenState();
}

class _PawPatrolScreenState extends ConsumerState<PawPatrolScreen> {
  late Future<List<Map<String, dynamic>>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  void _fetchReports() {
    setState(() {
      _reportsFuture = SupabaseService.client
          .from('paw_patrol_reports')
          .select('*, profiles!paw_patrol_reports_reporter_id_fkey(display_name)')
          .order('created_at', ascending: false);
    });
  }

  Color _severityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.severityCritical;
      case 'high':
        return AppColors.severityHigh;
      case 'medium':
        return AppColors.severityMedium;
      default:
        return AppColors.severityLow;
    }
  }

  String _formatStatus(String status) {
    return status.split('_').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Paw Patrol',
      showBottomNav: false,
      showBackButton: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.map_rounded),
          onPressed: () => context.push('/paw-patrol/map'),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: () => context.push('/paw-patrol/report'),
        ),
      ],
      body: RefreshIndicator(
        onRefresh: () async => _fetchReports(),
        child: ListView(
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _reportsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.xl),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                          const SizedBox(height: AppSizes.md),
                          Text('Error loading reports', style: Theme.of(context).textTheme.titleSmall),
                          TextButton(onPressed: _fetchReports, child: const Text('Retry')),
                        ],
                      ),
                    ),
                  );
                }

                final reports = snapshot.data ?? [];
                if (reports.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSizes.xl),
                      child: Text('No reports yet. Your community is safe!'),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reports.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    final r = reports[index];
                    final severity = r['severity']?.toString() ?? 'low';
                    final status = _formatStatus(r['status']?.toString() ?? 'submitted');
                    
                    final createdAt = DateTime.tryParse(r['created_at']?.toString() ?? '')?.toLocal() ?? DateTime.now();
                    final diff = DateTime.now().difference(createdAt);
                    String timeAgo;
                    if (diff.inDays > 0) {
                      timeAgo = '${diff.inDays}d ago';
                    } else if (diff.inHours > 0) {
                      timeAgo = '${diff.inHours}h ago';
                    } else {
                      timeAgo = '${diff.inMinutes}m ago';
                    }

                    return PawAsymCard(
                      onTap: () => context.push('/paw-patrol/detail'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r['title']?.toString() ?? '',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                              PawStatusBadge.severity(severity),
                            ],
                          ),
                          const SizedBox(height: AppSizes.sm),
                          Text(
                            '${r['address'] ?? ''} • $timeAgo',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: AppSizes.md),
                          Row(
                            children: [
                              _statusChip(context, status),
                              const Spacer(),
                              const Icon(Icons.thumb_up_alt_rounded, size: 16, color: AppColors.primary),
                              const SizedBox(width: AppSizes.xs),
                              Text(
                                '${r['upvotes'] ?? 0}',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
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
              onPressed: () => context.push('/paw-patrol/report'),
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
