import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/lost_pet_provider.dart';
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

  @override
  void dispose() {
    _nameC.dispose(); _breedC.dispose(); _descC.dispose();
    _addressC.dispose(); _phoneC.dispose(); _rewardC.dispose();
    super.dispose();
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
        lastSeenLat: 0, lastSeenLng: 0, // TODO: use location picker
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
