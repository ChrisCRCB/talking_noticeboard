import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

/// The protocol to use for [client].
const clientProtocol = String.fromEnvironment('client_protocol');

/// The hostname to use for the [client].
const clientHostname = String.fromEnvironment('client_hostname');

/// The client to use.
final client = Client(
  '$clientProtocol://$clientHostname:6080/',
  authenticationKeyManager: FlutterAuthenticationKeyManager(),
)..connectivityMonitor = FlutterConnectivityMonitor();

/// The session manager to use.
final sessionManager = SessionManager(caller: client.modules.auth);
