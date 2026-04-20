import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/spot.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SpotsRepository {
  SpotsRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<Spot>> fetchNearbySpots({
    required double lat,
    required double lng,
    int radiusMeters = 5000,
    SpotCategory? category,
  }) async {
    try {
      final response = await _client.rpc(
        'spots_within_radius',
        params: {
          'user_lat': lat,
          'user_lng': lng,
          'radius_meters': radiusMeters,
          'category_filter': category?.dbValue,
        },
      );

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>();
      return rows.map(Spot.fromJson).toList();
    } catch (_) {
      throw const NetworkException('Unable to load nearby spots.');
    }
  }

  Future<List<Spot>> fetchSpots({
    SpotCategory? category,
    String? city,
    String? query,
  }) async {
    try {
      var queryBuilder = _client.from('spots').select().eq('is_active', true);

      if (category != null) {
        queryBuilder = queryBuilder.eq('category', category.dbValue);
      }
      if (city != null && city.trim().isNotEmpty) {
        queryBuilder = queryBuilder.ilike('city', city.trim());
      }
      if (query != null && query.trim().isNotEmpty) {
        final value = query.trim();
        queryBuilder = queryBuilder
            .or('name.ilike.%$value%,description.ilike.%$value%,address.ilike.%$value%');
      }

      final response = await queryBuilder.order('created_at', ascending: false);
      final rows = response.cast<Map<String, dynamic>>();
      return rows.map(Spot.fromJson).toList();
    } catch (_) {
      throw const NetworkException('Unable to load spots right now.');
    }
  }
}
