// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_record.freezed.dart';
part 'health_record.g.dart';

@freezed
class HealthRecord with _$HealthRecord {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HealthRecord({
    required String id,
    required String petId,
    required String recordType,
    required String title,
    String? description,
    String? vetName,
    required DateTime date,
    DateTime? nextDueDate,
    String? documentUrl,
    DateTime? createdAt,
  }) = _HealthRecord;

  factory HealthRecord.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordFromJson(json);
}
