import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/pet.dart';
import 'package:pawcity/models/health_record.dart';
import 'package:pawcity/repositories/pet_repository.dart';
import 'package:pawcity/repositories/health_record_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository();
});

final healthRecordRepositoryProvider = Provider<HealthRecordRepository>((ref) {
  return HealthRecordRepository();
});

final userPetsProvider = FutureProvider<List<Pet>>((ref) async {
  final repo = ref.watch(petRepositoryProvider);
  return repo.fetchUserPets();
});

final petDetailProvider =
    FutureProvider.family<Pet, String>((ref, petId) async {
  final repo = ref.watch(petRepositoryProvider);
  return repo.fetchPet(petId);
});

final petHealthRecordsProvider =
    FutureProvider.family<List<HealthRecord>, String>((ref, petId) async {
  final repo = ref.watch(healthRecordRepositoryProvider);
  return repo.fetchRecordsForPet(petId);
});
