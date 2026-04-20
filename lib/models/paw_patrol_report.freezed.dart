// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paw_patrol_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PawPatrolReport _$PawPatrolReportFromJson(Map<String, dynamic> json) {
  return _PawPatrolReport.fromJson(json);
}

/// @nodoc
mixin _$PawPatrolReport {
  String get id => throw _privateConstructorUsedError;
  String get reporterId => throw _privateConstructorUsedError;
  ReportCategory get category => throw _privateConstructorUsedError;
  ReportSeverity get severity => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get lat => throw _privateConstructorUsedError;
  double get lng => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  List<String> get photoUrls => throw _privateConstructorUsedError;
  List<String> get videoUrls => throw _privateConstructorUsedError;
  int get animalCount => throw _privateConstructorUsedError;
  String? get animalDescription => throw _privateConstructorUsedError;
  ReportStatus get status => throw _privateConstructorUsedError;
  String? get assignedTo => throw _privateConstructorUsedError;
  String? get assignedOrg => throw _privateConstructorUsedError;
  List<String> get authorityNotified => throw _privateConstructorUsedError;
  String? get resolutionNote => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  int get upvotes => throw _privateConstructorUsedError;
  bool get isAnonymous => throw _privateConstructorUsedError;
  bool get isFlagged => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Joined fields
  String? get reporterName => throw _privateConstructorUsedError;
  String? get reporterAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this PawPatrolReport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PawPatrolReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PawPatrolReportCopyWith<PawPatrolReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PawPatrolReportCopyWith<$Res> {
  factory $PawPatrolReportCopyWith(
          PawPatrolReport value, $Res Function(PawPatrolReport) then) =
      _$PawPatrolReportCopyWithImpl<$Res, PawPatrolReport>;
  @useResult
  $Res call(
      {String id,
      String reporterId,
      ReportCategory category,
      ReportSeverity severity,
      String title,
      String description,
      double lat,
      double lng,
      String? address,
      String city,
      List<String> photoUrls,
      List<String> videoUrls,
      int animalCount,
      String? animalDescription,
      ReportStatus status,
      String? assignedTo,
      String? assignedOrg,
      List<String> authorityNotified,
      String? resolutionNote,
      DateTime? resolvedAt,
      int upvotes,
      bool isAnonymous,
      bool isFlagged,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? reporterName,
      String? reporterAvatarUrl});
}

/// @nodoc
class _$PawPatrolReportCopyWithImpl<$Res, $Val extends PawPatrolReport>
    implements $PawPatrolReportCopyWith<$Res> {
  _$PawPatrolReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PawPatrolReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? category = null,
    Object? severity = null,
    Object? title = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
    Object? city = null,
    Object? photoUrls = null,
    Object? videoUrls = null,
    Object? animalCount = null,
    Object? animalDescription = freezed,
    Object? status = null,
    Object? assignedTo = freezed,
    Object? assignedOrg = freezed,
    Object? authorityNotified = null,
    Object? resolutionNote = freezed,
    Object? resolvedAt = freezed,
    Object? upvotes = null,
    Object? isAnonymous = null,
    Object? isFlagged = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reporterName = freezed,
    Object? reporterAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: null == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReportCategory,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ReportSeverity,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrls: null == photoUrls
          ? _value.photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrls: null == videoUrls
          ? _value.videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      animalCount: null == animalCount
          ? _value.animalCount
          : animalCount // ignore: cast_nullable_to_non_nullable
              as int,
      animalDescription: freezed == animalDescription
          ? _value.animalDescription
          : animalDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOrg: freezed == assignedOrg
          ? _value.assignedOrg
          : assignedOrg // ignore: cast_nullable_to_non_nullable
              as String?,
      authorityNotified: null == authorityNotified
          ? _value.authorityNotified
          : authorityNotified // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resolutionNote: freezed == resolutionNote
          ? _value.resolutionNote
          : resolutionNote // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reporterName: freezed == reporterName
          ? _value.reporterName
          : reporterName // ignore: cast_nullable_to_non_nullable
              as String?,
      reporterAvatarUrl: freezed == reporterAvatarUrl
          ? _value.reporterAvatarUrl
          : reporterAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PawPatrolReportImplCopyWith<$Res>
    implements $PawPatrolReportCopyWith<$Res> {
  factory _$$PawPatrolReportImplCopyWith(_$PawPatrolReportImpl value,
          $Res Function(_$PawPatrolReportImpl) then) =
      __$$PawPatrolReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reporterId,
      ReportCategory category,
      ReportSeverity severity,
      String title,
      String description,
      double lat,
      double lng,
      String? address,
      String city,
      List<String> photoUrls,
      List<String> videoUrls,
      int animalCount,
      String? animalDescription,
      ReportStatus status,
      String? assignedTo,
      String? assignedOrg,
      List<String> authorityNotified,
      String? resolutionNote,
      DateTime? resolvedAt,
      int upvotes,
      bool isAnonymous,
      bool isFlagged,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? reporterName,
      String? reporterAvatarUrl});
}

