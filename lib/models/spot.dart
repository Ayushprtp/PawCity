// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'spot.freezed.dart';
part 'spot.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum SpotCategory {
  restaurant,
  cafe,
  park,
  vet,
  grooming,
  boarding,
  petStore,
  hotel,
  beach,
  trail,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum PetPolicy {
  insideAllowed,
  outsideOnly,
  allAreas,
  leashRequired,
}

extension SpotCategoryX on SpotCategory {
  String get dbValue {
    switch (this) {
      case SpotCategory.petStore:
        return 'pet_store';
      default:
        return name;
    }
  }

  String get label {
    switch (this) {
      case SpotCategory.restaurant:
        return 'Restaurant';
      case SpotCategory.cafe:
        return 'Cafe';
      case SpotCategory.park:
        return 'Park';
      case SpotCategory.vet:
        return 'Vet';
      case SpotCategory.grooming:
        return 'Grooming';
      case SpotCategory.boarding:
        return 'Boarding';
      case SpotCategory.petStore:
        return 'Pet Store';
      case SpotCategory.hotel:
        return 'Hotel';
      case SpotCategory.beach:
        return 'Beach';
      case SpotCategory.trail:
        return 'Trail';
    }
  }
}

extension PetPolicyX on PetPolicy {
  String get label {
    switch (this) {
      case PetPolicy.insideAllowed:
        return 'Inside Allowed';
      case PetPolicy.outsideOnly:
        return 'Outside Only';
      case PetPolicy.allAreas:
        return 'All Areas';
      case PetPolicy.leashRequired:
        return 'Leash Required';
    }
  }
}

@freezed
class Spot with _$Spot {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Spot({
    required String id,
    required String name,
    String? description,
    required SpotCategory category,
    String? address,
    required String city,
    required double lat,
    required double lng,
    PetPolicy? petPolicy,
    @Default(<String>[]) List<String> amenities,
    String? phone,
    String? website,
    String? coverImageUrl,
    @Default(<String>[]) List<String> photoUrls,
    @Default(0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool isVerified,
    DateTime? createdAt,
  }) = _Spot;

  factory Spot.fromJson(Map<String, dynamic> json) => _$SpotFromJson(json);
}
