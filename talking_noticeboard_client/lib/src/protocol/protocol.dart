/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'colours.dart' as _i2;
import 'error_message.dart' as _i3;
import 'notice.dart' as _i4;
import 'server_options.dart' as _i5;
import 'upload_result.dart' as _i6;
import 'package:talking_noticeboard_client/src/protocol/notice.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
export 'colours.dart';
export 'error_message.dart';
export 'notice.dart';
export 'server_options.dart';
export 'upload_result.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Colours) {
      return _i2.Colours.fromJson(data) as T;
    }
    if (t == _i3.ErrorMessage) {
      return _i3.ErrorMessage.fromJson(data) as T;
    }
    if (t == _i4.Notice) {
      return _i4.Notice.fromJson(data) as T;
    }
    if (t == _i5.ServerOptions) {
      return _i5.ServerOptions.fromJson(data) as T;
    }
    if (t == _i6.UploadResult) {
      return _i6.UploadResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Colours?>()) {
      return (data != null ? _i2.Colours.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ErrorMessage?>()) {
      return (data != null ? _i3.ErrorMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Notice?>()) {
      return (data != null ? _i4.Notice.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ServerOptions?>()) {
      return (data != null ? _i5.ServerOptions.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.UploadResult?>()) {
      return (data != null ? _i6.UploadResult.fromJson(data) : null) as T;
    }
    if (t == List<_i7.Notice>) {
      return (data as List).map((e) => deserialize<_i7.Notice>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Colours) {
      return 'Colours';
    }
    if (data is _i3.ErrorMessage) {
      return 'ErrorMessage';
    }
    if (data is _i4.Notice) {
      return 'Notice';
    }
    if (data is _i5.ServerOptions) {
      return 'ServerOptions';
    }
    if (data is _i6.UploadResult) {
      return 'UploadResult';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'Colours') {
      return deserialize<_i2.Colours>(data['data']);
    }
    if (data['className'] == 'ErrorMessage') {
      return deserialize<_i3.ErrorMessage>(data['data']);
    }
    if (data['className'] == 'Notice') {
      return deserialize<_i4.Notice>(data['data']);
    }
    if (data['className'] == 'ServerOptions') {
      return deserialize<_i5.ServerOptions>(data['data']);
    }
    if (data['className'] == 'UploadResult') {
      return deserialize<_i6.UploadResult>(data['data']);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