/// @nodoc
class __$$PawPatrolReportImplCopyWithImpl<$Res>
    extends _$PawPatrolReportCopyWithImpl<$Res, _$PawPatrolReportImpl>
    implements _$$PawPatrolReportImplCopyWith<$Res> {
  __$$PawPatrolReportImplCopyWithImpl(
      _$PawPatrolReportImpl _value, $Res Function(_$PawPatrolReportImpl) _then)
      : super(_value, _then);

  /// Create a copy of PawPatrolReport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? category = null,
    Object? severity = null,
    Object? title = null,
    Object? description = null,
    Object? lat = null,
    Object? lng = null,
    Object? address = freezed,
    Object? city = null,
    Object? photoUrls = null,
    Object? videoUrls = null,
    Object? animalCount = null,
    Object? animalDescription = freezed,
    Object? status = null,
    Object? assignedTo = freezed,
    Object? assignedOrg = freezed,
    Object? authorityNotified = null,
    Object? resolutionNote = freezed,
    Object? resolvedAt = freezed,
    Object? upvotes = null,
    Object? isAnonymous = null,
    Object? isFlagged = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? reporterName = freezed,
    Object? reporterAvatarUrl = freezed,
  }) {
    return _then(_$PawPatrolReportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reporterId: null == reporterId
          ? _value.reporterId
          : reporterId // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ReportCategory,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ReportSeverity,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrls: null == photoUrls
          ? _value._photoUrls
          : photoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      videoUrls: null == videoUrls
          ? _value._videoUrls
          : videoUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      animalCount: null == animalCount
          ? _value.animalCount
          : animalCount // ignore: cast_nullable_to_non_nullable
              as int,
      animalDescription: freezed == animalDescription
          ? _value.animalDescription
          : animalDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReportStatus,
      assignedTo: freezed == assignedTo
          ? _value.assignedTo
          : assignedTo // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedOrg: freezed == assignedOrg
          ? _value.assignedOrg
          : assignedOrg // ignore: cast_nullable_to_non_nullable
              as String?,
      authorityNotified: null == authorityNotified
          ? _value._authorityNotified
          : authorityNotified // ignore: cast_nullable_to_non_nullable
              as List<String>,
      resolutionNote: freezed == resolutionNote
          ? _value.resolutionNote
          : resolutionNote // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: freezed == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as int,
      isAnonymous: null == isAnonymous
          ? _value.isAnonymous
          : isAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlagged: null == isFlagged
          ? _value.isFlagged
          : isFlagged // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reporterName: freezed == reporterName
          ? _value.reporterName
          : reporterName // ignore: cast_nullable_to_non_nullable
              as String?,
      reporterAvatarUrl: freezed == reporterAvatarUrl
          ? _value.reporterAvatarUrl
          : reporterAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PawPatrolReportImpl implements _PawPatrolReport {
  const _$PawPatrolReportImpl(
      {required this.id,
      required this.reporterId,
      required this.category,
      this.severity = ReportSeverity.medium,
      required this.title,
      required this.description,
      required this.lat,
      required this.lng,
      this.address,
      required this.city,
      final List<String> photoUrls = const <String>[],
      final List<String> videoUrls = const <String>[],
      this.animalCount = 1,
      this.animalDescription,
      this.status = ReportStatus.submitted,
      this.assignedTo,
      this.assignedOrg,
      final List<String> authorityNotified = const <String>[],
      this.resolutionNote,
      this.resolvedAt,
      this.upvotes = 0,
      this.isAnonymous = false,
      this.isFlagged = false,
      this.createdAt,
      this.updatedAt,
      this.reporterName,
      this.reporterAvatarUrl})
      : _photoUrls = photoUrls,
        _videoUrls = videoUrls,
        _authorityNotified = authorityNotified;

  factory _$PawPatrolReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$PawPatrolReportImplFromJson(json);

  @override
  final String id;
  @override
  final String reporterId;
  @override
  final ReportCategory category;
  @override
  @JsonKey()
  final ReportSeverity severity;
  @override
  final String title;
  @override
  final String description;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final String? address;
  @override
  final String city;
  final List<String> _photoUrls;
  @override
  @JsonKey()
  List<String> get photoUrls {
    if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoUrls);
  }

  final List<String> _videoUrls;
  @override
  @JsonKey()
  List<String> get videoUrls {
    if (_videoUrls is EqualUnmodifiableListView) return _videoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videoUrls);
  }

  @override
  @JsonKey()
  final int animalCount;
  @override
  final String? animalDescription;
  @override
  @JsonKey()
  final ReportStatus status;
  @override
  final String? assignedTo;
  @override
  final String? assignedOrg;
  final List<String> _authorityNotified;
  @override
  @JsonKey()
  List<String> get authorityNotified {
    if (_authorityNotified is EqualUnmodifiableListView)
      return _authorityNotified;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_authorityNotified);
  }

  @override
  final String? resolutionNote;
  @override
  final DateTime? resolvedAt;
  @override
  @JsonKey()
  final int upvotes;
  @override
  @JsonKey()
  final bool isAnonymous;
  @override
  @JsonKey()
  final bool isFlagged;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Joined fields
  @override
  final String? reporterName;
  @override
  final String? reporterAvatarUrl;

  @override
  String toString() {
    return 'PawPatrolReport(id: $id, reporterId: $reporterId, category: $category, severity: $severity, title: $title, description: $description, lat: $lat, lng: $lng, address: $address, city: $city, photoUrls: $photoUrls, videoUrls: $videoUrls, animalCount: $animalCount, animalDescription: $animalDescription, status: $status, assignedTo: $assignedTo, assignedOrg: $assignedOrg, authorityNotified: $authorityNotified, resolutionNote: $resolutionNote, resolvedAt: $resolvedAt, upvotes: $upvotes, isAnonymous: $isAnonymous, isFlagged: $isFlagged, createdAt: $createdAt, updatedAt: $updatedAt, reporterName: $reporterName, reporterAvatarUrl: $reporterAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PawPatrolReportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            const DeepCollectionEquality()
                .equals(other._photoUrls, _photoUrls) &&
            const DeepCollectionEquality()
                .equals(other._videoUrls, _videoUrls) &&
            (identical(other.animalCount, animalCount) ||
                other.animalCount == animalCount) &&
            (identical(other.animalDescription, animalDescription) ||
                other.animalDescription == animalDescription) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedTo, assignedTo) ||
                other.assignedTo == assignedTo) &&
            (identical(other.assignedOrg, assignedOrg) ||
                other.assignedOrg == assignedOrg) &&
            const DeepCollectionEquality()
                .equals(other._authorityNotified, _authorityNotified) &&
            (identical(other.resolutionNote, resolutionNote) ||
                other.resolutionNote == resolutionNote) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.upvotes, upvotes) || other.upvotes == upvotes) &&
            (identical(other.isAnonymous, isAnonymous) ||
                other.isAnonymous == isAnonymous) &&
            (identical(other.isFlagged, isFlagged) ||
                other.isFlagged == isFlagged) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.reporterName, reporterName) ||
                other.reporterName == reporterName) &&
            (identical(other.reporterAvatarUrl, reporterAvatarUrl) ||
                other.reporterAvatarUrl == reporterAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        reporterId,
        category,
        severity,
        title,
        description,
        lat,
        lng,
        address,
        city,
        const DeepCollectionEquality().hash(_photoUrls),
        const DeepCollectionEquality().hash(_videoUrls),
        animalCount,
        animalDescription,
        status,
        assignedTo,
        assignedOrg,
        const DeepCollectionEquality().hash(_authorityNotified),
        resolutionNote,
        resolvedAt,
        upvotes,
        isAnonymous,
        isFlagged,
        createdAt,
        updatedAt,
        reporterName,
        reporterAvatarUrl
      ]);

  /// Create a copy of PawPatrolReport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PawPatrolReportImplCopyWith<_$PawPatrolReportImpl> get copyWith =>
      __$$PawPatrolReportImplCopyWithImpl<_$PawPatrolReportImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PawPatrolReportImplToJson(
      this,
    );
  }
}

