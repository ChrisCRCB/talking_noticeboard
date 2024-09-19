import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import '../colours_extension.dart';

/// A screen to select a new colour.
class SelectColour extends StatelessWidget {
  /// Create an instance.
  const SelectColour({
    required this.colour,
    required this.onChanged,
    super.key,
  });

  /// The current colour.
  final Colours colour;

  /// The function to call when [colour] changes.
  final ValueChanged<Colours> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final possibleColours = colour.friendlyColours;
    return Cancel(
      child: SimpleScaffold(
        title: 'Select Colour',
        body: BuiltSearchableListView(
          items: possibleColours,
          builder: (final context, final index) {
            final friendlyColour = possibleColours[index];
            final serverColour = friendlyColour.serverColour;
            final name = serverColour.name.titleCase;
            return SearchableListTile(
              searchString: name,
              child: ListTile(
                autofocus: index == 0,
                selected: friendlyColour.serverColour == colour,
                title: Text(name),
                subtitle: Text(friendlyColour.description),
                onTap: () {
                  Navigator.pop(context);
                  onChanged(serverColour);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
