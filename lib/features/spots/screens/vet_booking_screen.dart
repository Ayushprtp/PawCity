import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_effects.dart';
import 'package:pawcity/shared/widgets/paw_asym_card.dart';
import 'package:pawcity/shared/widgets/paw_gradient_button.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawcity/core/theme/app_colors_extension.dart';

class VetBookingScreen extends ConsumerStatefulWidget {
  const VetBookingScreen({super.key});

  @override
  ConsumerState<VetBookingScreen> createState() => _VetBookingScreenState();
}

class _VetBookingScreenState extends ConsumerState<VetBookingScreen> {
  LatLng? _currentLocation;
  int _selectedDayIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(pos.latitude, pos.longitude);
        });
      }
    } catch (e) {
      // Fallback location if permission denied
      if (mounted) {
        setState(() {
          _currentLocation = const LatLng(40.7128, -74.0060); // NY
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const days = [
      ('Today', '14', true),
      ('Wed', '15', false),
      ('Thu', '16', false),
      ('Fri', '17', false),
    ];

    const doctors = [
      _Doctor(
        name: 'Dr. Sarah Jenkins',
        specialty: 'General Practice',
        distance: '1.2 km',
        slot: '10:30 AM',
        rating: '4.9',
        reviews: '124',
      ),
      _Doctor(
        name: 'Dr. Marcus Wei',
        specialty: 'Specialty Surgery',
        distance: '2.5 km',
        slot: '11:15 AM',
        rating: '4.8',
        reviews: '89',
      ),
    ];

    const clinics = [
      _Clinic(
        name: 'City Paws Clinic',
        detail: '3.1 km away • Open until 8PM',
        tag: 'AAHA Certified',
      ),
      _Clinic(
        name: 'Riverdale Hospital',
        detail: '4.2 km away • 24/7 Emergency',
        tag: 'Emergency',
      ),
    ];

    return PawScaffold(
      title: 'Vet Booking',
      currentNavIndex: 3,
      showBackButton: true,
      actions: [
        IconButton(
          onPressed: () => context.push('/veterinarian-profile'),
          icon: const Icon(Icons.person_search_rounded),
        ),
      ],
      body: ListView(
        children: [
          Text(
            'Find Care for Luna',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Book appointments with top-rated professionals nearby.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          SizedBox(
            height: 86,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: days.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (context, index) {
                if (index == days.length) {
                  return Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: const Icon(Icons.calendar_month_rounded),
                  );
                }

                final day = days[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: Container(
                    width: 70,
                    decoration: BoxDecoration(
                      color: _selectedDayIndex == index
                          ? context.colors.secondaryContainer
                          : context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.$1,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: _selectedDayIndex == index
                                    ? context.colors.secondary
                                    : context.colors.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          day.$2,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          _mapCard(context),
          const SizedBox(height: AppSizes.sectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Available Now',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Filters')),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            height: 228,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.md),
              itemBuilder: (context, index) => _doctorCard(context, doctors[index]),
            ),
          ),
          const SizedBox(height: AppSizes.sectionGap),
          Text('Top Rated Clinics', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.md),
          for (var i = 0; i < clinics.length; i++) ...[
            _clinicTile(context, clinics[i]),
            if (i != clinics.length - 1) const SizedBox(height: AppSizes.sm),
          ],
        ],
      ),
    );
  }

  Widget _mapCard(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: AppEffects.asymCardRadius,
        boxShadow: AppEffects.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (_currentLocation != null)
            FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation!,
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.pawcity.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Colors.blue,
                        size: 30,
                      ),
                    ),
                    // Dummy vet marker
                    Marker(
                      point: LatLng(_currentLocation!.latitude + 0.005, _currentLocation!.longitude + 0.005),
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.local_hospital_rounded,
                        color: context.colors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            const Center(child: CircularProgressIndicator()),
          Positioned(
            left: AppSizes.lg,
            right: AppSizes.lg,
            bottom: AppSizes.lg,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerLowest.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                    child: Icon(Icons.place_rounded, color: context.colors.primary),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Map',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '8 certified vets nearby',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorCard(BuildContext context, _Doctor doctor) {
    return Container(
      width: 294,
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: AppEffects.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: const Icon(Icons.medical_services_rounded),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    Text(
                      '${doctor.specialty} • ${doctor.distance}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            color: context.colors.tertiaryContainer, size: 16),
                        const SizedBox(width: AppSizes.xxs),
                        Text(
                          '${doctor.rating} (${doctor.reviews})',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Slot',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.colors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: AppSizes.xxs),
                    Text(
                      doctor.slot,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 112,
                child: PawGradientButton(
                  label: 'Book',
                  onPressed: () => context.push('/veterinarian-profile'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _clinicTile(BuildContext context, _Clinic clinic) {
    return PawAsymCard(
      onTap: () => context.push('/veterinarian-profile'),
      backgroundColor: context.colors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: const Icon(Icons.home_repair_service_rounded),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clinic.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSizes.xxs),
                Text(clinic.detail, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSizes.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: AppSizes.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(
                    clinic.tag,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _Doctor {
  const _Doctor({
    required this.name,
    required this.specialty,
    required this.distance,
    required this.slot,
    required this.rating,
    required this.reviews,
  });

  final String name;
  final String specialty;
  final String distance;
  final String slot;
  final String rating;
  final String reviews;
}

class _Clinic {
  const _Clinic({
    required this.name,
    required this.detail,
    required this.tag,
  });

  final String name;
  final String detail;
  final String tag;
}
