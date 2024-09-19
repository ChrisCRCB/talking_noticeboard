/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'colours.dart' as _i4;
import 'error_message.dart' as _i5;
import 'notice.dart' as _i6;
import 'server_options.dart' as _i7;
import 'upload_result.dart' as _i8;
import 'package:talking_noticeboard_server/src/generated/notice.dart' as _i9;
export 'colours.dart';
export 'error_message.dart';
export 'notice.dart';
export 'server_options.dart';
export 'upload_result.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'notices',
      dartName: 'Notice',
      schema: 'public',
      module: 'talking_noticeboard',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'notices_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'text',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'path',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'notices_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notices_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.Colours) {
      return _i4.Colours.fromJson(data) as T;
    }
    if (t == _i5.ErrorMessage) {
      return _i5.ErrorMessage.fromJson(data) as T;
    }
    if (t == _i6.Notice) {
      return _i6.Notice.fromJson(data) as T;
    }
    if (t == _i7.ServerOptions) {
      return _i7.ServerOptions.fromJson(data) as T;
    }
    if (t == _i8.UploadResult) {
      return _i8.UploadResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.Colours?>()) {
      return (data != null ? _i4.Colours.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ErrorMessage?>()) {
      return (data != null ? _i5.ErrorMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Notice?>()) {
      return (data != null ? _i6.Notice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ServerOptions?>()) {
      return (data != null ? _i7.ServerOptions.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.UploadResult?>()) {
      return (data != null ? _i8.UploadResult.fromJson(data) : null) as T;
    }
    if (t == List<_i9.Notice>) {
      return (data as List).map((e) => deserialize<_i9.Notice>(e)).toList()
          as dynamic;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.Colours) {
      return 'Colours';
    }
    if (data is _i5.ErrorMessage) {
      return 'ErrorMessage';
    }
    if (data is _i6.Notice) {
      return 'Notice';
    }
    if (data is _i7.ServerOptions) {
      return 'ServerOptions';
    }
    if (data is _i8.UploadResult) {
      return 'UploadResult';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'Colours') {
      return deserialize<_i4.Colours>(data['data']);
    }
    if (data['className'] == 'ErrorMessage') {
      return deserialize<_i5.ErrorMessage>(data['data']);
    }
    if (data['className'] == 'Notice') {
      return deserialize<_i6.Notice>(data['data']);
    }
    if (data['className'] == 'ServerOptions') {
      return deserialize<_i7.ServerOptions>(data['data']);
    }
    if (data['className'] == 'UploadResult') {
      return deserialize<_i8.UploadResult>(data['data']);
    }
    if (data['className'].startsWith('serverpod.')) {
      data['className'] = data['className'].substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i6.Notice:
        return _i6.Notice.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'talking_noticeboard';
}
