import 'dart:typed_data';

import 'package:pawcity/core/exceptions/app_exception.dart';
import 'package:pawcity/models/profile.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository {
  ProfileRepository({SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final SupabaseClient _client;

  Future<Profile?> fetchCurrentProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response =
          await _client.from('profiles').select().eq('id', userId).single();
      return Profile.fromJson(response);
    } catch (_) {
      return null;
    }
  }

  Future<Profile> fetchProfile(String userId) async {
    try {
      final response =
          await _client.from('profiles').select().eq('id', userId).single();
      return Profile.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to load profile.');
    }
  }

  Future<Profile> updateProfile({
    String? displayName,
    String? bio,
    String? city,
    String? avatarUrl,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (displayName != null) updates['display_name'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (city != null) updates['city'] = city;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _client
          .from('profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();
      return Profile.fromJson(response);
    } catch (_) {
      throw const NetworkException('Unable to update profile.');
    }
  }

  Future<String> uploadAvatar(Uint8List fileBytes, String fileName) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final ext = fileName.split('.').last;
      final path = 'avatars/$userId/${DateTime.now().millisecondsSinceEpoch}.$ext';
      await _client.storage.from('user-uploads').uploadBinary(path, fileBytes);
      final url = _client.storage.from('user-uploads').getPublicUrl(path);
      await updateProfile(avatarUrl: url);
      return url;
    } catch (_) {
      throw const NetworkException('Unable to upload avatar.');
    }
  }
}
