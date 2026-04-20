// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_pet_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LostPetAlertImpl _$$LostPetAlertImplFromJson(Map<String, dynamic> json) =>
    _$LostPetAlertImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      petId: json['pet_id'] as String?,
      petName: json['pet_name'] as String,
      petType: $enumDecode(_$PetTypeEnumMap, json['pet_type']),
      petBreed: json['pet_breed'] as String?,
      petDescription: json['pet_description'] as String,
      petPhotoUrl: json['pet_photo_url'] as String?,
      lastSeenLat: (json['last_seen_lat'] as num).toDouble(),
      lastSeenLng: (json['last_seen_lng'] as num).toDouble(),
      lastSeenAddress: json['last_seen_address'] as String?,
      lastSeenAt: json['last_seen_at'] == null
          ? null
          : DateTime.parse(json['last_seen_at'] as String),
      contactPhone: json['contact_phone'] as String?,
      rewardAmount: (json['reward_amount'] as num?)?.toDouble(),
      isFound: json['is_found'] as bool? ?? false,
      foundAt: json['found_at'] == null
          ? null
          : DateTime.parse(json['found_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      ownerName: json['owner_name'] as String?,
      ownerAvatarUrl: json['owner_avatar_url'] as String?,
    );

Map<String, dynamic> _$$LostPetAlertImplToJson(_$LostPetAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'pet_id': instance.petId,
      'pet_name': instance.petName,
      'pet_type': _$PetTypeEnumMap[instance.petType]!,
      'pet_breed': instance.petBreed,
      'pet_description': instance.petDescription,
      'pet_photo_url': instance.petPhotoUrl,
      'last_seen_lat': instance.lastSeenLat,
      'last_seen_lng': instance.lastSeenLng,
      'last_seen_address': instance.lastSeenAddress,
      'last_seen_at': instance.lastSeenAt?.toIso8601String(),
      'contact_phone': instance.contactPhone,
      'reward_amount': instance.rewardAmount,
      'is_found': instance.isFound,
      'found_at': instance.foundAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'owner_name': instance.ownerName,
      'owner_avatar_url': instance.ownerAvatarUrl,
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
