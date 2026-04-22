import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:pawcity/core/constants/app_sizes.dart';
import 'package:pawcity/core/theme/app_colors.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/repositories/spots_repository.dart';
import 'package:pawcity/services/freeroute_service.dart';
import 'package:pawcity/shared/widgets/paw_scaffold.dart';

final _spotsProvider = FutureProvider<List<Spot>>((ref) async {
  return SpotsRepository().fetchSpots();
});

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();

  String _selectedCategory = 'All';
  LatLng _currentLocation = const LatLng(28.6139, 77.2090); // Default: Delhi
  bool _locationLoaded = false;
  bool _loadingLocation = true;

  // Directions state
  Spot? _selectedSpot;
  DirectionsResult? _directionsResult;
  bool _loadingDirections = false;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loadingLocation = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loadingLocation = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _loadingLocation = false);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() {
        _currentLocation = LatLng(pos.latitude, pos.longitude);
        _locationLoaded = true;
        _loadingLocation = false;
      });
      _mapController.move(_currentLocation, 14);
    } catch (_) {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _getDirectionsTo(Spot spot) async {
    setState(() {
      _selectedSpot = spot;
      _loadingDirections = true;
      _directionsResult = null;
    });

    final result = await FreeRouteService.instance.getDirections(
      waypoints: [
        _currentLocation,
        LatLng(spot.lat, spot.lng),
      ],
    );

    setState(() {
      _directionsResult = result;
      _loadingDirections = false;
    });

    // Fit bounds to show the route
    if (result != null && result.polylinePoints.isNotEmpty) {
      final bounds = LatLngBounds.fromPoints(result.polylinePoints);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(60)),
      );
    }
  }

  void _clearDirections() {
    setState(() {
      _selectedSpot = null;
      _directionsResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(_spotsProvider);
    final categories = ['All', ...SpotCategory.values.map((c) => c.label)];

    return PawScaffold(
      title: 'Nearby Places',
      currentNavIndex: 0,
      showBottomNav: false,
      showBackButton: true,
      body: Column(children: [
        // ─── Category chips ───
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSizes.sm),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedCategory = cat);
                  _clearDirections();
                },
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.sm),

        // ─── Map ───
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation,
                    initialZoom: 13,
                    onTap: (_, __) => _clearDirections(),
                  ),
                  children: [
                    // OpenStreetMap tiles
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.pawcity.app',
                      maxZoom: 19,
                    ),

                    // Route polyline
                    if (_directionsResult != null &&
                        _directionsResult!.polylinePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _directionsResult!.polylinePoints,
                            color: AppColors.primary,
                            strokeWidth: 4,
                          ),
                        ],
                      ),

                    // Spot markers
                    spotsAsync.when(
                      loading: () => const MarkerLayer(markers: []),
                      error: (_, __) => const MarkerLayer(markers: []),
                      data: (spots) {
                        final filtered = _selectedCategory == 'All'
                            ? spots
                            : spots
                                .where(
                                    (s) => s.category.label == _selectedCategory)
                                .toList();
                        return MarkerLayer(
                          markers: [
                            // User location marker
                            if (_locationLoaded)
                              Marker(
                                point: _currentLocation,
                                width: 24,
                                height: 24,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x40000000),
                                        blurRadius: 6,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            // Spot markers
                            ...filtered.map(
                              (spot) => Marker(
                                point: LatLng(spot.lat, spot.lng),
                                width: 36,
                                height: 42,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedSpot = spot);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: _selectedSpot?.id == spot.id
                                              ? AppColors.primary
                                              : _catColor(spot.category),
                                          shape: BoxShape.circle,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x33000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Icon(
                                          _catIcon(spot.category),
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                // Loading overlay
                if (_loadingLocation)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x44FFFFFF),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Getting your location...'),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Re-center button
                if (_locationLoaded)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: FloatingActionButton.small(
                      heroTag: 'recenter',
                      backgroundColor: AppColors.surfaceContainerLowest,
                      onPressed: () =>
                          _mapController.move(_currentLocation, 14),
                      child: const Icon(Icons.my_location_rounded,
                          color: AppColors.secondary),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // ─── Spot detail / directions panel ───
        if (_selectedSpot != null) ...[
          const SizedBox(height: AppSizes.sm),
          _buildSpotPanel(_selectedSpot!),
        ],

        // ─── Spot list ───
        if (_selectedSpot == null) ...[
          const SizedBox(height: AppSizes.sm),
          Expanded(
            flex: 2,
            child: spotsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Unable to load places')),
              data: (spots) {
                final filtered = _selectedCategory == 'All'
                    ? spots
                    : spots
                        .where((s) => s.category.label == _selectedCategory)
                        .toList();
                if (filtered.isEmpty) {
                  return const Center(child: Text('No places found'));
                }
                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSizes.sm),
                  itemBuilder: (_, i) {
                    final spot = filtered[i];
                    return _buildSpotTile(spot);
                  },
                );
              },
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildSpotPanel(Spot spot) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _catColor(spot.category).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Center(
                child: Icon(_catIcon(spot.category),
                    color: _catColor(spot.category), size: 24),
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spot.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(spot.category.label,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: _catColor(spot.category))),
                ],
              ),
            ),
            IconButton(
              onPressed: _clearDirections,
              icon: const Icon(Icons.close_rounded, size: 20),
            ),
          ]),
          if (spot.address != null) ...[
            const SizedBox(height: AppSizes.sm),
            Row(children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(spot.address!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
              ),
            ]),
          ],
          const SizedBox(height: AppSizes.md),
          Row(children: [
            // Get directions button
            Expanded(
              child: FilledButton.icon(
                onPressed: _loadingDirections
                    ? null
                    : () => _getDirectionsTo(spot),
                icon: _loadingDirections
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.directions_rounded, size: 18),
                label: Text(
                  _directionsResult != null
                      ? '${_directionsResult!.distanceText} · ${_directionsResult!.durationText}'
                      : 'Get Directions',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            // View details
            OutlinedButton(
              onPressed: () => context.push('/veterinarian-profile'),
              child: const Text('Details'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSpotTile(Spot spot) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedSpot = spot);
        _mapController.move(LatLng(spot.lat, spot.lng), 15);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _catColor(spot.category).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Center(
              child: Icon(_catIcon(spot.category),
                  color: _catColor(spot.category), size: 20),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(spot.name,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (spot.address != null)
                  Text(spot.address!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          if (spot.rating > 0)
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.amber),
              const SizedBox(width: 2),
              Text(spot.rating.toStringAsFixed(1),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ]),
        ]),
      ),
    );
  }

  Color _catColor(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => AppColors.restaurant,
        SpotCategory.park => AppColors.park,
        SpotCategory.vet => AppColors.vet,
        SpotCategory.grooming => AppColors.grooming,
        SpotCategory.boarding => AppColors.boarding,
        SpotCategory.petStore => AppColors.petStore,
        _ => AppColors.secondary,
      };

  IconData _catIcon(SpotCategory c) => switch (c) {
        SpotCategory.restaurant => Icons.restaurant_rounded,
        SpotCategory.park => Icons.park_rounded,
        SpotCategory.vet => Icons.local_hospital_rounded,
        SpotCategory.grooming => Icons.content_cut_rounded,
        SpotCategory.boarding => Icons.home_rounded,
        SpotCategory.petStore => Icons.store_rounded,
        _ => Icons.place_rounded,
      };
}
