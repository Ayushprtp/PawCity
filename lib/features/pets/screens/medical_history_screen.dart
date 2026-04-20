import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_status_badge.dart';
import 'package:intl/intl.dart';

class MedicalHistoryScreen extends ConsumerWidget {
  const MedicalHistoryScreen({this.petId, super.key});
  final String? petId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use pet ID from constructor or a default
    final id = petId ?? '';
    if (id.isEmpty) {
      return const PawScaffold(title: 'Medical History', showBottomNav: false, showBackButton: true, body: Center(child: Text('Select a pet to view records')));
    }
    final recordsAsync = ref.watch(petHealthRecordsProvider(id));
    return PawScaffold(
      title: 'Medical History',
      showBottomNav: false,
      showBackButton: true,
      actions: [IconButton(icon: const Icon(Icons.add_rounded), onPressed: () {})],
      body: recordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load records')),
        data: (records) {
          if (records.isEmpty) {
            return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.medical_services_rounded, size: 48, color: AppColors.outlineVariant),
              const SizedBox(height: AppSizes.lg),
              Text('No Records', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSizes.sm),
              Text('Add vaccination, checkup & treatment records', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
            ]));
          }
          return ListView.separated(
            itemCount: records.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSizes.md),
            itemBuilder: (_, i) {
              final r = records[i];
              final dateStr = DateFormat('MMM dd, yyyy').format(r.date);
              return PawAsymCard(
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: _typeColor(r.recordType).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                    child: Icon(_typeIcon(r.recordType), color: _typeColor(r.recordType), size: 22),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(r.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: AppSizes.xxs),
                    Row(children: [
                      PawStatusBadge(label: r.recordType, color: _typeColor(r.recordType)),
                      const SizedBox(width: AppSizes.sm),
                      Text(dateStr, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.outline)),
                    ]),
                    if (r.vetName != null) ...[const SizedBox(height: AppSizes.xs), Text('Dr. ${r.vetName}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant))],
                    if (r.description != null) ...[const SizedBox(height: AppSizes.xs), Text(r.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall)],
                    if (r.nextDueDate != null) ...[
                      const SizedBox(height: AppSizes.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
                        decoration: BoxDecoration(color: AppColors.tertiaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                        child: Text('Next: ${DateFormat('MMM dd, yyyy').format(r.nextDueDate!)}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.tertiary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ])),
                ]),
              );
            },
          );
        },
      ),
    );
  }

  Color _typeColor(String t) => switch (t.toLowerCase()) { 'vaccination' => AppColors.severityLow, 'surgery' => AppColors.severityCritical, 'checkup' => AppColors.vet, 'medication' => AppColors.tertiary, _ => AppColors.secondary };
  IconData _typeIcon(String t) => switch (t.toLowerCase()) { 'vaccination' => Icons.vaccines_rounded, 'surgery' => Icons.healing_rounded, 'checkup' => Icons.medical_services_rounded, 'medication' => Icons.medication_rounded, _ => Icons.description_rounded };
}