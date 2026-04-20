import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pawcity/models/review.dart';
import 'package:pawcity/repositories/review_repository.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository();
});

final spotReviewsProvider =
    FutureProvider.family<List<Review>, String>((ref, spotId) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.fetchReviewsForSpot(spotId);
});

final userReviewsProvider = FutureProvider<List<Review>>((ref) async {
  final repo = ref.watch(reviewRepositoryProvider);
  return repo.fetchUserReviews();
});
