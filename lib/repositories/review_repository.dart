import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/review.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRepository {
  ReviewRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<Review>> fetchReviewsForSpot(String spotId) async {
    try {
      final response = await _client
          .from('reviews')
          .select('*, profiles!reviews_user_id_fkey(display_name, avatar_url)')
          .eq('spot_id', spotId)
          .eq('is_flagged', false)
          .order('created_at', ascending: false);
      return (response as List).map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        final profile = map.remove('profiles') as Map<String, dynamic>?;
        if (profile != null) {
          map['user_name'] = profile['display_name'];
          map['user_avatar_url'] = profile['avatar_url'];
        }
        return Review.fromJson(map);
      }).toList();
    } catch (_) {
      throw const NetworkException('Unable to load reviews.');
    }
  }

  Future<List<Review>> fetchUserReviews() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client
          .from('reviews')
          .select('*, spots!reviews_spot_id_fkey(name)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return (response as List).map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        final spot = map.remove('spots') as Map<String, dynamic>?;
        if (spot != null) {
          map['spot_name'] = spot['name'];
        }
        return Review.fromJson(map);
      }).toList();
    } catch (_) {
      throw const NetworkException('Unable to load your reviews.');
    }
  }

  Future<Review> createReview({
    required String spotId,
    required int rating,
    String? comment,
    List<String>? photoUrls,
    String? petId,
    String? petType,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final data = <String, dynamic>{
        'spot_id': spotId,
        'user_id': userId,
        'rating': rating,
        if (comment != null) 'comment': comment,
        if (photoUrls != null) 'photo_urls': photoUrls,
        if (petId != null) 'pet_id': petId,
        if (petType != null) 'pet_type': petType,
        'visited_at': DateTime.now().toIso8601String().split('T').first,
      };

      final response =
          await _client.from('reviews').insert(data).select().single();
      return Review.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to submit review.');
    }
  }
}
