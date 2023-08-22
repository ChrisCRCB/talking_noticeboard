import 'dart:io';

import 'package:backstreets_widgets/shortcuts.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      return CallbackShortcuts(
        bindings: {
          SingleActivator(
            LogicalKeyboardKey.keyR,
            control: useControlKey,
            meta: useMetaKey,
          ): () => generateJson(context, directory),
        },
        child: value.when(
          data: (final events) {
            if (events.isNotEmpty) {
              generateJson(context, directory);
            }
            return getListView(events);
          },
          error: ErrorListView.withPositional,
          loading: () => getListView([]),
        ),
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
}
