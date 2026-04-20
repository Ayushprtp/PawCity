// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'paw_patrol_report.freezed.dart';
part 'paw_patrol_report.g.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum ReportCategory {
  strayDogAggressive,
  strayDogInjured,
  strayDogPack,
  animalAbuse,
  animalAbandonment,
  petCruelty,
  illegalBreeding,
  poisoningAttempt,
  roadAccidentAnimal,
  otherMisconduct,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum ReportSeverity { low, medium, high, critical }

@JsonEnum(fieldRename: FieldRename.snake)
enum ReportStatus {
  submitted,
  underReview,
  assigned,
  inProgress,
  resolved,
  closed,
  rejected,
}

extension ReportCategoryX on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.strayDogAggressive:
        return 'Aggressive Stray Dog';
      case ReportCategory.strayDogInjured:
        return 'Injured Stray';
      case ReportCategory.strayDogPack:
        return 'Stray Pack';
      case ReportCategory.animalAbuse:
        return 'Animal Abuse';
      case ReportCategory.animalAbandonment:
        return 'Abandonment';
      case ReportCategory.petCruelty:
        return 'Pet Cruelty';
      case ReportCategory.illegalBreeding:
        return 'Illegal Breeding';
      case ReportCategory.poisoningAttempt:
        return 'Poisoning Attempt';
      case ReportCategory.roadAccidentAnimal:
        return 'Road Accident';
      case ReportCategory.otherMisconduct:
        return 'Other';
    }
  }

  String get dbValue {
    switch (this) {
      case ReportCategory.strayDogAggressive:
        return 'stray_dog_aggressive';
      case ReportCategory.strayDogInjured:
        return 'stray_dog_injured';
      case ReportCategory.strayDogPack:
        return 'stray_dog_pack';
      case ReportCategory.animalAbuse:
        return 'animal_abuse';
      case ReportCategory.animalAbandonment:
        return 'animal_abandonment';
      case ReportCategory.petCruelty:
        return 'pet_cruelty';
      case ReportCategory.illegalBreeding:
        return 'illegal_breeding';
      case ReportCategory.poisoningAttempt:
        return 'poisoning_attempt';
      case ReportCategory.roadAccidentAnimal:
        return 'road_accident_animal';
      case ReportCategory.otherMisconduct:
        return 'other_misconduct';
    }
  }
}

extension ReportSeverityX on ReportSeverity {
  String get label => name[0].toUpperCase() + name.substring(1);
}

extension ReportStatusX on ReportStatus {
  String get label {
    switch (this) {
      case ReportStatus.submitted:
        return 'Submitted';
      case ReportStatus.underReview:
        return 'Under Review';
      case ReportStatus.assigned:
        return 'Assigned';
      case ReportStatus.inProgress:
        return 'In Progress';
      case ReportStatus.resolved:
        return 'Resolved';
      case ReportStatus.closed:
        return 'Closed';
      case ReportStatus.rejected:
        return 'Rejected';
    }
  }

  String get dbValue {
    switch (this) {
      case ReportStatus.underReview:
        return 'under_review';
      case ReportStatus.inProgress:
        return 'in_progress';
      default:
        return name;
    }
  }
}

@freezed
class PawPatrolReport with _$PawPatrolReport {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PawPatrolReport({
    required String id,
    required String reporterId,
    required ReportCategory category,
    @Default(ReportSeverity.medium) ReportSeverity severity,
    required String title,
    required String description,
    required double lat,
    required double lng,
    String? address,
    required String city,
    @Default(<String>[]) List<String> photoUrls,
    @Default(<String>[]) List<String> videoUrls,
    @Default(1) int animalCount,
    String? animalDescription,
    @Default(ReportStatus.submitted) ReportStatus status,
    String? assignedTo,
    String? assignedOrg,
    @Default(<String>[]) List<String> authorityNotified,
    String? resolutionNote,
    DateTime? resolvedAt,
    @Default(0) int upvotes,
    @Default(false) bool isAnonymous,
    @Default(false) bool isFlagged,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Joined fields
    String? reporterName,
    String? reporterAvatarUrl,
  }) = _PawPatrolReport;

  factory PawPatrolReport.fromJson(Map<String, dynamic> json) =>
      _$PawPatrolReportFromJson(json);
}
