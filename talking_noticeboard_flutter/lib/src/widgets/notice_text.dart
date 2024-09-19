import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../colours_extension.dart';

/// A widget to show the [text] of a [Notice].
class NoticeText extends StatelessWidget {
  /// Create an instance.
  const NoticeText({
    required this.text,
    required this.serverOptions,
    super.key,
  });

  /// The text of the [Notice].
  final String text;

  /// The server options to use to display [text].
  final ServerOptions serverOptions;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: serverOptions.fontSize.toDouble(),
          color: serverOptions.textColour.color,
          backgroundColor: serverOptions.backgroundColour.color,
        ),
      );
}
