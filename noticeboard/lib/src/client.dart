import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

/// The client to use.
final client = Client(
  'http://backstreets.site:6080/',
)..connectivityMonitor = FlutterConnectivityMonitor();
