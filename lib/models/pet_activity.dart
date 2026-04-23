// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_activity.freezed.dart';
part 'pet_activity.g.dart';

@freezed
class PetActivity with _$PetActivity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PetActivity({
    required String id,
    required String petId,
    required String activityType,
    required double value,
    required String unit,
    required DateTime timestamp,
    String? notes,
    DateTime? createdAt,
  }) = _PetActivity;

  factory PetActivity.fromJson(Map<String, dynamic> json) => _$PetActivityFromJson(json);
}
