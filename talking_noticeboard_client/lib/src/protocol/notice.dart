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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i2;

/// A notice in the noticeboard.
abstract class Notice implements _i1.SerializableModel {
  Notice._({
    this.id,
    required this.userInfoId,
    this.userInfo,
    DateTime? createdAt,
    required this.text,
    required this.path,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Notice({
    int? id,
    required int userInfoId,
    _i2.UserInfo? userInfo,
    DateTime? createdAt,
    required String text,
    required String path,
  }) = _NoticeImpl;

  factory Notice.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notice(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      text: jsonSerialization['text'] as String,
      path: jsonSerialization['path'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  /// The person who created this notice.
  _i2.UserInfo? userInfo;

  /// When this notice was created.
  DateTime createdAt;

  /// The text of the notice.
  String text;

  /// The path where the uploaded sound lives.
  String path;

  Notice copyWith({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    DateTime? createdAt,
    String? text,
    String? path,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'createdAt': createdAt.toJson(),
      'text': text,
      'path': path,
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
    _i2.UserInfo? userInfo,
    DateTime? createdAt,
    required String text,
    required String path,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          userInfo: userInfo,
          createdAt: createdAt,
          text: text,
          path: path,
        );

  @override
  Notice copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    DateTime? createdAt,
    String? text,
    String? path,
  }) {
    return Notice(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      path: path ?? this.path,
    );
  }
}
