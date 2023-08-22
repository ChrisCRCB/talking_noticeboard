import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../providers/providers.dart';
import '../widgets/directories_list_view.dart';
import '../widgets/watcher_list_view.dart';

/// The main screen of the application.
class MainScreen extends ConsumerWidget {
  /// Create an instance.
  const MainScreen({super.key});

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(watchedDirectoriesProvider);
    return CommonShortcuts(
      newCallback: () => newDirectory(ref),
      child: value.when(
        data: (final data) {
          if (data.isEmpty) {
            return SimpleScaffold(
              title: 'Watched Directories',
              body: const DirectoriesListView(),
              floatingActionButton: getFloatingActionButton(ref),
            );
          }
          return TabbedScaffold(
            tabs: [
              TabbedScaffoldTab(
                title: 'Watched Directories',
                icon: const Text('The directories that will be watched'),
                builder: (final context) => const DirectoriesListView(),
                floatingActionButton: getFloatingActionButton(ref),
              ),
              ...data.map(
                (final e) {
                  final directory = Directory(e);
                  return TabbedScaffoldTab(
                    actions: [
                      ElevatedButton(
                        child: const Icon(
                          Icons.refresh,
                          semanticLabel: 'Rebuild JSON',
                        ),
                        onPressed: () {
                          if (directory.existsSync()) {
                            generateJson(context, directory);
                          }
                        },
                      ),
                    ],
                    title: path.basename(e),
                    icon: Icon(
                      directory.existsSync()
                          ? Icons.one_k_rounded
                          : Icons.warning,
                    ),
                    builder: (final context) => WatcherListView(path: e),
                    floatingActionButton: getFloatingActionButton(ref),
                  );
                },
              ),
            ],
          );
        },
        error: ErrorScreen.withPositional,
        loading: LoadingWidget.new,
      ),
    );
  }

  /// Get the floating action button.
  Widget getFloatingActionButton(final WidgetRef ref) => FloatingActionButton(
        onPressed: () => newDirectory(ref),
        tooltip: 'New Directory',
        child: const Icon(Icons.add),
      );

  /// Add a new directory.
  Future<void> newDirectory(final WidgetRef ref) async {
    final directoryName = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'New Directory',
    );
    if (directoryName == null) {
      return;
    }
    final directories = await ref.read(watchedDirectoriesProvider.future);
    directories.add(directoryName);
    final sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.setStringList(
      watchedDirectoriesKey,
      directories,
    );
    ref.invalidate(watchedDirectoriesProvider);
  }
}
