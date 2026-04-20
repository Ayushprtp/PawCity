// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HealthRecordImpl _$$HealthRecordImplFromJson(Map<String, dynamic> json) =>
    _$HealthRecordImpl(
      id: json['id'] as String,
      petId: json['pet_id'] as String,
      recordType: json['record_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      vetName: json['vet_name'] as String?,
      date: DateTime.parse(json['date'] as String),
      nextDueDate: json['next_due_date'] == null
          ? null
          : DateTime.parse(json['next_due_date'] as String),
      documentUrl: json['document_url'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$HealthRecordImplToJson(_$HealthRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pet_id': instance.petId,
      'record_type': instance.recordType,
      'title': instance.title,
      'description': instance.description,
      'vet_name': instance.vetName,
      'date': instance.date.toIso8601String(),
      'next_due_date': instance.nextDueDate?.toIso8601String(),
      'document_url': instance.documentUrl,
      'created_at': instance.createdAt?.toIso8601String(),
    };
