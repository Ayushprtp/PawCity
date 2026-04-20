// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_pet_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LostPetAlert _$LostPetAlertFromJson(Map<String, dynamic> json) {
  return _LostPetAlert.fromJson(json);
}

/// @nodoc
mixin _$LostPetAlert {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get petId => throw _privateConstructorUsedError;
  String get petName => throw _privateConstructorUsedError;
  PetType get petType => throw _privateConstructorUsedError;
  String? get petBreed => throw _privateConstructorUsedError;
  String get petDescription => throw _privateConstructorUsedError;
  String? get petPhotoUrl => throw _privateConstructorUsedError;
  double get lastSeenLat => throw _privateConstructorUsedError;
  double get lastSeenLng => throw _privateConstructorUsedError;
  String? get lastSeenAddress => throw _privateConstructorUsedError;
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  double? get rewardAmount => throw _privateConstructorUsedError;
  bool get isFound => throw _privateConstructorUsedError;
  DateTime? get foundAt => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Joined fields
  String? get ownerName => throw _privateConstructorUsedError;
  String? get ownerAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this LostPetAlert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostPetAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostPetAlertCopyWith<LostPetAlert> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostPetAlertCopyWith<$Res> {
  factory $LostPetAlertCopyWith(
          LostPetAlert value, $Res Function(LostPetAlert) then) =
      _$LostPetAlertCopyWithImpl<$Res, LostPetAlert>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? petId,
      String petName,
      PetType petType,
      String? petBreed,
      String petDescription,
      String? petPhotoUrl,
      double lastSeenLat,
      double lastSeenLng,
      String? lastSeenAddress,
      DateTime? lastSeenAt,
      String? contactPhone,
      double? rewardAmount,
      bool isFound,
      DateTime? foundAt,
      DateTime? createdAt,
      String? ownerName,
      String? ownerAvatarUrl});
}

/// @nodoc
class _$LostPetAlertCopyWithImpl<$Res, $Val extends LostPetAlert>
    implements $LostPetAlertCopyWith<$Res> {
  _$LostPetAlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostPetAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? petId = freezed,
    Object? petName = null,
    Object? petType = null,
    Object? petBreed = freezed,
    Object? petDescription = null,
    Object? petPhotoUrl = freezed,
    Object? lastSeenLat = null,
    Object? lastSeenLng = null,
    Object? lastSeenAddress = freezed,
    Object? lastSeenAt = freezed,
    Object? contactPhone = freezed,
    Object? rewardAmount = freezed,
    Object? isFound = null,
    Object? foundAt = freezed,
    Object? createdAt = freezed,
    Object? ownerName = freezed,
    Object? ownerAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      petId: freezed == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String?,
      petName: null == petName
          ? _value.petName
          : petName // ignore: cast_nullable_to_non_nullable
              as String,
      petType: null == petType
          ? _value.petType
          : petType // ignore: cast_nullable_to_non_nullable
              as PetType,
      petBreed: freezed == petBreed
          ? _value.petBreed
          : petBreed // ignore: cast_nullable_to_non_nullable
              as String?,
      petDescription: null == petDescription
          ? _value.petDescription
          : petDescription // ignore: cast_nullable_to_non_nullable
              as String,
      petPhotoUrl: freezed == petPhotoUrl
          ? _value.petPhotoUrl
          : petPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenLat: null == lastSeenLat
          ? _value.lastSeenLat
          : lastSeenLat // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeenLng: null == lastSeenLng
          ? _value.lastSeenLng
          : lastSeenLng // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeenAddress: freezed == lastSeenAddress
          ? _value.lastSeenAddress
          : lastSeenAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardAmount: freezed == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isFound: null == isFound
          ? _value.isFound
          : isFound // ignore: cast_nullable_to_non_nullable
              as bool,
      foundAt: freezed == foundAt
          ? _value.foundAt
          : foundAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAvatarUrl: freezed == ownerAvatarUrl
          ? _value.ownerAvatarUrl
          : ownerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostPetAlertImplCopyWith<$Res>
    implements $LostPetAlertCopyWith<$Res> {
  factory _$$LostPetAlertImplCopyWith(
          _$LostPetAlertImpl value, $Res Function(_$LostPetAlertImpl) then) =
      __$$LostPetAlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? petId,
      String petName,
      PetType petType,
      String? petBreed,
      String petDescription,
      String? petPhotoUrl,
      double lastSeenLat,
      double lastSeenLng,
      String? lastSeenAddress,
      DateTime? lastSeenAt,
      String? contactPhone,
      double? rewardAmount,
      bool isFound,
      DateTime? foundAt,
      DateTime? createdAt,
      String? ownerName,
      String? ownerAvatarUrl});
}

