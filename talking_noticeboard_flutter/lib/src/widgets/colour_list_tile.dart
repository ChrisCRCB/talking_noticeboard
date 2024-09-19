import 'package:backstreets_widgets/extensions.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../screens/select_colour.dart';

/// A [ListTile] which shows and allows the editing of a [colour].
class ColourListTile extends StatelessWidget {
  /// Create an instance.
  const ColourListTile({
    required this.colour,
    required this.title,
    required this.onChanged,
    super.key,
  });

  /// The colour to show.
  final Colours colour;

  /// The title of the [ListTile].
  final String title;

  /// The function to call when [colour] changes.
  final ValueChanged<Colours> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ListTile(
        title: Text(title),
        subtitle: Text(colour.name.titleCase),
        onTap: () => context.pushWidgetBuilder(
          (final _) => SelectColour(colour: colour, onChanged: onChanged),
        ),
      );
}
