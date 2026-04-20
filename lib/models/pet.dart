// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet.freezed.dart';
part 'pet.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum PetType {
  dog,
  cat,
  bird,
  rabbit,
  fish,
  reptile,
  other,
}

extension PetTypeX on PetType {
  String get label {
    switch (this) {
      case PetType.dog:
        return 'Dog';
      case PetType.cat:
        return 'Cat';
      case PetType.bird:
        return 'Bird';
      case PetType.rabbit:
        return 'Rabbit';
      case PetType.fish:
        return 'Fish';
      case PetType.reptile:
        return 'Reptile';
      case PetType.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case PetType.dog:
        return '🐕';
      case PetType.cat:
        return '🐈';
      case PetType.bird:
        return '🐦';
      case PetType.rabbit:
        return '🐇';
      case PetType.fish:
        return '🐟';
      case PetType.reptile:
        return '🦎';
      case PetType.other:
        return '🐾';
    }
  }
}

@freezed
class Pet with _$Pet {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Pet({
    required String id,
    required String userId,
    required String name,
    required PetType type,
    String? breed,
    DateTime? dateOfBirth,
    String? gender,
    double? weightKg,
    String? color,
    String? photoUrl,
    String? microchipId,
    String? qrCodeId,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _Pet;

  factory Pet.fromJson(Map<String, dynamic> json) => _$PetFromJson(json);
}
