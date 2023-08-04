import 'dart:convert';
import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

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
}) {
  final result = Process.runSync(executable, arguments);
  if (result.exitCode != 0 && context.mounted) {
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
