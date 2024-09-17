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
import '../endpoints/notices_endpoint.dart' as _i2;
import 'package:talking_noticeboard_server/src/generated/notice.dart' as _i3;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'notices': _i2.NoticesEndpoint()
        ..initialize(
          server,
          'notices',
          null,
        )
    };
    connectors['notices'] = _i1.EndpointConnector(
      name: 'notices',
      endpoint: endpoints['notices']!,
      methodConnectors: {
        'addNotice': _i1.MethodConnector(
          name: 'addNotice',
          params: {
            'text': _i1.ParameterDescription(
              name: 'text',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'soundBytes': _i1.ParameterDescription(
              name: 'soundBytes',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint).addNotice(
            session,
            text: params['text'],
            soundBytes: params['soundBytes'],
          ),
        ),
        'deleteNotice': _i1.MethodConnector(
          name: 'deleteNotice',
          params: {
            'notice': _i1.ParameterDescription(
              name: 'notice',
              type: _i1.getType<_i3.Notice>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint).deleteNotice(
            session,
            params['notice'],
          ),
        ),
        'getNotices': _i1.MethodConnector(
          name: 'getNotices',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint).getNotices(session),
        ),
        'getSoundBytes': _i1.MethodConnector(
          name: 'getSoundBytes',
          params: {
            'filename': _i1.ParameterDescription(
              name: 'filename',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint).getSoundBytes(
            session,
            params['filename'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i4.Endpoints()..initializeEndpoints(server);
  }
}
