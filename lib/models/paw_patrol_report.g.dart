// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paw_patrol_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PawPatrolReportImpl _$$PawPatrolReportImplFromJson(
        Map<String, dynamic> json) =>
    _$PawPatrolReportImpl(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      category: $enumDecode(_$ReportCategoryEnumMap, json['category']),
      severity:
          $enumDecodeNullable(_$ReportSeverityEnumMap, json['severity']) ??
              ReportSeverity.medium,
      title: json['title'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
      city: json['city'] as String,
      photoUrls: (json['photo_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      videoUrls: (json['video_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      animalCount: (json['animal_count'] as num?)?.toInt() ?? 1,
      animalDescription: json['animal_description'] as String?,
      status: $enumDecodeNullable(_$ReportStatusEnumMap, json['status']) ??
          ReportStatus.submitted,
      assignedTo: json['assigned_to'] as String?,
      assignedOrg: json['assigned_org'] as String?,
      authorityNotified: (json['authority_notified'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      resolutionNote: json['resolution_note'] as String?,
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
      upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      isFlagged: json['is_flagged'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      reporterName: json['reporter_name'] as String?,
      reporterAvatarUrl: json['reporter_avatar_url'] as String?,
    );

Map<String, dynamic> _$$PawPatrolReportImplToJson(
        _$PawPatrolReportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporter_id': instance.reporterId,
      'category': _$ReportCategoryEnumMap[instance.category]!,
      'severity': _$ReportSeverityEnumMap[instance.severity]!,
      'title': instance.title,
      'description': instance.description,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'city': instance.city,
      'photo_urls': instance.photoUrls,
      'video_urls': instance.videoUrls,
      'animal_count': instance.animalCount,
      'animal_description': instance.animalDescription,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'assigned_to': instance.assignedTo,
      'assigned_org': instance.assignedOrg,
      'authority_notified': instance.authorityNotified,
      'resolution_note': instance.resolutionNote,
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'upvotes': instance.upvotes,
      'is_anonymous': instance.isAnonymous,
      'is_flagged': instance.isFlagged,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'reporter_name': instance.reporterName,
      'reporter_avatar_url': instance.reporterAvatarUrl,
    };

const _$ReportCategoryEnumMap = {
  ReportCategory.strayDogAggressive: 'stray_dog_aggressive',
  ReportCategory.strayDogInjured: 'stray_dog_injured',
  ReportCategory.strayDogPack: 'stray_dog_pack',
  ReportCategory.animalAbuse: 'animal_abuse',
  ReportCategory.animalAbandonment: 'animal_abandonment',
  ReportCategory.petCruelty: 'pet_cruelty',
  ReportCategory.illegalBreeding: 'illegal_breeding',
  ReportCategory.poisoningAttempt: 'poisoning_attempt',
  ReportCategory.roadAccidentAnimal: 'road_accident_animal',
  ReportCategory.otherMisconduct: 'other_misconduct',
};

const _$ReportSeverityEnumMap = {
  ReportSeverity.low: 'low',
  ReportSeverity.medium: 'medium',
  ReportSeverity.high: 'high',
  ReportSeverity.critical: 'critical',
};

const _$ReportStatusEnumMap = {
  ReportStatus.submitted: 'submitted',
  ReportStatus.underReview: 'under_review',
  ReportStatus.assigned: 'assigned',
  ReportStatus.inProgress: 'in_progress',
  ReportStatus.resolved: 'resolved',
  ReportStatus.closed: 'closed',
  ReportStatus.rejected: 'rejected',
};
