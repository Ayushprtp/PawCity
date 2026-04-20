import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_filter_chip_group.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';

class MyAppointmentsScreen extends ConsumerStatefulWidget {
  const MyAppointmentsScreen({super.key});
  @override
  ConsumerState<MyAppointmentsScreen> createState() => _MyAppointmentsState();
}

class _MyAppointmentsState extends ConsumerState<MyAppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabC;
  @override
  void initState() { super.initState(); _tabC = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tabC.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Appointments',
      currentNavIndex: 3,
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () => context.go('/vet-booking'))],
      body: Column(children: [
        Container(
          decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
          child: TabBar(controller: _tabC, labelColor: AppColors.onSurface, unselectedLabelColor: AppColors.onSurfaceVariant, indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppSizes.radiusMd), boxShadow: AppEffects.glassShadow),
            tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past'), Tab(text: 'Cancelled')],
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        Expanded(child: TabBarView(controller: _tabC, children: [
          _buildList(context, 'upcoming'),
          _buildList(context, 'past'),
          _buildList(context, 'cancelled'),
        ])),
      ]),
    );
  }

  Widget _buildList(BuildContext context, String type) {
    // Demo appointments - in production these come from Supabase
    final demos = <Map<String, dynamic>>[
      {'title': 'Vaccination - Buddy', 'vet': 'PawCare Clinic', 'date': 'Apr 25, 2026', 'time': '10:00 AM', 'status': type == 'upcoming' ? 'Confirmed' : type == 'past' ? 'Completed' : 'Cancelled'},
      {'title': 'Dental Checkup - Luna', 'vet': 'Happy Paws Vet', 'date': 'Apr 28, 2026', 'time': '2:30 PM', 'status': type == 'upcoming' ? 'Pending' : type == 'past' ? 'Completed' : 'Cancelled'},
    ];
    if (type == 'cancelled') demos.removeAt(1);

    return ListView.separated(
      itemCount: demos.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
      itemBuilder: (_, i) {
        final a = demos[i];
        final statusColor = switch (a['status']) { 'Confirmed' => AppColors.severityLow, 'Pending' => AppColors.amber, 'Completed' => AppColors.vet, _ => AppColors.error };
        return PawAsymCard(
          onTap: () {},
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(a['title'] as String, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700))),
              PawStatusBadge(label: a['status'] as String, color: statusColor),
            ]),
            const SizedBox(height: AppSizes.sm),
            Row(children: [
              const Icon(Icons.local_hospital_rounded, size: 14, color: AppColors.vet),
              const SizedBox(width: AppSizes.xs),
              Text(a['vet'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
            ]),
            const SizedBox(height: AppSizes.xs),
            Row(children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.outline),
              const SizedBox(width: AppSizes.xs),
              Text(a['date'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              const SizedBox(width: AppSizes.lg),
              const Icon(Icons.access_time_rounded, size: 14, color: AppColors.outline),
              const SizedBox(width: AppSizes.xs),
              Text(a['time'] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
            ]),
            if (type == 'upcoming') ...[
              const SizedBox(height: AppSizes.md),
              Row(children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Reschedule'))),
                const SizedBox(width: AppSizes.sm),
                Expanded(child: OutlinedButton(onPressed: () {}, style: OutlinedButton.styleFrom(foregroundColor: AppColors.error), child: const Text('Cancel'))),
              ]),
            ],
          ]),
        );
      },
    );
  }
}