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
import '../endpoints/users_endpoint.dart' as _i3;
import 'package:talking_noticeboard_server/src/generated/notice.dart' as _i4;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'notices': _i2.NoticesEndpoint()
        ..initialize(
          server,
          'notices',
          null,
        ),
      'users': _i3.UsersEndpoint()
        ..initialize(
          server,
          'users',
          null,
        ),
    };
    connectors['notices'] = _i1.EndpointConnector(
      name: 'notices',
      endpoint: endpoints['notices']!,
      methodConnectors: {
        'verifyUpload': _i1.MethodConnector(
          name: 'verifyUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint).verifyUpload(
            session,
            params['path'],
          ),
        ),
        'createUploadDescription': _i1.MethodConnector(
          name: 'createUploadDescription',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['notices'] as _i2.NoticesEndpoint)
                  .createUploadDescription(
            session,
            params['path'],
          ),
        ),
        'addNotice': _i1.MethodConnector(
          name: 'addNotice',
          params: {
            'text': _i1.ParameterDescription(
              name: 'text',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
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
            path: params['path'],
          ),
        ),
        'deleteNotice': _i1.MethodConnector(
          name: 'deleteNotice',
          params: {
            'notice': _i1.ParameterDescription(
              name: 'notice',
              type: _i1.getType<_i4.Notice>(),
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
            'path': _i1.ParameterDescription(
              name: 'path',
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
            params['path'],
          ),
        ),
      },
    );
    connectors['users'] = _i1.EndpointConnector(
      name: 'users',
      endpoint: endpoints['users']!,
      methodConnectors: {
        'getScopeNames': _i1.MethodConnector(
          name: 'getScopeNames',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['users'] as _i3.UsersEndpoint).getScopeNames(
            session,
            params['email'],
          ),
        ),
        'getScopes': _i1.MethodConnector(
          name: 'getScopes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['users'] as _i3.UsersEndpoint).getScopes(session),
        ),
        'updateScopes': _i1.MethodConnector(
          name: 'updateScopes',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'scopes': _i1.ParameterDescription(
              name: 'scopes',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['users'] as _i3.UsersEndpoint).updateScopes(
            session,
            params['email'],
            params['scopes'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i5.Endpoints()..initializeEndpoints(server);
  }
}
