import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_filter_chip_group.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_text_field.dart';

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({super.key});

  @override
  State<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController(
    text: '123 Main St, Near Central Park',
  );

  String _severity = 'High';
  String _category = 'Injured / Sick';
  bool _anonymous = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Submit Report',
      currentNavIndex: 1,
      showBottomNav: false,
      body: ListView(
        children: [
          _hero(context),
          const SizedBox(height: AppSizes.sectionGap),
          PawAsymCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.sm),
                PawFilterChipGroup(
                  options: const [
                    'Aggressive',
                    'Injured / Sick',
                    'Abandonment',
                    'Cruelty',
                    'Other',
                  ],
                  selected: _category,
                  onSelected: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: AppSizes.lg),
                Text('Severity', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSizes.sm),
                PawFilterChipGroup(
                  options: const ['Low', 'Medium', 'High', 'Critical'],
                  selected: _severity,
                  onSelected: (value) => setState(() => _severity = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          _locationCard(context),
          const SizedBox(height: AppSizes.lg),
          _mediaCard(context),
          const SizedBox(height: AppSizes.lg),
          PawAsymCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description of incident',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSizes.sm),
                PawTextField(
                  label: 'Title',
                  controller: _titleController,
                ),
                const SizedBox(height: AppSizes.md),
                PawTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          _anonymousCard(context),
          const SizedBox(height: AppSizes.sectionGap),
          PawGradientButton(
            label: 'Submit Urgent Report',
            onPressed: () => context.go('/paw-patrol'),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'By submitting, you agree to terms regarding false reporting.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
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
            AppColors.errorContainer.withValues(alpha: 0.22),
            AppColors.surfaceContainerLowest,
          ],
        ),
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
              color: AppColors.errorContainer.withValues(alpha: 0.35),
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
          const SizedBox(height: AppSizes.lg),
          Text(
            'See something, say something.',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Reports are sent to verified local responders. Share details clearly and stay safe.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _locationCard(BuildContext context) {
    return PawAsymCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Incident location', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Drop a pin or enter an address to help responders find the exact area.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSizes.md),
          Container(
            height: 164,
            decoration: BoxDecoration(
              gradient: AppGradients.softSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                ),
                Positioned(
                  left: AppSizes.md,
                  right: AppSizes.md,
                  bottom: AppSizes.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                      vertical: AppSizes.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: TextField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Enter incident location',
                            ),
                          ),
                        ),
                        TextButton(onPressed: () {}, child: const Text('Use current')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaCard(BuildContext context) {
    return PawAsymCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Photo evidence', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Clear media helps responders assess urgency. Do not put yourself in danger.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSizes.md),
          InkWell(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            onTap: () {},
            child: Ink(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                border: Border.all(
                  color: AppColors.outlineVariant,
                  style: BorderStyle.solid,
                  width: 1.2,
                ),
                color: AppColors.surfaceContainerLow,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Icon(Icons.add_a_photo_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    'Tap to upload photos or videos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _anonymousCard(BuildContext context) {
    return PawAsymCard(
      backgroundColor: AppColors.surfaceContainer,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report anonymously',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Your identity will stay hidden from public view, but verified teams can still process your report.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Switch(
            value: _anonymous,
            onChanged: (value) => setState(() => _anonymous = value),
          ),
        ],
      ),
    );
  }
}
