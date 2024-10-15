import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

/// An [AutoSizeText] which shows [text].
class NoticeText extends StatelessWidget {
  /// Create an instance.
  const NoticeText({
    required this.text,
    super.key,
  });

  /// The text to show.
  final String text;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Center(
        child: AutoSizeText(
          text,
          style: const TextStyle(
            fontSize: 200,
            color: Colors.white,
            backgroundColor: Colors.black,
          ),
        ),
      );
}
