import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/lost_pet_provider.dart';
import 'package:pawcity/shared/widgets/location_picker_sheet.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/shared/widgets/paw_text_field.dart';

class LostPetReportScreen extends ConsumerStatefulWidget {
  const LostPetReportScreen({super.key});
  @override
  ConsumerState<LostPetReportScreen> createState() => _LostPetReportScreenState();
}

class _LostPetReportScreenState extends ConsumerState<LostPetReportScreen> {
  final _nameC = TextEditingController();
  final _breedC = TextEditingController();
  final _descC = TextEditingController();
  final _addressC = TextEditingController();
  final _phoneC = TextEditingController();
  final _rewardC = TextEditingController();
  PetType _selectedType = PetType.dog;
  bool _isLoading = false;

  // Location picker state
  LatLng? _selectedLocation;

  @override
  void dispose() {
    _nameC.dispose(); _breedC.dispose(); _descC.dispose();
    _addressC.dispose(); _phoneC.dispose(); _rewardC.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    final result = await LocationPickerSheet.show(
      context,
      initialPosition: _selectedLocation,
    );
    if (result != null && mounted) {
      setState(() {
        _selectedLocation = result.position;
        if (result.address != null && result.address!.isNotEmpty) {
          _addressC.text = result.address!;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_nameC.text.isEmpty || _descC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(lostPetRepositoryProvider);
      await repo.createAlert(
        petName: _nameC.text.trim(),
        petType: _selectedType,
        petDescription: _descC.text.trim(),
        lastSeenLat: _selectedLocation?.latitude ?? 0,
        lastSeenLng: _selectedLocation?.longitude ?? 0,
        petBreed: _breedC.text.isNotEmpty ? _breedC.text.trim() : null,
        lastSeenAddress: _addressC.text.isNotEmpty ? _addressC.text.trim() : null,
        contactPhone: _phoneC.text.isNotEmpty ? _phoneC.text.trim() : null,
        rewardAmount: _rewardC.text.isNotEmpty ? double.tryParse(_rewardC.text) : null,
      );
      ref.invalidate(lostPetAlertsProvider);
      if (mounted) { context.pop(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alert created!'))); }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally { if (mounted) setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Report Lost Pet',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Pet Type', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSizes.sm),
        Wrap(spacing: AppSizes.sm, children: PetType.values.map((t) => ChoiceChip(label: Text('${t.emoji} ${t.label}'), selected: _selectedType == t, onSelected: (_) => setState(() => _selectedType = t))).toList()),
        const SizedBox(height: AppSizes.lg),
        PawTextField(label: 'Pet Name *', controller: _nameC),
        const SizedBox(height: AppSizes.md),
        PawTextField(label: 'Breed', controller: _breedC),
        const SizedBox(height: AppSizes.md),
        PawTextField(label: 'Description *', controller: _descC, maxLines: 3),
        const SizedBox(height: AppSizes.lg),

        // ─── Location Picker ───
        Text('Last Seen Location', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSizes.sm),
        GestureDetector(
          onTap: _pickLocation,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: _selectedLocation != null
                  ? AppColors.primaryContainer.withValues(alpha: 0.15)
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: _selectedLocation != null
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _selectedLocation != null
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedLocation != null
                      ? Icons.location_on_rounded
                      : Icons.add_location_alt_rounded,
                  color: _selectedLocation != null
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLocation != null
                          ? 'Location selected'
                          : 'Tap to pick location on map',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _selectedLocation != null
                                ? AppColors.onSurface
                                : AppColors.onSurfaceVariant,
                          ),
                    ),
                    if (_selectedLocation != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.outline,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onSurfaceVariant,
              ),
            ]),
          ),
        ),
        const SizedBox(height: AppSizes.md),

        PawTextField(label: 'Last Seen Address', controller: _addressC),
        const SizedBox(height: AppSizes.md),
        PawTextField(label: 'Contact Phone', controller: _phoneC, keyboardType: TextInputType.phone),
        const SizedBox(height: AppSizes.md),
        PawTextField(label: 'Reward Amount (₹)', controller: _rewardC, keyboardType: TextInputType.number),
        const SizedBox(height: AppSizes.sectionGap),
        PawGradientButton(label: 'Submit Alert', onPressed: _submit, isLoading: _isLoading),
        const SizedBox(height: AppSizes.xxl),
      ])),
    );
  }
}
