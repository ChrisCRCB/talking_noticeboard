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
import 'dart:async' as _i2;
import 'package:talking_noticeboard_client/src/protocol/notice.dart' as _i3;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i4;
import 'protocol.dart' as _i5;

/// The endpoint for notices.
/// {@category Endpoint}
class EndpointNotices extends _i1.EndpointRef {
  EndpointNotices(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notices';

  /// Add a notice.
  _i2.Future<_i3.Notice> addNotice({
    required String text,
    required List<int> soundBytes,
  }) =>
      caller.callServerEndpoint<_i3.Notice>(
        'notices',
        'addNotice',
        {
          'text': text,
          'soundBytes': soundBytes,
        },
      );

  /// Delete [notice].
  _i2.Future<void> deleteNotice(_i3.Notice notice) =>
      caller.callServerEndpoint<void>(
        'notices',
        'deleteNotice',
        {'notice': notice},
      );

  /// List all notices.
  _i2.Future<List<_i3.Notice>> getNotices() =>
      caller.callServerEndpoint<List<_i3.Notice>>(
        'notices',
        'getNotices',
        {},
      );

  /// Get the contents of a sound file.
  _i2.Future<List<int>> getSoundBytes(String filename) =>
      caller.callServerEndpoint<List<int>>(
        'notices',
        'getSoundBytes',
        {'filename': filename},
      );
}

class _Modules {
  _Modules(Client client) {
    auth = _i4.Caller(client);
  }

  late final _i4.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i5.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    notices = EndpointNotices(this);
    modules = _Modules(this);
  }

  late final EndpointNotices notices;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {'notices': notices};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}