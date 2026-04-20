// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  String get spotId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get petId => throw _privateConstructorUsedError;
  PetType? get petType => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  int get helpfulCount => throw _privateConstructorUsedError;
  bool get isFlagged => throw _privateConstructorUsedError;
  DateTime? get visitedAt => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Joined fields
  String? get userName => throw _privateConstructorUsedError;
  String? get userAvatarUrl => throw _privateConstructorUsedError;
  String? get spotName => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call(
      {String id,
      String spotId,
      String userId,
      String? petId,
      PetType? petType,
      int rating,
      String? comment,
      List<String> photoUrls,
      int helpfulCount,
      bool isFlagged,
      DateTime? visitedAt,
      DateTime? createdAt,
      String? userName,
      String? userAvatarUrl,
      String? spotName});
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? spotId = null,
    Object? userId = null,
    Object? petId = freezed,
    Object? petType = freezed,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = null,
    Object? helpfulCount = null,
    Object? isFlagged = null,
    Object? visitedAt = freezed,
    Object? createdAt = freezed,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
    Object? spotName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      spotId: null == spotId
          ? _value.spotId
          : spotId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      petId: freezed == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String?,
      petType: freezed == petType
          ? _value.petType
          : petType // ignore: cast_nullable_to_non_nullable
              as PetType?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      visitedAt: freezed == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      spotName: freezed == spotName
          ? _value.spotName
          : spotName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
          _$ReviewImpl value, $Res Function(_$ReviewImpl) then) =
      __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String spotId,
      String userId,
      String? petId,
      PetType? petType,
      int rating,
      String? comment,
      List<String> photoUrls,
      int helpfulCount,
      bool isFlagged,
      DateTime? visitedAt,
      DateTime? createdAt,
      String? userName,
      String? userAvatarUrl,
      String? spotName});
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
      _$ReviewImpl _value, $Res Function(_$ReviewImpl) _then)
      : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? spotId = null,
    Object? userId = null,
    Object? petId = freezed,
    Object? petType = freezed,
    Object? rating = null,
    Object? comment = freezed,
    Object? photoUrls = null,
    Object? helpfulCount = null,
    Object? isFlagged = null,
    Object? visitedAt = freezed,
    Object? createdAt = freezed,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
    Object? spotName = freezed,
  }) {
    return _then(_$ReviewImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      spotId: null == spotId
          ? _value.spotId
          : spotId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      petId: freezed == petId
          ? _value.petId
          : petId // ignore: cast_nullable_to_non_nullable
              as String?,
      petType: freezed == petType
          ? _value.petType
          : petType // ignore: cast_nullable_to_non_nullable
              as PetType?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      visitedAt: freezed == visitedAt
          ? _value.visitedAt
          : visitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      spotName: freezed == spotName
          ? _value.spotName
          : spotName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ReviewImpl implements _Review {
  const _$ReviewImpl(
      {required this.id,
      required this.spotId,
      required this.userId,
      this.petId,
      this.petType,
      required this.rating,
      this.comment,
      final List<String> photoUrls = const <String>[],
      this.helpfulCount = 0,
      this.isFlagged = false,
      this.visitedAt,
      this.createdAt,
      this.userName,
      this.userAvatarUrl,
      this.spotName})
      : _photoUrls = photoUrls;

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  final String spotId;
  @override
  final String userId;
  @override
  final String? petId;
  @override
  final PetType? petType;
  @override
  final int rating;
  @override
  final String? comment;
  final List<String> _photoUrls;
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  @override
  @JsonKey()
  final int helpfulCount;
  @override
  @JsonKey()
  final bool isFlagged;
  @override
  final DateTime? visitedAt;
  @override
  final DateTime? createdAt;
// Joined fields
  @override
  final String? userName;
  @override
  final String? userAvatarUrl;
  @override
  final String? spotName;

  @override
  String toString() {
    return 'Review(id: $id, spotId: $spotId, userId: $userId, petId: $petId, petType: $petType, rating: $rating, comment: $comment, photoUrls: $photoUrls, helpfulCount: $helpfulCount, isFlagged: $isFlagged, visitedAt: $visitedAt, createdAt: $createdAt, userName: $userName, userAvatarUrl: $userAvatarUrl, spotName: $spotName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.spotId, spotId) || other.spotId == spotId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.petId, petId) || other.petId == petId) &&
            (identical(other.petType, petType) || other.petType == petType) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.isFlagged, isFlagged) ||
                other.isFlagged == isFlagged) &&
            (identical(other.visitedAt, visitedAt) ||
                other.visitedAt == visitedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatarUrl, userAvatarUrl) ||
                other.userAvatarUrl == userAvatarUrl) &&
            (identical(other.spotName, spotName) ||
                other.spotName == spotName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      spotId,
      userId,
      petId,
      petType,
      rating,
      comment,
      const DeepCollectionEquality().hash(_photoUrls),
      helpfulCount,
      isFlagged,
      visitedAt,
      createdAt,
      userName,
      userAvatarUrl,
      spotName);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(
      this,
    );
  }
}

abstract class _Review implements Review {
  const factory _Review(
      {required final String id,
      required final String spotId,
      required final String userId,
      final String? petId,
      final PetType? petType,
      required final int rating,
      final String? comment,
      final List<String> photoUrls,
      final int helpfulCount,
      final bool isFlagged,
      final DateTime? visitedAt,
      final DateTime? createdAt,
      final String? userName,
      final String? userAvatarUrl,
      final String? spotName}) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  String get spotId;
  @override
  String get userId;
  @override
  String? get petId;
  @override
  PetType? get petType;
  @override
  int get rating;
  @override
  String? get comment;
  @override
  List<String> get photoUrls;
  @override
  int get helpfulCount;
  @override
  bool get isFlagged;
  @override
  DateTime? get visitedAt;
  @override
  DateTime? get createdAt; // Joined fields
  @override
  String? get userName;
  @override
  String? get userAvatarUrl;
  @override
  String? get spotName;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
