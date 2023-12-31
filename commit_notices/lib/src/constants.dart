import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:noticeboard_backend/noticeboard_backend.dart';
import 'package:path/path.dart' as path;

import 'command_context.dart';
import 'screens/command_error_screen.dart';

/// The key where the watched directories will be stored.
const watchedDirectoriesKey = 'commit_notices_watched_directories';

/// The extension for text files.
const textFileExtension = '.txt';

/// The extension for audio files.
const audioFileExtension = '.mp3';

/// The JSON encoder to use.
const jsonEncoder = JsonEncoder.withIndent('  ');

/// How long after changes are made should code be committed.
const commitChangesAfter = Duration(seconds: 5);

/// The file where notices are written.
const noticesFilename = 'notices.json';

/// Try and run the given command.
int runCommand({
  required final BuildContext context,
  required final String workingDirectory,
  required final String executable,
  required final List<String> arguments,
  final List<int> ignoredStatusCodes = const [],
}) {
  final result = Process.runSync(
    executable,
    arguments,
    workingDirectory: workingDirectory,
  );
  if ((result.exitCode != 0 && !ignoredStatusCodes.contains(result.exitCode)) &&
      context.mounted) {
    pushWidget(
      context: context,
      builder: (final context) => CommandErrorScreen(
        exitCode: result.exitCode,
        stdout: result.stdout.toString(),
        stderr: result.stderr.toString(),
      ),
    );
  }
  return result.exitCode;
}

/// Generate JSON.
Timer? generateJson(final BuildContext context, final Directory directory) {
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
        (final element) => path.extension(element.path) == textFileExtension,
      );
      // ignore: avoid_catching_errors
    } on StateError {
      // textFile = null;
    }
    try {
      audioFile = files.firstWhere(
        (final element) => path.extension(element.path) == audioFileExtension,
      );
      // ignore: avoid_catching_errors
    } on StateError {
      // audioFile = null;
    }
    if (textFile != null || audioFile != null) {
      notices.add(
        Notice(
          text: textFile?.readAsStringSync(),
          audioPath: audioFile == null
              ? null
              : Uri.encodeFull(
                  [
                    path.basename(audioFile.parent.path),
                    path.basename(audioFile.path),
                  ].join('/'),
                ),
        ),
      );
    }
  }
  final json = jsonEncoder.convert(Notices(notices));
  File(path.join(directory.path, noticesFilename)).writeAsStringSync(json);
  final gitDirectory = Directory(path.join(directory.path, '.git'));
  if (gitDirectory.existsSync()) {
    return Timer(commitChangesAfter, () {
      if (context.mounted) {
        for (final commandContext in [
          const CommandContext(command: 'git', arguments: ['add', '.']),
          const CommandContext(
            command: 'git',
            arguments: [
              'commit',
              '-m',
              'Automatically committed by commit_notices.',
            ],
          ),
          const CommandContext(command: 'git', arguments: ['push']),
        ]) {
          if (runCommand(
                context: context,
                workingDirectory: directory.path,
                executable: commandContext.command,
                arguments: commandContext.arguments,
                ignoredStatusCodes: [1],
              ) !=
              0) {
            return;
          }
        }
      }
    });
  }
  return null;
}
