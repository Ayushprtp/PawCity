// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pawcity/models/pet.dart';

part 'lost_pet_alert.freezed.dart';
part 'lost_pet_alert.g.dart';

@freezed
class LostPetAlert with _$LostPetAlert {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LostPetAlert({
    required String id,
    required String userId,
    String? petId,
    required String petName,
    required PetType petType,
    String? petBreed,
    required String petDescription,
    String? petPhotoUrl,
    required double lastSeenLat,
    required double lastSeenLng,
    String? lastSeenAddress,
    DateTime? lastSeenAt,
    String? contactPhone,
    double? rewardAmount,
    @Default(false) bool isFound,
    DateTime? foundAt,
    DateTime? createdAt,
    // Joined fields
    String? ownerName,
    String? ownerAvatarUrl,
  }) = _LostPetAlert;

  factory LostPetAlert.fromJson(Map<String, dynamic> json) =>
      _$LostPetAlertFromJson(json);
}
