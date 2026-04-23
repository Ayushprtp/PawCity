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
import 'package:pawcity/core/theme/app_colors_extension.dart';

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
      body: Stack(
        children: [
          // ─── Map ───
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 13,
                onTap: (_, __) => _clearDirections(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.pawcity.app',
                  maxZoom: 19,
                ),
                if (_directionsResult != null &&
                    _directionsResult!.polylinePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _directionsResult!.polylinePoints,
                        color: context.colors.primary,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
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
                        if (_locationLoaded)
                          Marker(
                            point: _currentLocation,
                            width: 24,
                            height: 24,
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.colors.secondary,
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
                                          ? context.colors.primary
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
          ),

          // ─── Loading overlay ───
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

          // ─── Top Category chips ───
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),

          // ─── Re-center button ───
          if (_locationLoaded)
            Positioned(
              bottom: _selectedSpot != null ? 360 : 32,
              right: 16,
              child: FloatingActionButton(
                heroTag: 'recenter',
                backgroundColor: context.colors.surfaceContainerLowest,
                onPressed: () => _mapController.move(_currentLocation, 14),
                child: const Icon(Icons.my_location_rounded,
                    color: context.colors.secondary),
              ),
            ),

          // ─── Spot detail / directions panel ───
          if (_selectedSpot != null) _buildDraggableSpotDetails(_selectedSpot!),
        ],
      ),
    );
  }

  Widget _buildDraggableSpotDetails(Spot spot) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
            boxShadow: [
              BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, -4)),
            ],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 16),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.colors.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Details Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      child: Row(
                        children: [
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
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(spot.category.label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: _catColor(spot.category))),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: _clearDirections,
                            icon: const Icon(Icons.close_rounded, size: 24),
                          ),
                        ],
                      ),
                    ),
                    if (spot.address != null) ...[
                      const SizedBox(height: AppSizes.md),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        child: Row(children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: context.colors.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(spot.address!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: context.colors.onSurfaceVariant)),
                          ),
                        ]),
                      ),
                    ],
                    const SizedBox(height: AppSizes.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      child: Row(children: [
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
                              backgroundColor: context.colors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        // View details
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ),
                          onPressed: () => context.push('/veterinarian-profile'),
                          child: const Text('Details'),
                        ),
                      ]),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Photos
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      child: Text("Photos", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    SizedBox(
                      height: 140,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        scrollDirection: Axis.horizontal,
                        itemCount: spot.photoUrls.isNotEmpty ? spot.photoUrls.length : 4,
                        itemBuilder: (context, index) {
                          final imgUrl = spot.photoUrls.isNotEmpty 
                              ? spot.photoUrls[index] 
                              : 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400&q=80&sig=$index';
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSizes.sm),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                              child: Image.network(imgUrl, width: 140, height: 140, fit: BoxFit.cover),
                            ),
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: AppSizes.xl),

                    // Reviews
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                        child: Text("Reviews", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    // mock reviews
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.md),
                          child: Container(
                            padding: const EdgeInsets.all(AppSizes.md),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${index + spot.id.hashCode}'),
                                    ),
                                    const SizedBox(width: AppSizes.sm),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('User ${index + 1}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                          Row(
                                            children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < 4 ? Colors.amber : Colors.grey.shade400)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text('2d ago', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.sm),
                                const Text('Great place! Highly recommended for pets. They really enjoyed the environment and the staff was very friendly.'),
                                const SizedBox(height: AppSizes.sm),
                                SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 2,
                                    itemBuilder: (context, imgIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: AppSizes.sm),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                                          child: Image.network('https://images.unsplash.com/photo-1544568100-847a948585b9?w=200&q=80&sig=$index$imgIndex', width: 80, height: 80, fit: BoxFit.cover),
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(height: AppSizes.xxl),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
          color: context.colors.surfaceContainerLowest,
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
                          ?.copyWith(color: context.colors.onSurfaceVariant)),
              ],
            ),
          ),
          if (spot.rating > 0)
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.star_rounded, size: 14, color: context.colors.amber),
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
        SpotCategory.restaurant => context.colors.restaurant,
        SpotCategory.park => context.colors.park,
        SpotCategory.vet => context.colors.vet,
        SpotCategory.grooming => context.colors.grooming,
        SpotCategory.boarding => context.colors.boarding,
        SpotCategory.petStore => context.colors.petStore,
        _ => context.colors.secondary,
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
