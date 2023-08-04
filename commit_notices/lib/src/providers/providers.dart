import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../dated_file_system_event.dart';

/// Provide the shared preference instance.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (final ref) => SharedPreferences.getInstance(),
);

/// Provide the list of directories to be watched.
final watchedDirectoriesProvider = FutureProvider<List<String>>(
  (final ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return sharedPreferences.getStringList(watchedDirectoriesKey) ?? [];
  },
);

/// Provide a watcher for the current directory.
final directoryChangesProvider =
    StreamProvider.autoDispose.family<List<DatedFileSystemEvent>, String>(
  (final ref, final directoryName) async* {
    final events = <DatedFileSystemEvent>[];
    yield events;
    final directory = Directory(directoryName);
    await for (final event in directory.watch(recursive: true)) {
      final relativePath = path.relative(event.path, from: directoryName);
      if (relativePath.startsWith('.') ||
          path.basename(relativePath) == noticesFilename) {
        continue;
      }
      events.add(DatedFileSystemEvent(event: event, timestamp: DateTime.now()));
      yield events;
    }
  },
);
