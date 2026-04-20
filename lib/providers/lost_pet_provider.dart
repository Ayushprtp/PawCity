import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/lost_pet_alert.dart';
import 'package:pawcity/repositories/lost_pet_repository.dart';

final lostPetRepositoryProvider = Provider<LostPetRepository>((ref) {
  return LostPetRepository();
});

final lostPetAlertsProvider = FutureProvider<List<LostPetAlert>>((ref) async {
  final repo = ref.watch(lostPetRepositoryProvider);
  return repo.fetchAlerts();
});
