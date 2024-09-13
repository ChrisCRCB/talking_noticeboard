import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

/// The client to use.
final client = Client(
  'http://backstreets.site:6080/',
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
)..connectivityMonitor = FlutterConnectivityMonitor();

/// The session manager to use.
final sessionManager = SessionManager(caller: client.modules.auth);