/// @nodoc
class __$$LostPetAlertImplCopyWithImpl<$Res>
    extends _$LostPetAlertCopyWithImpl<$Res, _$LostPetAlertImpl>
    implements _$$LostPetAlertImplCopyWith<$Res> {
  __$$LostPetAlertImplCopyWithImpl(
      _$LostPetAlertImpl _value, $Res Function(_$LostPetAlertImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostPetAlert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? petId = freezed,
    Object? petName = null,
    Object? petType = null,
    Object? petBreed = freezed,
    Object? petDescription = null,
    Object? petPhotoUrl = freezed,
    Object? lastSeenLat = null,
    Object? lastSeenLng = null,
    Object? lastSeenAddress = freezed,
    Object? lastSeenAt = freezed,
    Object? contactPhone = freezed,
    Object? rewardAmount = freezed,
    Object? isFound = null,
    Object? foundAt = freezed,
    Object? createdAt = freezed,
    Object? ownerName = freezed,
    Object? ownerAvatarUrl = freezed,
  }) {
    return _then(_$LostPetAlertImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      petId: freezed == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String?,
      petName: null == petName
          ? _value.petName
          : petName // ignore: cast_nullable_to_non_nullable
              as String,
      petType: null == petType
          ? _value.petType
          : petType // ignore: cast_nullable_to_non_nullable
              as PetType,
      petBreed: freezed == petBreed
          ? _value.petBreed
          : petBreed // ignore: cast_nullable_to_non_nullable
              as String?,
      petDescription: null == petDescription
          ? _value.petDescription
          : petDescription // ignore: cast_nullable_to_non_nullable
              as String,
      petPhotoUrl: freezed == petPhotoUrl
          ? _value.petPhotoUrl
          : petPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenLat: null == lastSeenLat
          ? _value.lastSeenLat
          : lastSeenLat // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeenLng: null == lastSeenLng
          ? _value.lastSeenLng
          : lastSeenLng // ignore: cast_nullable_to_non_nullable
              as double,
      lastSeenAddress: freezed == lastSeenAddress
          ? _value.lastSeenAddress
          : lastSeenAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      rewardAmount: freezed == rewardAmount
          ? _value.rewardAmount
          : rewardAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      isFound: null == isFound
          ? _value.isFound
          : isFound // ignore: cast_nullable_to_non_nullable
              as bool,
      foundAt: freezed == foundAt
          ? _value.foundAt
          : foundAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ownerName: freezed == ownerName
          ? _value.ownerName
          : ownerName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAvatarUrl: freezed == ownerAvatarUrl
          ? _value.ownerAvatarUrl
          : ownerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$LostPetAlertImpl implements _LostPetAlert {
  const _$LostPetAlertImpl(
      {required this.id,
      required this.userId,
      this.petId,
      required this.petName,
      required this.petType,
      this.petBreed,
      required this.petDescription,
      this.petPhotoUrl,
      required this.lastSeenLat,
      required this.lastSeenLng,
      this.lastSeenAddress,
      this.lastSeenAt,
      this.contactPhone,
      this.rewardAmount,
      this.isFound = false,
      this.foundAt,
      this.createdAt,
      this.ownerName,
      this.ownerAvatarUrl});

  factory _$LostPetAlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostPetAlertImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? petId;
  @override
  final String petName;
  @override
  final PetType petType;
  @override
  final String? petBreed;
  @override
  final String petDescription;
  @override
  final String? petPhotoUrl;
  @override
  final double lastSeenLat;
  @override
  final double lastSeenLng;
  @override
  final String? lastSeenAddress;
  @override
  final DateTime? lastSeenAt;
  @override
  final String? contactPhone;
  @override
  final double? rewardAmount;
  @override
  @JsonKey()
  final bool isFound;
  @override
  final DateTime? foundAt;
  @override
  final DateTime? createdAt;
// Joined fields
  @override
  final String? ownerName;
  @override
  final String? ownerAvatarUrl;

  @override
  String toString() {
    return 'LostPetAlert(id: $id, userId: $userId, petId: $petId, petName: $petName, petType: $petType, petBreed: $petBreed, petDescription: $petDescription, petPhotoUrl: $petPhotoUrl, lastSeenLat: $lastSeenLat, lastSeenLng: $lastSeenLng, lastSeenAddress: $lastSeenAddress, lastSeenAt: $lastSeenAt, contactPhone: $contactPhone, rewardAmount: $rewardAmount, isFound: $isFound, foundAt: $foundAt, createdAt: $createdAt, ownerName: $ownerName, ownerAvatarUrl: $ownerAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostPetAlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.petName, petName) || other.petName == petName) &&
            (identical(other.petType, petType) || other.petType == petType) &&
            (identical(other.petBreed, petBreed) ||
                other.petBreed == petBreed) &&
            (identical(other.petDescription, petDescription) ||
                other.petDescription == petDescription) &&
            (identical(other.petPhotoUrl, petPhotoUrl) ||
                other.petPhotoUrl == petPhotoUrl) &&
            (identical(other.lastSeenLat, lastSeenLat) ||
                other.lastSeenLat == lastSeenLat) &&
            (identical(other.lastSeenLng, lastSeenLng) ||
                other.lastSeenLng == lastSeenLng) &&
            (identical(other.lastSeenAddress, lastSeenAddress) ||
                other.lastSeenAddress == lastSeenAddress) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.rewardAmount, rewardAmount) ||
                other.rewardAmount == rewardAmount) &&
            (identical(other.isFound, isFound) || other.isFound == isFound) &&
            (identical(other.foundAt, foundAt) || other.foundAt == foundAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerAvatarUrl, ownerAvatarUrl) ||
                other.ownerAvatarUrl == ownerAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        petId,
        petName,
        petType,
        petBreed,
        petDescription,
        petPhotoUrl,
        lastSeenLat,
        lastSeenLng,
        lastSeenAddress,
        lastSeenAt,
        contactPhone,
        rewardAmount,
        isFound,
        foundAt,
        createdAt,
        ownerName,
        ownerAvatarUrl
      ]);

  /// Create a copy of LostPetAlert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostPetAlertImplCopyWith<_$LostPetAlertImpl> get copyWith =>
      __$$LostPetAlertImplCopyWithImpl<_$LostPetAlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostPetAlertImplToJson(
      this,
    );
  }
}

