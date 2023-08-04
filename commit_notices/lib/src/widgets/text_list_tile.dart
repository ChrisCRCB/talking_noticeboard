import 'package:backstreets_widgets/util.dart';
import 'package:flutter/material.dart';

/// A widget that shows [text] in a [ListView].
class TextListView extends StatelessWidget {
  /// Create an instance.
  const TextListView({
    required this.text,
    super.key,
  });

  /// The text to show.
  final String text;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final value =
        text.split('\n').where((final element) => element.isNotEmpty).toList();
    return ListView.builder(
      itemBuilder: (final context, final index) {
        final string = value[index];
        return ListTile(
          autofocus: index == 0,
          title: Text(string),
          onTap: () => setClipboardText(string),
        );
      },
      itemCount: value.length,
    );
  }
}
