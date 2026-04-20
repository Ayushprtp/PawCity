// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String?,
      bio: json['bio'] as String?,
      pawPoints: (json['paw_points'] as num?)?.toInt() ?? 0,
      isNgo: json['is_ngo'] as bool? ?? false,
      isAuthority: json['is_authority'] as bool? ?? false,
      orgName: json['org_name'] as String?,
      orgVerified: json['org_verified'] as bool? ?? false,
      fcmToken: json['fcm_token'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'city': instance.city,
      'bio': instance.bio,
      'paw_points': instance.pawPoints,
      'is_ngo': instance.isNgo,
      'is_authority': instance.isAuthority,
      'org_name': instance.orgName,
      'org_verified': instance.orgVerified,
      'fcm_token': instance.fcmToken,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
