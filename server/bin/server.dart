// ignore_for_file: avoid_catching_errors
import 'dart:io';

import 'package:noticeboard_backend/noticeboard_backend.dart';
import 'package:path/path.dart' as path;
import 'package:shelf_plus/shelf_plus.dart';

/// The extension for text files.
const textFileExtension = '.txt';

/// The extension for audio files.
const audioFileExtension = '.mp3';
void main(final List<String> arguments) {
  if (arguments.length != 1) {
    // ignore: avoid_print
    return print('You must specify the directory containing notices.');
  }
  shelfRun(
    () => initServer(arguments.single),
  );
}

/// Initialise the web server.
Handler initServer(final String directoryName) {
  final router = Router().plus;
  final directory = Directory(directoryName);
  router
    ..use(logRequests())
    ..get('/notices/', () {
      final notices = <Notice>[];
      for (final subdirectory in directory.listSync().whereType<Directory>()) {
        final files = subdirectory.listSync().whereType<File>();
        if (files.isEmpty) {
          continue;
        }
        File? textFile;
        File? audioFile;
        try {
          textFile = files.firstWhere(
            (final element) =>
                path.extension(element.path) == textFileExtension,
          );
        } on StateError {
          // textFile = null;
        }
        try {
          audioFile = files.firstWhere(
            (final element) =>
                path.extension(element.path) == audioFileExtension,
          );
        } on StateError {
          // audioFile = null;
        }
        if (textFile != null || audioFile != null) {
          notices.add(
            Notice(
              text: textFile?.readAsStringSync(),
              audioPath: audioFile == null
                  ? null
                  : Uri.encodeFull(path.basename(audioFile.parent.path)),
            ),
          );
        }
      }
      return {'notices': notices};
    })
    ..get('/audio/<audioPath>/', (final _, final audioPath) {
      final directory =
          Directory(path.join(directoryName, Uri.decodeFull(audioPath)));
      final files = directory.listSync().whereType<File>();
      return files.firstWhere(
        (final element) => path.extension(element.path) == audioFileExtension,
      );
    });
  return router;
}
