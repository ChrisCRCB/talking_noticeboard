import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'src/client.dart';
import 'src/screens/noticeboard.dart';

void main() {
  runApp(const MyApp());
}

/// The top-level app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    RendererBinding.instance.ensureSemantics();
    return SoLoudScope(
      loadCustomSound: (final sourceLoader, final sound) async {
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final appDocumentsDirectory = Directory(
          path.join(documentsDirectory.path, 'talking_noticeboard'),
        );
        if (!appDocumentsDirectory.existsSync()) {
          appDocumentsDirectory.createSync(recursive: true);
        }
        final file = File(path.join(appDocumentsDirectory.path, sound.path));
        if (!file.existsSync()) {
          final bytes = await client.notices.getSoundBytes(sound.path);
          file.writeAsBytesSync(bytes);
        }
        return sourceLoader.loadSound(
          sound.copyWith(soundType: SoundType.file),
        );
      },
      child: MaterialApp(
        title: 'Noticeboard',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Noticeboard(),
      ),
    );
  }
}
