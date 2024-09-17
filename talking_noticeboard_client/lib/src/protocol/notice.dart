/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:uuid/uuid.dart' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;

/// A notice in the noticeboard.
abstract class Notice implements _i1.SerializableModel {
  Notice._({
    this.id,
    required this.userInfoId,
    this.userInfo,
    DateTime? createdAt,
    required this.text,
    _i1.UuidValue? filename,
  })  : createdAt = createdAt ?? DateTime.now(),
        filename = filename ?? _i2.Uuid().v4obj();

  factory Notice({
    int? id,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    DateTime? createdAt,
    required String text,
    _i1.UuidValue? filename,
  }) = _NoticeImpl;

  factory Notice.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notice(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i3.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      text: jsonSerialization['text'] as String,
      filename:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['filename']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  /// The person who created this notice.
  _i3.UserInfo? userInfo;

  /// When this notice was created.
  DateTime createdAt;

  /// The text of the notice.
  String text;

  /// The filename of the sound file to send.
  _i1.UuidValue filename;

  Notice copyWith({
    int? id,
    int? userInfoId,
    _i3.UserInfo? userInfo,
    DateTime? createdAt,
    String? text,
    _i1.UuidValue? filename,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'createdAt': createdAt.toJson(),
      'text': text,
      'filename': filename.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NoticeImpl extends Notice {
  _NoticeImpl({
    int? id,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    DateTime? createdAt,
    required String text,
    _i1.UuidValue? filename,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          userInfo: userInfo,
          createdAt: createdAt,
          text: text,
          filename: filename,
        );

  @override
  Notice copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    DateTime? createdAt,
    String? text,
    _i1.UuidValue? filename,
  }) {
    return Notice(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i3.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      filename: filename ?? this.filename,
    );
  }
}
