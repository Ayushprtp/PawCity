import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/pet_activity.dart';
import 'package:pawcity/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final activityServiceProvider = Provider((ref) => ActivityService(ref));

class ActivityService {
  final Ref _ref;
  ActivityService(this._ref);

  SupabaseClient get _client => _ref.read(supabaseClientProvider);

  Future<List<PetActivity>> fetchActivities(String petId) async {
    final response = await _client
        .from('pet_activities')
        .select()
        .eq('pet_id', petId)
        .order('timestamp', ascending: false);
    
    return (response as List).map((json) => PetActivity.fromJson(json)).toList();
  }

  Future<void> logActivity(PetActivity activity) async {
    await _client.from('pet_activities').insert(activity.toJson());
  }
}

final petActivitiesProvider = FutureProvider.family<List<PetActivity>, String>((ref, petId) async {
  return ref.read(activityServiceProvider).fetchActivities(petId);
});