abstract class _LostPetAlert implements LostPetAlert {
  const factory _LostPetAlert(
      {required final String id,
      required final String userId,
      final String? petId,
      required final String petName,
      required final PetType petType,
      final String? petBreed,
      required final String petDescription,
      final String? petPhotoUrl,
      required final double lastSeenLat,
      required final double lastSeenLng,
      final String? lastSeenAddress,
      final DateTime? lastSeenAt,
      final String? contactPhone,
      final double? rewardAmount,
      final bool isFound,
      final DateTime? foundAt,
      final DateTime? createdAt,
      final String? ownerName,
      final String? ownerAvatarUrl}) = _$LostPetAlertImpl;

  factory _LostPetAlert.fromJson(Map<String, dynamic> json) =
      _$LostPetAlertImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get petId;
  @override
  String get petName;
  @override
  PetType get petType;
  @override
  String? get petBreed;
  @override
  String get petDescription;
  @override
  String? get petPhotoUrl;
  @override
  double get lastSeenLat;
  @override
  double get lastSeenLng;
  @override
  String? get lastSeenAddress;
  @override
  DateTime? get lastSeenAt;
  @override
  String? get contactPhone;
  @override
  double? get rewardAmount;
  @override
  bool get isFound;
  @override
  DateTime? get foundAt;
  @override
  DateTime? get createdAt; // Joined fields
  @override
  String? get ownerName;
  @override
  String? get ownerAvatarUrl;

  /// Create a copy of LostPetAlert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostPetAlertImplCopyWith<_$LostPetAlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
