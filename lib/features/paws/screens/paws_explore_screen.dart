import 'dart:async';
import 'dart:io';
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
import 'package:url_launcher/url_launcher.dart';

final _allSpotsProvider = FutureProvider<List<Spot>>((ref) async {
  return SpotsRepository().fetchSpots();
});

class PawsExploreScreen extends ConsumerStatefulWidget {
  const PawsExploreScreen({super.key});
  @override
  ConsumerState<PawsExploreScreen> createState() => _PawsExploreScreenState();
}

class _PawsExploreScreenState extends ConsumerState<PawsExploreScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchC = TextEditingController();

  String _selectedCategory = 'All';
  bool _showList = false;
  LatLng _userLocation = const LatLng(28.6139, 77.2090);
  bool _locationLoaded = false;

  Spot? _selectedSpot;
  DirectionsResult? _directions;
  bool _loadingDir = false;

  List<GeocodingResult> _searchResults = [];
  bool _showSearch = false;
  Timer? _debounce;

  static const _categories = [
    _CatDef('All', Icons.apps_rounded, AppColors.secondary),
    _CatDef('Park', Icons.park_rounded, AppColors.park),
    _CatDef('Vet', Icons.local_hospital_rounded, AppColors.vet),
    _CatDef('Cafe', Icons.local_cafe_rounded, Color(0xFF8D6E63)),
    _CatDef('Restaurant', Icons.restaurant_rounded, AppColors.restaurant),
    _CatDef('Grooming', Icons.content_cut_rounded, AppColors.grooming),
    _CatDef('Pet Store', Icons.store_rounded, AppColors.petStore),
    _CatDef('Boarding', Icons.home_rounded, AppColors.boarding),
    _CatDef('Hotel', Icons.hotel_rounded, AppColors.secondary),
    _CatDef('Beach', Icons.beach_access_rounded, Color(0xFF0097A7)),
    _CatDef('Trail', Icons.hiking_rounded, Color(0xFF558B2F)),
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    _searchC.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      final perm = await Geolocator.checkPermission();
      final p = perm == LocationPermission.denied
          ? await Geolocator.requestPermission()
          : perm;
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() { _userLocation = LatLng(pos.latitude, pos.longitude); _locationLoaded = true; });
      _mapController.move(_userLocation, 14);
    } catch (_) {}
  }

  Future<void> _getDirections(Spot spot) async {
    setState(() { _loadingDir = true; _directions = null; });
    final r = await FreeRouteService.instance.getDirections(waypoints: [_userLocation, LatLng(spot.lat, spot.lng)]);
    setState(() { _directions = r; _loadingDir = false; });
    if (r != null && r.polylinePoints.isNotEmpty) {
      _mapController.fitCamera(CameraFit.bounds(bounds: LatLngBounds.fromPoints(r.polylinePoints), padding: const EdgeInsets.all(60)));
    }
  }

  void _onSearch(String q) {
    _debounce?.cancel();
    if (q.trim().isEmpty) { setState(() { _searchResults = []; _showSearch = false; }); return; }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final r = await FreeRouteService.instance.geocodeSearch(q);
      if (mounted) setState(() { _searchResults = r; _showSearch = r.isNotEmpty; });
    });
  }

  void _selectResult(GeocodingResult r) {
    if (r.position == null) return;
    setState(() { _showSearch = false; _searchC.clear(); });
    _mapController.move(r.position!, 16);
  }

  List<Spot> _filter(List<Spot> spots) {
    if (_selectedCategory == 'All') return spots;
    return spots.where((s) => s.category.label == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final spotsAsync = ref.watch(_allSpotsProvider);
    return PawScaffold(
      title: 'Paws Explore',
      currentNavIndex: 2,
      showBottomNav: true,
      body: Column(children: [
        // ─── Search ───
        _buildSearchBar(),
        const SizedBox(height: AppSizes.sm),
        // ─── Category chips ───
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final c = _categories[i];
              final sel = _selectedCategory == c.label;
              return GestureDetector(
                onTap: () => setState(() { _selectedCategory = c.label; _selectedSpot = null; _directions = null; }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sel ? c.color : AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(color: sel ? c.color : AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(c.icon, size: 16, color: sel ? Colors.white : c.color),
                    const SizedBox(width: 4),
                    Text(c.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : AppColors.onSurface)),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        // ─── Map / List toggle ───
        Expanded(
          child: Stack(children: [
            // Map
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: spotsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Unable to load spots')),
                data: (spots) {
                  final filtered = _filter(spots);
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(initialCenter: _userLocation, initialZoom: 13, onTap: (_, __) => setState(() { _selectedSpot = null; _directions = null; })),
                    children: [
                      TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.pawcity.app', maxZoom: 19),
                      if (_directions != null && _directions!.polylinePoints.isNotEmpty)
                        PolylineLayer(polylines: [Polyline(points: _directions!.polylinePoints, color: AppColors.primary, strokeWidth: 4)]),
                      MarkerLayer(markers: [
                        if (_locationLoaded)
                          Marker(point: _userLocation, width: 22, height: 22, child: Container(
                            decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 6)]),
                          )),
                        ...filtered.map((s) => Marker(
                          point: LatLng(s.lat, s.lng), width: 34, height: 40,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedSpot = s),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: _selectedSpot?.id == s.id ? AppColors.primary : _catColor(s.category), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 2))]),
                              child: Icon(_catIcon(s.category), color: Colors.white, size: 15),
                            ),
                          ),
                        )),
                      ]),
                    ],
                  );
                },
              ),
            ),

            // Spot count badge
            if (spotsAsync.hasValue)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(AppSizes.radiusFull), boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 8)]),
                child: Text('${_filter(spotsAsync.value!).length} spots', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
              )),

            // Toggle list/map button
            Positioned(top: 8, right: 8, child: FloatingActionButton.small(
              heroTag: 'toggle_list',
              backgroundColor: AppColors.surfaceContainerLowest,
              onPressed: () => setState(() => _showList = !_showList),
              child: Icon(_showList ? Icons.map_rounded : Icons.list_rounded, color: AppColors.primary, size: 20),
            )),

            // Re-center
            if (_locationLoaded && !_showList)
              Positioned(bottom: _selectedSpot != null ? 160 : 8, right: 8, child: FloatingActionButton.small(
                heroTag: 'recenter_paws',
                backgroundColor: AppColors.surfaceContainerLowest,
                onPressed: () => _mapController.move(_userLocation, 14),
                child: const Icon(Icons.my_location_rounded, color: AppColors.secondary, size: 20),
              )),

            // List overlay
            if (_showList)
              Positioned.fill(child: Container(
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest.withValues(alpha: 0.97), borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
                child: spotsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(child: Text('Error')),
                  data: (spots) {
                    final filtered = _filter(spots);
                    if (filtered.isEmpty) return const Center(child: Text('No spots found'));
                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSizes.md),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.sm),
                      itemBuilder: (_, i) => _spotTile(filtered[i]),
                    );
                  },
                ),
              )),

            // Selected spot panel
            if (_selectedSpot != null && !_showList)
              Positioned(bottom: 0, left: 0, right: 0, child: _spotPanel(_selectedSpot!)),

            // Search results dropdown
            if (_showSearch)
              Positioned(top: -46, left: 0, right: 0, child: Container(
                margin: const EdgeInsets.only(top: 52),
                constraints: const BoxConstraints(maxHeight: 180),
                decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(AppSizes.radiusMd), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 12)]),
                child: ListView.builder(
                  shrinkWrap: true, padding: const EdgeInsets.all(4),
                  itemCount: _searchResults.length,
                  itemBuilder: (_, i) {
                    final r = _searchResults[i];
                    return ListTile(dense: true, leading: const Icon(Icons.place_rounded, size: 16, color: AppColors.primary), title: Text(r.label, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)), onTap: () => _selectResult(r));
                  },
                ),
              )),
          ]),
        ),
      ]),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusFull), border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3))),
      child: TextField(
        controller: _searchC,
        onChanged: _onSearch,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search places, parks, vets...',
          hintStyle: TextStyle(fontSize: 13, color: AppColors.outline),
          prefixIcon: const Icon(Icons.search_rounded, size: 18),
          suffixIcon: _searchC.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear_rounded, size: 16), onPressed: () { _searchC.clear(); setState(() { _searchResults = []; _showSearch = false; }); }) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _spotPanel(Spot spot) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 200) {
          setState(() { _selectedSpot = null; _directions = null; });
        }
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
        padding: const EdgeInsets.only(top: AppSizes.cardPadding, left: AppSizes.cardPadding, right: AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
          boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 12, offset: Offset(0, -2))],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Drag handle indicator
          Container(
            width: 40, height: 4, margin: const EdgeInsets.only(bottom: AppSizes.md),
            decoration: BoxDecoration(color: AppColors.outlineVariant.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2)),
          ),
          Row(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: _catColor(spot.category).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.radiusSm)),
              child: Center(child: Icon(_catIcon(spot.category), color: _catColor(spot.category), size: 22))),
            const SizedBox(width: AppSizes.md),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(spot.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: _catColor(spot.category).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppSizes.radiusFull)),
                  child: Text(spot.category.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _catColor(spot.category)))),
                if (spot.rating > 0) ...[const SizedBox(width: 6), const Icon(Icons.star_rounded, size: 12, color: AppColors.amber), Text(' ${spot.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700))],
              ]),
            ])),
            IconButton(onPressed: () => setState(() { _selectedSpot = null; _directions = null; }), icon: const Icon(Icons.close_rounded, size: 18)),
          ]),
          if (spot.address != null) Padding(padding: const EdgeInsets.only(top: 8, bottom: 4), child: Row(children: [
            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.onSurfaceVariant), const SizedBox(width: 4),
            Expanded(child: Text(spot.address!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant))),
          ])),
          const SizedBox(height: AppSizes.md),
          
          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(
                icon: Icons.directions_rounded, 
                label: 'Directions', 
                color: AppColors.primary,
                isLoading: _loadingDir,
                onTap: () => _openExternalMap(spot),
              ),
              _actionButton(
                icon: Icons.rate_review_rounded, 
                label: 'Reviews', 
                color: AppColors.secondary,
                onTap: () {}, // Reviews now shown in scroll area
              ),
              _actionButton(
                icon: Icons.photo_library_rounded, 
                label: 'Photos', 
                color: AppColors.tertiary,
                onTap: () {},
              ),
            ],
          ),
          
          if (_directions != null) ...[
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_walk_rounded, color: AppColors.primary, size: 16),
                  const SizedBox(width: AppSizes.xs),
                  Text('${_directions!.distanceText} (${_directions!.durationText})', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: AppSizes.md),
          const Divider(height: 1),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
              children: [
                Text('User Reviews', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSizes.sm),
                // Mock reviews
                _reviewTile('Alex D.', 'Great park for dogs, lots of open space! 🐶', 5.0),
                _reviewTile('Sarah M.', 'Very clean, but can get crowded on weekends.', 4.0),
                _reviewTile('Mike T.', 'My dog loves this place. Highly recommend!', 5.0),
                const SizedBox(height: AppSizes.xl),
              ],
            ),
          ),
        ]),
      ),
    );
  }
  
  Widget _reviewTile(String name, String comment, double rating) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 12, backgroundColor: AppColors.primary.withValues(alpha: 0.2), child: Text(name[0], style: const TextStyle(fontSize: 10, color: AppColors.primary))),
                const SizedBox(width: 8),
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const Spacer(),
                const Icon(Icons.star_rounded, size: 14, color: AppColors.amber),
                Text(' $rating', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Text(comment, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
  
  Future<void> _openExternalMap(Spot spot) async {
    // Show dialog to ask
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Get Directions'),
        content: const Text('Open directions in an external map app or show path on map?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'internal'), child: const Text('Show on Map')),
          FilledButton(onPressed: () => Navigator.pop(ctx, 'external'), child: const Text('Open Maps App')),
        ],
      )
    );
    
    if (result == 'internal') {
      _getDirections(spot);
    } else if (result == 'external') {
      final lat = spot.lat;
      final lng = spot.lng;
      final url = Platform.isIOS 
          ? 'http://maps.apple.com/?daddr=$lat,$lng'
          : 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open Maps')));
      }
    }
  }

  Widget _actionButton({required IconData icon, required String label, required Color color, bool isLoading = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isLoading 
                ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: color))
                : Icon(icon, color: color, size: 22),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _spotTile(Spot spot) {
    return GestureDetector(
      onTap: () { setState(() { _selectedSpot = spot; _showList = false; _directions = null; }); _mapController.move(LatLng(spot.lat, spot.lng), 15); },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: _catColor(spot.category).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(_catIcon(spot.category), color: _catColor(spot.category), size: 18)),
          const SizedBox(width: AppSizes.md),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(spot.name, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            if (spot.address != null) Text(spot.address!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11)),
          ])),
          if (spot.rating > 0) Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.star_rounded, size: 13, color: AppColors.amber),
            Text(' ${spot.rating.toStringAsFixed(1)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          ]),
        ]),
      ),
    );
  }

  Color _catColor(SpotCategory c) => switch (c) { SpotCategory.restaurant => AppColors.restaurant, SpotCategory.cafe => const Color(0xFF8D6E63), SpotCategory.park => AppColors.park, SpotCategory.vet => AppColors.vet, SpotCategory.grooming => AppColors.grooming, SpotCategory.boarding => AppColors.boarding, SpotCategory.petStore => AppColors.petStore, SpotCategory.beach => const Color(0xFF0097A7), SpotCategory.trail => const Color(0xFF558B2F), _ => AppColors.secondary };
  IconData _catIcon(SpotCategory c) => switch (c) { SpotCategory.restaurant => Icons.restaurant_rounded, SpotCategory.cafe => Icons.local_cafe_rounded, SpotCategory.park => Icons.park_rounded, SpotCategory.vet => Icons.local_hospital_rounded, SpotCategory.grooming => Icons.content_cut_rounded, SpotCategory.boarding => Icons.home_rounded, SpotCategory.petStore => Icons.store_rounded, SpotCategory.beach => Icons.beach_access_rounded, SpotCategory.trail => Icons.hiking_rounded, _ => Icons.place_rounded };
}

class _CatDef {
  const _CatDef(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}
