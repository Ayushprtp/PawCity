import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:uuid/uuid.dart';

class AddPetScreen extends ConsumerStatefulWidget {
  const AddPetScreen({super.key});

  @override
  ConsumerState<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends ConsumerState<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedSpecies = 'Dog';

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      final newPet = Pet(
        id: const Uuid().v4(),
        userId: 'local_user', // Local for now
        name: _nameController.text.trim(),
        type: PetType.values.firstWhere((e) => e.label.toLowerCase() == _selectedSpecies.toLowerCase(), orElse: () => PetType.other),
        breed: _breedController.text.trim(),
        dateOfBirth: DateTime.now().subtract(
          Duration(days: (double.tryParse(_ageController.text) ?? 0 * 365).toInt()),
        ),
        weightKg: double.tryParse(_weightController.text) ?? 0.0,
      );

      // We should ideally update the provider, but the provider is currently fetching from Supabase.
      // We will need to adjust the pet provider to support optimistic updates or local-first.
      // For now, let's just go back. We will integrate Supabase shortly.
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Add a Pet',
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.lg),
              _buildSectionTitle('Basic Info'),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Pet Name',
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (val) => val!.isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<String>(
                value: _selectedSpecies,
                decoration: const InputDecoration(
                  labelText: 'Species',
                  prefixIcon: Icon(Icons.category),
                ),
                items: const [
                  DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                  DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                  DropdownMenuItem(value: 'Bird', child: Text('Bird')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSpecies = val);
                },
              ),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  prefixIcon: Icon(Icons.merge_type),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              _buildSectionTitle('Details'),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Age (Years)',
                        prefixIcon: Icon(Icons.cake),
                      ),
                      validator: (val) => val!.isEmpty ? 'Age required' : null,
                    ),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Weight (kg)',
                        prefixIcon: Icon(Icons.scale),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.xxl),
              PawGradientButton(
                label: 'Save Pet',
                onPressed: _savePet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
    );
  }
}
