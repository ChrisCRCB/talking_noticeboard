import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../widgets/text_list_tile.dart';

/// A screen to show commit errors.
class CommandErrorScreen extends StatelessWidget {
  /// Create an instance.
  const CommandErrorScreen({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
    super.key,
  });

  /// The exit code.
  final int exitCode;

  /// stdout.
  final String stdout;

  /// stderr.
  final String stderr;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: 'stdout',
              icon: Text('Standard output ($exitCode)'),
              builder: (final context) => TextListView(text: stdout),
            ),
            TabbedScaffoldTab(
              title: 'stderr',
              icon: Text('Standard error ($exitCode)'),
              builder: (final context) => TextListView(text: stderr),
            ),
          ],
        ),
      );
}
