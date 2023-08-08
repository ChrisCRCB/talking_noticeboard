import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noticeboard_backend/noticeboard_backend.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../dated_file_system_event.dart';
import '../providers/providers.dart';

/// A screen that watches [path] for changes.
class WatcherListView extends ConsumerStatefulWidget {
  /// Create an instance.
  const WatcherListView({
    required this.path,
    super.key,
  });

  /// The path to watch.
  final String path;

  /// Create state.
  @override
  WatcherListViewState createState() => WatcherListViewState();
}

/// State for [WatcherListView].
class WatcherListViewState extends ConsumerState<WatcherListView> {
  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final directory = Directory(widget.path);
    if (directory.existsSync()) {
      final value = ref.watch(directoryChangesProvider(widget.path));
      return value.when(
        data: (final events) {
          if (events.isNotEmpty) {
            generateJson();
          }
          return getListView(events);
        },
        error: ErrorListView.withPositional,
        loading: () => getListView([]),
      );
    }
    return const CenterText(
      text: 'This directory does not exist.',
      autofocus: true,
    );
  }

  /// Get a list view which represents [events].
  Widget getListView(final List<DatedFileSystemEvent> events) {
    if (events.isEmpty) {
      return const CenterText(
        text: 'There is no activity on this directory yet.',
        autofocus: true,
      );
    }
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final datedFileSystemEvent = events[index];
        final event = datedFileSystemEvent.event;
        return Semantics(
          label: '$event [${datedFileSystemEvent.timestamp}]',
          child: ListTile(
            autofocus: index == 0,
            title: Text(datedFileSystemEvent.timestamp.toString()),
            subtitle: Text(event.toString()),
            onTap: () => setClipboardText(event.toString()),
          ),
        );
      },
      itemCount: events.length,
    );
  }

  /// Generate JSON.
  void generateJson() {
    final directory = Directory(widget.path);
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
  }
}
