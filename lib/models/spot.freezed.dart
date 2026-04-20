// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Spot _$SpotFromJson(Map<String, dynamic> json) {
  return _Spot.fromJson(json);
}

/// @nodoc
mixin _$Spot {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  SpotCategory get category => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  PetPolicy? get petPolicy => throw _privateConstructorUsedError;
  List<String> get amenities => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Spot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpotCopyWith<Spot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotCopyWith<$Res> {
  factory $SpotCopyWith(Spot value, $Res Function(Spot) then) =
      _$SpotCopyWithImpl<$Res, Spot>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      SpotCategory category,
      String? address,
      String city,
      double lat,
      double lng,
      PetPolicy? petPolicy,
      List<String> amenities,
      String? phone,
      String? website,
      String? coverImageUrl,
      List<String> photoUrls,
      double rating,
      int reviewCount,
      bool isVerified,
      DateTime? createdAt});
}

/// @nodoc
class _$SpotCopyWithImpl<$Res, $Val extends Spot>
    implements $SpotCopyWith<$Res> {
  _$SpotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? address = freezed,
    Object? city = null,
    Object? lat = null,
    Object? lng = null,
    Object? petPolicy = freezed,
    Object? amenities = null,
    Object? phone = freezed,
    Object? website = freezed,
    Object? coverImageUrl = freezed,
    Object? photoUrls = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isVerified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SpotCategory,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      petPolicy: freezed == petPolicy
          ? _value.petPolicy
          : petPolicy // ignore: cast_nullable_to_non_nullable
              as PetPolicy?,
      amenities: null == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpotImplCopyWith<$Res> implements $SpotCopyWith<$Res> {
  factory _$$SpotImplCopyWith(
          _$SpotImpl value, $Res Function(_$SpotImpl) then) =
      __$$SpotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      SpotCategory category,
      String? address,
      String city,
      double lat,
      double lng,
      PetPolicy? petPolicy,
      List<String> amenities,
      String? phone,
      String? website,
      String? coverImageUrl,
      List<String> photoUrls,
      double rating,
      int reviewCount,
      bool isVerified,
      DateTime? createdAt});
}

/// @nodoc
class __$$SpotImplCopyWithImpl<$Res>
    extends _$SpotCopyWithImpl<$Res, _$SpotImpl>
    implements _$$SpotImplCopyWith<$Res> {
  __$$SpotImplCopyWithImpl(_$SpotImpl _value, $Res Function(_$SpotImpl) _then)
      : super(_value, _then);

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? address = freezed,
    Object? city = null,
    Object? lat = null,
    Object? lng = null,
    Object? petPolicy = freezed,
    Object? amenities = null,
    Object? phone = freezed,
    Object? website = freezed,
    Object? coverImageUrl = freezed,
    Object? photoUrls = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isVerified = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$SpotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as SpotCategory,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      petPolicy: freezed == petPolicy
          ? _value.petPolicy
          : petPolicy // ignore: cast_nullable_to_non_nullable
              as PetPolicy?,
      amenities: null == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$SpotImpl implements _Spot {
  const _$SpotImpl(
      {required this.id,
      required this.name,
      this.description,
      required this.category,
      this.address,
      required this.city,
      required this.lat,
      required this.lng,
      this.petPolicy,
      final List<String> amenities = const <String>[],
      this.phone,
      this.website,
      this.coverImageUrl,
      final List<String> photoUrls = const <String>[],
      this.rating = 0,
      this.reviewCount = 0,
      this.isVerified = false,
      this.createdAt})
      : _amenities = amenities,
        _photoUrls = photoUrls;

  factory _$SpotImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpotImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final SpotCategory category;
  @override
  final String? address;
  @override
  final String city;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final PetPolicy? petPolicy;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  final String? phone;
  @override
  final String? website;
  @override
  final String? coverImageUrl;
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
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Spot(id: $id, name: $name, description: $description, category: $category, address: $address, city: $city, lat: $lat, lng: $lng, petPolicy: $petPolicy, amenities: $amenities, phone: $phone, website: $website, coverImageUrl: $coverImageUrl, photoUrls: $photoUrls, rating: $rating, reviewCount: $reviewCount, isVerified: $isVerified, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.petPolicy, petPolicy) ||
                other.petPolicy == petPolicy) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      category,
      address,
      city,
      lat,
      lng,
      petPolicy,
      const DeepCollectionEquality().hash(_amenities),
      phone,
      website,
      coverImageUrl,
      const DeepCollectionEquality().hash(_photoUrls),
      rating,
      reviewCount,
      isVerified,
      createdAt);

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpotImplCopyWith<_$SpotImpl> get copyWith =>
      __$$SpotImplCopyWithImpl<_$SpotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpotImplToJson(
      this,
    );
  }
}

abstract class _Spot implements Spot {
  const factory _Spot(
      {required final String id,
      required final String name,
      final String? description,
      required final SpotCategory category,
      final String? address,
      required final String city,
      required final double lat,
      required final double lng,
      final PetPolicy? petPolicy,
      final List<String> amenities,
      final String? phone,
      final String? website,
      final String? coverImageUrl,
      final List<String> photoUrls,
      final double rating,
      final int reviewCount,
      final bool isVerified,
      final DateTime? createdAt}) = _$SpotImpl;

  factory _Spot.fromJson(Map<String, dynamic> json) = _$SpotImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  SpotCategory get category;
  @override
  String? get address;
  @override
  String get city;
  @override
  double get lat;
  @override
  double get lng;
  @override
  PetPolicy? get petPolicy;
  @override
  List<String> get amenities;
  @override
  String? get phone;
  @override
  String? get website;
  @override
  String? get coverImageUrl;
  @override
  List<String> get photoUrls;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  bool get isVerified;
  @override
  DateTime? get createdAt;

  /// Create a copy of Spot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpotImplCopyWith<_$SpotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