abstract class _PawPatrolReport implements PawPatrolReport {
  const factory _PawPatrolReport(
      {required final String id,
      required final String reporterId,
      required final ReportCategory category,
      final ReportSeverity severity,
      required final String title,
      required final String description,
      required final double lat,
      required final double lng,
      final String? address,
      required final String city,
      final List<String> photoUrls,
      final List<String> videoUrls,
      final int animalCount,
      final String? animalDescription,
      final ReportStatus status,
      final String? assignedTo,
      final String? assignedOrg,
      final List<String> authorityNotified,
      final String? resolutionNote,
      final DateTime? resolvedAt,
      final int upvotes,
      final bool isAnonymous,
      final bool isFlagged,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? reporterName,
      final String? reporterAvatarUrl}) = _$PawPatrolReportImpl;

  factory _PawPatrolReport.fromJson(Map<String, dynamic> json) =
      _$PawPatrolReportImpl.fromJson;

  @override
  String get id;
  @override
  String get reporterId;
  @override
  ReportCategory get category;
  @override
  ReportSeverity get severity;
  @override
  String get title;
  @override
  String get description;
  @override
  double get lat;
  @override
  double get lng;
  @override
  String? get address;
  @override
  String get city;
  @override
  List<String> get photoUrls;
  @override
  List<String> get videoUrls;
  @override
  int get animalCount;
  @override
  String? get animalDescription;
  @override
  ReportStatus get status;
  @override
  String? get assignedTo;
  @override
  String? get assignedOrg;
  @override
  List<String> get authorityNotified;
  @override
  String? get resolutionNote;
  @override
  DateTime? get resolvedAt;
  @override
  int get upvotes;
  @override
  bool get isAnonymous;
  @override
  bool get isFlagged;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // Joined fields
  @override
  String? get reporterName;
  @override
  String? get reporterAvatarUrl;

  /// Create a copy of PawPatrolReport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PawPatrolReportImplCopyWith<_$PawPatrolReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
