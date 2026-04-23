// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetActivityImpl _$$PetActivityImplFromJson(Map<String, dynamic> json) =>
    _$PetActivityImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      activityType: json['activity_type'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PetActivityImplToJson(_$PetActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'activity_type': instance.activityType,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp.toIso8601String(),
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
    };
