import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

/// A list view that allows the editing of watched directories.
class DirectoriesListView extends ConsumerStatefulWidget {
  /// Create an instance.
  const DirectoriesListView({super.key});

  /// Create state.
  @override
  DirectoriesListViewState createState() => DirectoriesListViewState();
}

/// State for [DirectoriesListView].
class DirectoriesListViewState extends ConsumerState<DirectoriesListView> {
  /// The directories that have been loaded.
  late final List<String> directories;

  /// Initialise [directories].
  @override
  void initState() {
    super.initState();
    directories = [];
  }

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value = ref.watch(watchedDirectoriesProvider);
    return value.when(
      data: (final data) {
        directories
          ..clear()
          ..addAll(data);
        return getListView();
      },
      error: ErrorListView.withPositional,
      loading: getListView,
    );
  }

  /// Get the list view.
  Widget getListView() {
    if (directories.isEmpty) {
      return const CenterText(
        text: 'You must watch some directories first.',
        autofocus: true,
      );
    }
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final directory = directories[index];
        return CommonShortcuts(
          child: ListTile(
            autofocus: index == 0,
            title: Text(directory),
            onTap: () => setClipboardText(directory),
          ),
        );
      },
      itemCount: directories.length,
    );
  }
}
