// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String,
      spotId: json['spot_id'] as String,
      userId: json['user_id'] as String,
      petId: json['pet_id'] as String?,
      petType: $enumDecodeNullable(_$PetTypeEnumMap, json['pet_type']),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      helpfulCount: (json['helpful_count'] as num?)?.toInt() ?? 0,
      isFlagged: json['is_flagged'] as bool? ?? false,
      visitedAt: json['visited_at'] == null
          ? null
          : DateTime.parse(json['visited_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      userName: json['user_name'] as String?,
      userAvatarUrl: json['user_avatar_url'] as String?,
      spotName: json['spot_name'] as String?,
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'spot_id': instance.spotId,
      'user_id': instance.userId,
      'pet_id': instance.petId,
      'pet_type': _$PetTypeEnumMap[instance.petType],
      'rating': instance.rating,
      'comment': instance.comment,
      'photo_urls': instance.photoUrls,
      'helpful_count': instance.helpfulCount,
      'is_flagged': instance.isFlagged,
      'visited_at': instance.visitedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'user_name': instance.userName,
      'user_avatar_url': instance.userAvatarUrl,
      'spot_name': instance.spotName,
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
