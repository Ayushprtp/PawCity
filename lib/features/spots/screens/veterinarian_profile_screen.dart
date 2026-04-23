import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/core/theme/app_gradients.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/providers/pet_provider.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:pawcity/services/supabase_service.dart';

class VeterinarianProfileScreen extends ConsumerStatefulWidget {
  const VeterinarianProfileScreen({super.key});

  @override
  ConsumerState<VeterinarianProfileScreen> createState() => _VetProfileState();
}

class _VetProfileState extends ConsumerState<VeterinarianProfileScreen> {
  bool _isBooking = false;

  Future<void> _bookAppointment() async {
    // Show booking dialog
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _BookingSheet(),
    );

    if (result == null || !mounted) return;

    setState(() => _isBooking = true);
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) throw Exception('Not signed in');

      await SupabaseService.client.from('appointments').insert({
        'user_id': userId,
        'title': result['service'],
        'service_type': result['serviceType'],
        'date': result['date'],
        'status': 'upcoming',
        'clinic_name': 'PawCare Vet Clinic',
        'pet_name': result['petName'],
      });

      if (mounted) {
        context.push('/booking-confirmation');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PawScaffold(
      title: 'Veterinarian',
      showBottomNav: false,
      showBackButton: true,
      body: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Hero Card
        Container(
          width: double.infinity, padding: const EdgeInsets.all(AppSizes.xl),
          decoration: BoxDecoration(gradient: AppGradients.dashboardHero, borderRadius: AppEffects.asymCardRadius, boxShadow: AppEffects.softShadow),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const CircleAvatar(radius: 32, backgroundColor: Colors.white24, child: Icon(Icons.local_hospital_rounded, size: 32, color: Colors.white)),
              const SizedBox(width: AppSizes.lg),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('PawCare Vet Clinic', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSizes.xs),
                Text('Veterinary Clinic', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ])),
            ]),
            const SizedBox(height: AppSizes.lg),
            Row(children: [
              _heroBadge(context, Icons.star_rounded, '4.8', AppColors.amber),
              const SizedBox(width: AppSizes.md),
              _heroBadge(context, Icons.reviews_rounded, '120+ reviews', Colors.white38),
              const SizedBox(width: AppSizes.md),
              _heroBadge(context, Icons.verified_rounded, 'Verified', AppColors.severityLow),
            ]),
          ]),
        ),
        const SizedBox(height: AppSizes.sectionGap),

        // Info Cards
        Text('Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        PawAsymCard(child: Column(children: [
          _infoRow(context, Icons.location_on_rounded, 'Address', '123 Pet Street, Mumbai'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.access_time_rounded, 'Hours', 'Mon-Sat: 9AM - 8PM'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.phone_rounded, 'Phone', '+91 9876543210'),
          const Divider(height: AppSizes.lg),
          _infoRow(context, Icons.pets_rounded, 'Pet Policy', 'All pets welcome'),
        ])),
        const SizedBox(height: AppSizes.sectionGap),

        // Services
        Text('Services', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSizes.md),
        Wrap(spacing: AppSizes.sm, runSpacing: AppSizes.sm, children: ['General Checkup', 'Vaccination', 'Surgery', 'Dental Care', 'Emergency', 'Lab Tests'].map((s) =>
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
            decoration: BoxDecoration(color: AppColors.secondaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
            child: Text(s, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.secondary)),
          ),
        ).toList()),
        const SizedBox(height: AppSizes.sectionGap),

        // Book button
        PawGradientButton(
          label: 'Book Appointment',
          isLoading: _isBooking,
          onPressed: _bookAppointment,
        ),
        const SizedBox(height: AppSizes.md),
        OutlinedButton.icon(
          onPressed: () => context.push('/write-review'),
          icon: const Icon(Icons.rate_review_rounded),
          label: const Text('Write a Review'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        ),
        const SizedBox(height: AppSizes.xxl),
      ])),
    );
  }

  Widget _heroBadge(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.xs),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 14, color: color), const SizedBox(width: AppSizes.xs), Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600))]),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 18, color: AppColors.secondary),
      const SizedBox(width: AppSizes.md),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ])),
    ]);
  }
}

// ─── Booking Bottom Sheet ───
class _BookingSheet extends ConsumerStatefulWidget {
  const _BookingSheet();

  @override
  ConsumerState<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<_BookingSheet> {
  String _selectedService = 'General Checkup';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String _petName = '';

  final _services = [
    ('General Checkup', 'vet'),
    ('Vaccination', 'vaccination'),
    ('Grooming', 'grooming'),
    ('Dental Care', 'vet'),
    ('Surgery Consultation', 'vet'),
  ];

  @override
  Widget build(BuildContext context) {
    final petsAsync = ref.watch(userPetsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.xl,
        right: AppSizes.xl,
        top: AppSizes.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text('Book Appointment', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.xl),

          // Pet selection
          Text('Select Pet', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSizes.sm),
          petsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Could not load pets'),
            data: (pets) {
              if (pets.isEmpty) {
                return const Text('No pets added yet. Add a pet first.');
              }
              if (_petName.isEmpty) {
                _petName = pets.first.name;
              }
              return DropdownButtonFormField<String>(
                value: _petName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: pets.map((p) => DropdownMenuItem(value: p.name, child: Text('${p.type.emoji} ${p.name}'))).toList(),
                onChanged: (v) { if (v != null) setState(() => _petName = v); },
              );
            },
          ),
          const SizedBox(height: AppSizes.lg),

          // Service selection
          Text('Service', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: _services.map((s) {
              final isActive = _selectedService == s.$1;
              return ChoiceChip(
                label: Text(s.$1),
                selected: isActive,
                selectedColor: AppColors.primaryContainer,
                onSelected: (_) => setState(() => _selectedService = s.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.lg),

          // Date & Time
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    if (picked != null) setState(() => _selectedDate = picked);
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                    if (picked != null) setState(() => _selectedTime = picked);
                  },
                  icon: const Icon(Icons.access_time_rounded, size: 16),
                  label: Text(_selectedTime.format(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xl),

          PawGradientButton(
            label: 'Confirm Booking',
            onPressed: () {
              final serviceType = _services.firstWhere((s) => s.$1 == _selectedService).$2;
              final dateTime = DateTime(
                _selectedDate.year, _selectedDate.month, _selectedDate.day,
                _selectedTime.hour, _selectedTime.minute,
              );
              Navigator.pop(context, {
                'service': _selectedService,
                'serviceType': serviceType,
                'date': dateTime.toIso8601String(),
                'petName': _petName,
              });
            },
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}