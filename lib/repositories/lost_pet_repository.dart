import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/lost_pet_alert.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LostPetRepository {
  LostPetRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<LostPetAlert>> fetchAlerts({bool activeOnly = true}) async {
    try {
      var query = _client
          .from('lost_pet_alerts')
          .select('*, profiles!lost_pet_alerts_user_id_fkey(display_name, avatar_url)');
      if (activeOnly) {
        query = query.eq('is_found', false);
      }
      final response = await query.order('created_at', ascending: false);
      return (response as List).map((row) {
        final map = Map<String, dynamic>.from(row as Map);
        final profile = map.remove('profiles') as Map<String, dynamic>?;
        if (profile != null) {
          map['owner_name'] = profile['display_name'];
          map['owner_avatar_url'] = profile['avatar_url'];
        }
        return LostPetAlert.fromJson(map);
      }).toList();
    } catch (_) {
      throw const NetworkException('Unable to load lost pet alerts.');
    }
  }

  Future<LostPetAlert> createAlert({
    required String petName,
    required PetType petType,
    required String petDescription,
    required double lastSeenLat,
    required double lastSeenLng,
    String? petBreed,
    String? petPhotoUrl,
    String? lastSeenAddress,
    DateTime? lastSeenAt,
    String? contactPhone,
    double? rewardAmount,
    String? petId,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final data = <String, dynamic>{
        'user_id': userId,
        'pet_name': petName,
        'pet_type': petType.name,
        'pet_description': petDescription,
        'last_seen_lat': lastSeenLat,
        'last_seen_lng': lastSeenLng,
        if (petBreed != null) 'pet_breed': petBreed,
        if (petPhotoUrl != null) 'pet_photo_url': petPhotoUrl,
        if (lastSeenAddress != null) 'last_seen_address': lastSeenAddress,
        if (lastSeenAt != null) 'last_seen_at': lastSeenAt.toIso8601String(),
        if (contactPhone != null) 'contact_phone': contactPhone,
        if (rewardAmount != null) 'reward_amount': rewardAmount,
        if (petId != null) 'pet_id': petId,
      };

      final response = await _client
          .from('lost_pet_alerts')
          .insert(data)
          .select()
          .single();
      return LostPetAlert.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to create alert.');
    }
  }

  Future<void> markAsFound(String alertId) async {
    try {
      await _client.from('lost_pet_alerts').update({
        'is_found': true,
        'found_at': DateTime.now().toIso8601String(),
      }).eq('id', alertId);
    } catch (_) {
      throw const NetworkException('Unable to update alert.');
    }
  }
}
