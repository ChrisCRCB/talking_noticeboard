import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'src/screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      fullScreen: true,
      skipTaskbar: true,
      center: true,
      alwaysOnTop: true, // This hide the taskbar and appear the app on top
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  FlutterError
      .presentError = (final details, {final forceReport = false}) async {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      exit(255);
    }
    final file = File(
      path.join(directory.path, 'errors - ${now.year}-$month-$day.txt'),
    );
    try {
      final renderer = TextTreeRenderer();
      final string = renderer
          .render(details.toDiagnosticsNode(style: DiagnosticsTreeStyle.error))
          .trimRight();
      debugPrint(string);
      if (file.existsSync()) {
        file.openSync(mode: FileMode.append)
          ..writeStringSync(string)
          ..flushSync()
          ..closeSync();
      } else {
        file.writeAsStringSync(string);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      exit(1);
    }
  };

  runApp(const MyApp());
}

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    const variableName = 'NOTICES_DIR';
    final noticesDirectory = Platform.environment[variableName];
    return MaterialApp(
      title: 'Noticeboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: noticesDirectory == null || noticesDirectory.isEmpty
          ? ErrorScreen(
              error: UnsupportedError(
                // ignore: lines_longer_than_80_chars
                'You must first set the `$variableName` environment variable.',
              ),
            )
          : HomePage(noticesDirectory: Directory(noticesDirectory)),
    );
  }
}
