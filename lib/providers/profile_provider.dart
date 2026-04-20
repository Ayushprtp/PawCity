import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/profile.dart';
import 'package:pawcity/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.fetchCurrentProfile();
});
