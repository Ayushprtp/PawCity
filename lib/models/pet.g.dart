// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetImpl _$$PetImplFromJson(Map<String, dynamic> json) => _$PetImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$PetTypeEnumMap, json['type']),
      breed: json['breed'] as String?,
      dateOfBirth: json['date_of_birth'] == null
          ? null
          : DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String?,
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      color: json['color'] as String?,
      photoUrl: json['photo_url'] as String?,
      microchipId: json['microchip_id'] as String?,
      qrCodeId: json['qr_code_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PetImplToJson(_$PetImpl instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'type': _$PetTypeEnumMap[instance.type]!,
      'breed': instance.breed,
      'date_of_birth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'weight_kg': instance.weightKg,
      'color': instance.color,
      'photo_url': instance.photoUrl,
      'microchip_id': instance.microchipId,
      'qr_code_id': instance.qrCodeId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$PetTypeEnumMap = {
  PetType.dog: 'dog',
  PetType.cat: 'cat',
  PetType.bird: 'bird',
  PetType.rabbit: 'rabbit',
  PetType.fish: 'fish',
  PetType.reptile: 'reptile',
  PetType.other: 'other',
};
