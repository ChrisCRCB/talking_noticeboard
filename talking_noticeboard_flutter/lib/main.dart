import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'gen/assets.gen.dart';
import 'src/client.dart';
import 'src/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

/// The app class.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    RendererBinding.instance.ensureSemantics();
    return SoLoudScope(
      loadCustomSound: (final sourceLoader, final sound) async {
        try {
          if (kIsWeb || kIsWasm) {
            final bytes = await client.notices.getSoundBytes(sound.path);
            return sourceLoader.soLoud.loadMem(
              sound.path,
              bytes.buffer.asUint8List(),
            );
          }
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
            file.writeAsBytesSync(bytes.buffer.asUint8List());
          }
          return sourceLoader.loadSound(
            sound.copyWith(
              soundType: SoundType.file,
              path: file.path,
              loadMode: LoadMode.disk,
            ),
          );
          // ignore: avoid_catches_without_on_clauses
        } catch (e, s) {
          // ignore: avoid_print
          print('Error: $e\n$s');
          return sourceLoader.loadSound(
            sound.copyWith(
              path: Assets.sounds.error,
              soundType: SoundType.asset,
            ),
          );
        }
      },
      child: MaterialApp(
        title: 'Talking Noticeboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const HomePage(),
      ),
    );
  }
}
