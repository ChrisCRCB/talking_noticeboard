/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;

/// A notice in the noticeboard.
abstract class Notice extends _i1.TableRow
    implements _i1.ProtocolSerialization {
  Notice._({
    int? id,
    required this.userInfoId,
    this.userInfo,
    DateTime? createdAt,
    required this.text,
    required this.filename,
  })  : createdAt = createdAt ?? DateTime.now(),
        super(id);

  factory Notice({
    int? id,
    required int userInfoId,
    _i2.UserInfo? userInfo,
    DateTime? createdAt,
    required String text,
    required String filename,
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
      filename: jsonSerialization['filename'] as String,
    );
  }

  static final t = NoticeTable();

  static const db = NoticeRepository._();

  int userInfoId;

  /// The person who created this notice.
  _i2.UserInfo? userInfo;

  /// When this notice was created.
  DateTime createdAt;

  /// The text of the notice.
  String text;

  /// The filename of the sound file to send.
  String filename;

  @override
  _i1.Table get table => t;

  Notice copyWith({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    DateTime? createdAt,
    String? text,
    String? filename,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'createdAt': createdAt.toJson(),
      'text': text,
      'filename': filename,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      'createdAt': createdAt.toJson(),
      'text': text,
      'filename': filename,
    };
  }

  static NoticeInclude include({_i2.UserInfoInclude? userInfo}) {
    return NoticeInclude._(userInfo: userInfo);
  }

  static NoticeIncludeList includeList({
    _i1.WhereExpressionBuilder<NoticeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NoticeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NoticeTable>? orderByList,
    NoticeInclude? include,
  }) {
    return NoticeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Notice.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Notice.t),
      include: include,
    );
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
    required String filename,
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
    String? filename,
  }) {
    return Notice(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      filename: filename ?? this.filename,
    );
  }
}

class NoticeTable extends _i1.Table {
  NoticeTable({super.tableRelation}) : super(tableName: 'notices') {
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    text = _i1.ColumnString(
      'text',
      this,
    );
    filename = _i1.ColumnString(
      'filename',
      this,
    );
  }

  late final _i1.ColumnInt userInfoId;

  /// The person who created this notice.
  _i2.UserInfoTable? _userInfo;

  /// When this notice was created.
  late final _i1.ColumnDateTime createdAt;

  /// The text of the notice.
  late final _i1.ColumnString text;

  /// The filename of the sound file to send.
  late final _i1.ColumnString filename;

  _i2.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: Notice.t.userInfoId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userInfoId,
        createdAt,
        text,
        filename,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    return null;
  }
}

class NoticeInclude extends _i1.IncludeObject {
  NoticeInclude._({_i2.UserInfoInclude? userInfo}) {
    _userInfo = userInfo;
  }

  _i2.UserInfoInclude? _userInfo;

  @override
  Map<String, _i1.Include?> get includes => {'userInfo': _userInfo};

  @override
  _i1.Table get table => Notice.t;
}

class NoticeIncludeList extends _i1.IncludeList {
  NoticeIncludeList._({
    _i1.WhereExpressionBuilder<NoticeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Notice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Notice.t;
}

class NoticeRepository {
  const NoticeRepository._();

  final attachRow = const NoticeAttachRowRepository._();

  Future<List<Notice>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NoticeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<NoticeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NoticeTable>? orderByList,
    _i1.Transaction? transaction,
    NoticeInclude? include,
  }) async {
    return session.db.find<Notice>(
      where: where?.call(Notice.t),
      orderBy: orderBy?.call(Notice.t),
      orderByList: orderByList?.call(Notice.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Notice?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NoticeTable>? where,
    int? offset,
    _i1.OrderByBuilder<NoticeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<NoticeTable>? orderByList,
    _i1.Transaction? transaction,
    NoticeInclude? include,
  }) async {
    return session.db.findFirstRow<Notice>(
      where: where?.call(Notice.t),
      orderBy: orderBy?.call(Notice.t),
      orderByList: orderByList?.call(Notice.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Notice?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    NoticeInclude? include,
  }) async {
    return session.db.findById<Notice>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Notice>> insert(
    _i1.Session session,
    List<Notice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Notice>(
      rows,
      transaction: transaction,
    );
  }

  Future<Notice> insertRow(
    _i1.Session session,
    Notice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Notice>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Notice>> update(
    _i1.Session session,
    List<Notice> rows, {
    _i1.ColumnSelections<NoticeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Notice>(
      rows,
      columns: columns?.call(Notice.t),
      transaction: transaction,
    );
  }

  Future<Notice> updateRow(
    _i1.Session session,
    Notice row, {
    _i1.ColumnSelections<NoticeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Notice>(
      row,
      columns: columns?.call(Notice.t),
      transaction: transaction,
    );
  }

  Future<List<Notice>> delete(
    _i1.Session session,
    List<Notice> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Notice>(
      rows,
      transaction: transaction,
    );
  }

  Future<Notice> deleteRow(
    _i1.Session session,
    Notice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Notice>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Notice>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<NoticeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Notice>(
      where: where(Notice.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<NoticeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Notice>(
      where: where?.call(Notice.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class NoticeAttachRowRepository {
  const NoticeAttachRowRepository._();

  Future<void> userInfo(
    _i1.Session session,
    Notice notice,
    _i2.UserInfo userInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (notice.id == null) {
      throw ArgumentError.notNull('notice.id');
    }
    if (userInfo.id == null) {
      throw ArgumentError.notNull('userInfo.id');
    }

    var $notice = notice.copyWith(userInfoId: userInfo.id);
    await session.db.updateRow<Notice>(
      $notice,
      columns: [Notice.t.userInfoId],
      transaction: transaction,
    );
  }
}
