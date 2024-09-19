import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

/// A widget to show the [text] of a [Notice].
class NoticeText extends StatelessWidget {
  /// Create an instance.
  const NoticeText({
    required this.text,
    super.key,
  });

  /// The text of the [Notice].
  final String text;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 48,
          color: Colors.white,
          backgroundColor: Colors.black,
        ),
      );
}
