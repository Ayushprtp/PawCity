import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/models/pet_activity.dart';
import 'package:pawcity/services/activity_service.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';

class ActivityExplorerScreen extends ConsumerWidget {
  final String petId;
  final Pet? pet;

  const ActivityExplorerScreen({
    super.key,
    required this.petId,
    this.pet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(petActivitiesProvider(petId));

    return PawScaffold(
      title: '${pet?.name ?? "Pet"}\'s Activity',
      showBackButton: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogActivityDialog(context, ref),
        label: const Text('Log Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: context.colors.primary,
        foregroundColor: Colors.white,
      ),
      body: activitiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (activities) => CustomScrollView(
          slivers: [
            // ─── Summary Header ───
            SliverToBoxAdapter(
              child: _buildSummaryHeader(context, activities),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionGap)),

            // ─── Activity Stats ───
            SliverToBoxAdapter(
              child: _buildStatsGrid(context, activities),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionGap)),

            // ─── Timeline Header ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                child: Text(
                  'Activity Log',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.md)),

            // ─── Activity Timeline ───
            if (activities.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.xl),
                    child: Text('No activities recorded yet.'),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final activity = activities[index];
                    return _buildActivityTile(context, activity);
                  },
                  childCount: activities.length,
                ),
              ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.xxl)),
          ],
        ),
      ),
    );
  }

  void _showLogActivityDialog(BuildContext context, WidgetRef ref) {
    final types = ['Walking', 'Playing', 'Eating', 'Sleeping'];
    String selectedType = types[0];
    final valueController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Log Activity', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedType,
                items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => selectedType = v!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: selectedType == 'Walking' ? 'Distance (km)' : 
                            selectedType == 'Sleeping' ? 'Duration (hrs)' : 
                            selectedType == 'Eating' ? 'Amount (g)' : 'Value',
                ),
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final activity = PetActivity(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  petId: petId,
                  activityType: selectedType,
                  value: double.tryParse(valueController.text) ?? 0,
                  unit: selectedType == 'Walking' ? 'km' : 
                        selectedType == 'Sleeping' ? 'hrs' : 
                        selectedType == 'Eating' ? 'g' : 'pts',
                  timestamp: DateTime.now(),
                  notes: notesController.text,
                );
                await ref.read(activityServiceProvider).logActivity(activity);
                ref.invalidate(petActivitiesProvider(petId));
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(BuildContext context, List<PetActivity> activities) {
    // Basic calculations
    double totalKm = 0;
    double totalHrs = 0;
    double totalCalories = 0;

    for (var a in activities) {
      if (a.activityType.toLowerCase() == 'walking') {
        totalKm += a.value;
        totalCalories += a.value * 50; // Arbitrary: 50 kcal per km
      } else if (a.activityType.toLowerCase() == 'playing') {
        totalCalories += a.value * 5; // Arbitrary: 5 kcal per pt/min
      } else if (a.activityType.toLowerCase() == 'sleeping') {
        totalHrs += a.value;
      }
    }

    double goalProgress = (totalKm / 5.0).clamp(0.0, 1.0); // Target 5km
    if (goalProgress == 0 && activities.isNotEmpty) goalProgress = 0.1; // Minimal progress if there's any activity

    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        gradient: AppGradients.dashboardHero,
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Goal',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(goalProgress * 100).toInt()}% Completed',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: goalProgress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const Icon(Icons.pets_rounded, color: Colors.white, size: 24),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xl),
          Row(
            children: [
              _summaryChip(context, Icons.directions_walk_rounded, '${totalKm.toStringAsFixed(1)} km'),
              const SizedBox(width: AppSizes.md),
              _summaryChip(context, Icons.timer_rounded, '${totalHrs.toStringAsFixed(1)} hrs'),
              const SizedBox(width: AppSizes.md),
              _summaryChip(context, Icons.local_fire_department_rounded, '${totalCalories.toInt()} kcal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, List<PetActivity> activities) {
    double sleepHrs = 0;
    for (var a in activities) {
      if (a.activityType.toLowerCase() == 'sleeping') sleepHrs += a.value;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              context,
              'Sleep',
              '${sleepHrs.toStringAsFixed(1)} hrs',
              'Goal: 8h',
              Icons.king_bed_rounded,
              context.colors.secondary,
              context.colors.secondaryContainer,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: _statCard(
              context,
              'Health',
              'Optimal',
              'Activity: ${activities.length}',
              Icons.favorite_rounded,
              context.colors.vet,
              context.colors.primaryContainer.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color iconBg,
  ) {
    return PawAsymCard(
      backgroundColor: context.colors.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, PetActivity activity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 6),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getActivityColor(context, activity.activityType).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              _getActivityIcon(activity.activityType),
              color: _getActivityColor(context, activity.activityType),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _capitalize(activity.activityType),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  activity.notes != null && activity.notes!.isNotEmpty 
                      ? activity.notes! 
                      : 'Recorded activity',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${activity.value} ${activity.unit}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colors.primary,
                ),
              ),
              Text(
                _formatTime(activity.timestamp),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'walking': return context.colors.primary;
      case 'playing': return context.colors.tertiary;
      case 'eating': return context.colors.restaurant;
      case 'sleeping': return context.colors.secondary;
      default: return context.colors.outline;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'walking': return Icons.directions_walk_rounded;
      case 'playing': return Icons.sports_tennis_rounded;
      case 'eating': return Icons.restaurant_rounded;
      case 'sleeping': return Icons.king_bed_rounded;
      default: return Icons.pets_rounded;
    }
  }

  String _capitalize(String s) => s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
