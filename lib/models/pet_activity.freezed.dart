// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PetActivity _$PetActivityFromJson(Map<String, dynamic> json) {
  return _PetActivity.fromJson(json);
}

/// @nodoc
mixin _$PetActivity {
  String get id => throw _privateConstructorUsedError;
  String get petId => throw _privateConstructorUsedError;
  String get activityType => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PetActivity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PetActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetActivityCopyWith<PetActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetActivityCopyWith<$Res> {
  factory $PetActivityCopyWith(
          PetActivity value, $Res Function(PetActivity) then) =
      _$PetActivityCopyWithImpl<$Res, PetActivity>;
  @useResult
  $Res call(
      {String id,
      String petId,
      String activityType,
      double value,
      String unit,
      DateTime timestamp,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class _$PetActivityCopyWithImpl<$Res, $Val extends PetActivity>
    implements $PetActivityCopyWith<$Res> {
  _$PetActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? activityType = null,
    Object? value = null,
    Object? unit = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PetActivityImplCopyWith<$Res>
    implements $PetActivityCopyWith<$Res> {
  factory _$$PetActivityImplCopyWith(
          _$PetActivityImpl value, $Res Function(_$PetActivityImpl) then) =
      __$$PetActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String petId,
      String activityType,
      double value,
      String unit,
      DateTime timestamp,
      String? notes,
      DateTime? createdAt});
}

/// @nodoc
class __$$PetActivityImplCopyWithImpl<$Res>
    extends _$PetActivityCopyWithImpl<$Res, _$PetActivityImpl>
    implements _$$PetActivityImplCopyWith<$Res> {
  __$$PetActivityImplCopyWithImpl(
      _$PetActivityImpl _value, $Res Function(_$PetActivityImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? petId = null,
    Object? activityType = null,
    Object? value = null,
    Object? unit = null,
    Object? timestamp = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PetActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      petId: null == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String,
      activityType: null == activityType
          ? _value.activityType
          : activityType // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PetActivityImpl implements _PetActivity {
  const _$PetActivityImpl(
      {required this.id,
      required this.petId,
      required this.activityType,
      required this.value,
      required this.unit,
      required this.timestamp,
      this.notes,
      this.createdAt});

  factory _$PetActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PetActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String petId;
  @override
  final String activityType;
  @override
  final double value;
  @override
  final String unit;
  @override
  final DateTime timestamp;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PetActivity(id: $id, petId: $petId, activityType: $activityType, value: $value, unit: $unit, timestamp: $timestamp, notes: $notes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, petId, activityType, value,
      unit, timestamp, notes, createdAt);

  /// Create a copy of PetActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetActivityImplCopyWith<_$PetActivityImpl> get copyWith =>
      __$$PetActivityImplCopyWithImpl<_$PetActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PetActivityImplToJson(
      this,
    );
  }
}

abstract class _PetActivity implements PetActivity {
  const factory _PetActivity(
      {required final String id,
      required final String petId,
      required final String activityType,
      required final double value,
      required final String unit,
      required final DateTime timestamp,
      final String? notes,
      final DateTime? createdAt}) = _$PetActivityImpl;

  factory _PetActivity.fromJson(Map<String, dynamic> json) =
      _$PetActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get petId;
  @override
  String get activityType;
  @override
  double get value;
  @override
  String get unit;
  @override
  DateTime get timestamp;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;

  /// Create a copy of PetActivity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetActivityImplCopyWith<_$PetActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
