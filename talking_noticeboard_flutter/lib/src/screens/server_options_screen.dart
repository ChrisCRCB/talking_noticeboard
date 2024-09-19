import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../client.dart';
import '../widgets/colour_list_tile.dart';
import '../widgets/duration_list_tile.dart';
import '../widgets/notice_text.dart';

/// A screen for editing server options.
class ServerOptionsScreen extends StatefulWidget {
  /// Create an instance.
  const ServerOptionsScreen({
    required this.serverOptions,
    super.key,
  });

  /// The server options to use.
  final ServerOptions serverOptions;

  /// Create state for this widget.
  @override
  ServerOptionsScreenState createState() => ServerOptionsScreenState();
}

/// State for [ServerOptionsScreen].
class ServerOptionsScreenState extends State<ServerOptionsScreen> {
  /// The server options to work on.
  late final ServerOptions serverOptions;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    serverOptions = widget.serverOptions;
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          actions: [
            ElevatedButton(
              onPressed: () => context.pushWidgetBuilder(
                (final _) => Cancel(
                  child: Material(
                    child: Focus(
                      autofocus: true,
                      child: NoticeText(
                        text:
                            'This is and example of how your notice text will '
                            'appear. Press escape when done.',
                        serverOptions: serverOptions,
                      ),
                    ),
                  ),
                ),
              ),
              child: const Text('Preview Text'),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await client.users.updateServerOptions(serverOptions);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  // ignore: avoid_catches_without_on_clauses
                } catch (e) {
                  if (context.mounted) {
                    await showMessage(context: context, message: e.toString());
                  }
                }
              },
              icon: const Icon(
                Icons.save,
                semanticLabel: 'Save',
              ),
            ),
          ],
          title: 'Server Options',
          body: ListView(
            shrinkWrap: true,
            children: [
              IntListTile(
                value: serverOptions.fontSize,
                onChanged: (final value) =>
                    setState(() => serverOptions.fontSize = value),
                title: 'Font size',
                autofocus: true,
                min: 6,
                modifier: 2,
              ),
              ColourListTile(
                colour: serverOptions.backgroundColour,
                title: 'Background colour',
                onChanged: (final colour) => setState(
                  () => serverOptions.backgroundColour = colour,
                ),
              ),
              ColourListTile(
                colour: serverOptions.textColour,
                title: 'Text colour',
                onChanged: (final colour) => setState(
                  () => serverOptions.textColour = colour,
                ),
              ),
              DurationListTile(
                duration: serverOptions.skipInterval,
                title:
                    'How much time must elapse before a notice can be skipped',
                onChanged: (final value) =>
                    setState(() => serverOptions.skipInterval = value),
              ),
              DurationListTile(
                duration: serverOptions.playLocationInterval,
                title: 'How often the location sound should play',
                onChanged: (final value) => setState(
                  () => serverOptions.playLocationInterval = value,
                ),
              ),
            ],
          ),
        ),
      );
}
