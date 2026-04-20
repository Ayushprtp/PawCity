// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawcity/models/pet.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Review({
    required String id,
    required String spotId,
    required String userId,
    String? petId,
    PetType? petType,
    required int rating,
    String? comment,
    @Default(<String>[]) List<String> photoUrls,
    @Default(0) int helpfulCount,
    @Default(false) bool isFlagged,
    DateTime? visitedAt,
    DateTime? createdAt,
    // Joined fields
    String? userName,
    String? userAvatarUrl,
    String? spotName,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
