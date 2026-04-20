// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpotImpl _$$SpotImplFromJson(Map<String, dynamic> json) => _$SpotImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      category: $enumDecode(_$SpotCategoryEnumMap, json['category']),
      address: json['address'] as String?,
      city: json['city'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      petPolicy: $enumDecodeNullable(_$PetPolicyEnumMap, json['pet_policy']),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['review_count'] as num?)?.toInt() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$SpotImplToJson(_$SpotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$SpotCategoryEnumMap[instance.category]!,
      'address': instance.address,
      'city': instance.city,
      'lat': instance.lat,
      'lng': instance.lng,
      'pet_policy': _$PetPolicyEnumMap[instance.petPolicy],
      'amenities': instance.amenities,
      'phone': instance.phone,
      'website': instance.website,
      'cover_image_url': instance.coverImageUrl,
      'photo_urls': instance.photoUrls,
      'rating': instance.rating,
      'review_count': instance.reviewCount,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$SpotCategoryEnumMap = {
  SpotCategory.restaurant: 'restaurant',
  SpotCategory.cafe: 'cafe',
  SpotCategory.park: 'park',
  SpotCategory.vet: 'vet',
  SpotCategory.grooming: 'grooming',
  SpotCategory.boarding: 'boarding',
  SpotCategory.petStore: 'pet_store',
  SpotCategory.hotel: 'hotel',
  SpotCategory.beach: 'beach',
  SpotCategory.trail: 'trail',
};

const _$PetPolicyEnumMap = {
  PetPolicy.insideAllowed: 'inside_allowed',
  PetPolicy.outsideOnly: 'outside_only',
  PetPolicy.allAreas: 'all_areas',
  PetPolicy.leashRequired: 'leash_required',
};
