// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Profile({
    required String id,
    required String username,
    String? displayName,
    String? avatarUrl,
    String? city,
    String? bio,
    @Default(0) int pawPoints,
    @Default(false) bool isNgo,
    @Default(false) bool isAuthority,
    String? orgName,
    @Default(false) bool orgVerified,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
