import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PetRepository {
  PetRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<List<Pet>> fetchUserPets() async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client
          .from('pets')
          .select()
          .eq('user_id', userId)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      return (response as List)
          .cast<Map<String, dynamic>>()
          .map(Pet.fromJson)
          .toList();
    } catch (_) {
      throw const NetworkException('Unable to load your pets.');
    }
  }

  Future<Pet> fetchPet(String petId) async {
    try {
      final response =
          await _client.from('pets').select().eq('id', petId).single();
      return Pet.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to load pet details.');
    }
  }

  Future<Pet> createPet({
    required String name,
    required PetType type,
    String? breed,
    DateTime? dateOfBirth,
    String? gender,
    double? weightKg,
    String? color,
    String? photoUrl,
    String? microchipId,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final data = <String, dynamic>{
        'user_id': userId,
        'name': name,
        'type': type.name,
        if (breed != null) 'breed': breed,
        if (dateOfBirth != null)
          'date_of_birth': dateOfBirth.toIso8601String().split('T').first,
        if (gender != null) 'gender': gender,
        if (weightKg != null) 'weight_kg': weightKg,
        if (color != null) 'color': color,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (microchipId != null) 'microchip_id': microchipId,
      };

      final response =
          await _client.from('pets').insert(data).select().single();
      return Pet.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to add pet.');
    }
  }

  Future<Pet> updatePet(String petId, Map<String, dynamic> updates) async {
    try {
      final response = await _client
          .from('pets')
          .update(updates)
          .eq('id', petId)
          .select()
          .single();
      return Pet.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to update pet.');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _client
          .from('pets')
          .update({'is_active': false}).eq('id', petId);
    } catch (_) {
      throw const NetworkException('Unable to remove pet.');
    }
  }
}
