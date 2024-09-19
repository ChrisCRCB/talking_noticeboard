import 'package:backstreets_widgets/extensions.dart';
import 'package:flutter/material.dart';

import 'duration_editor.dart';

/// A [ListTile] which will display allow editing [duration].
class DurationListTile extends StatelessWidget {
  /// Create an instance.
  const DurationListTile({
    required this.duration,
    required this.title,
    required this.onChanged,
    super.key,
  });

  /// The duration to modify.
  final Duration duration;

  /// The title of the [ListTile].
  final String title;

  /// The function to call when [duration] changes.
  final ValueChanged<Duration> onChanged;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => ListTile(
        title: Text(title),
        subtitle: Text(formatDuration(duration)),
        onTap: () => context.pushWidgetBuilder(
          (final _) => DurationEditor(
            initialDuration: duration,
            onDurationChanged: onChanged,
          ),
        ),
      );

  /// Formats a [Duration] into a string in hh:mm:ss format.
  ///
  /// Code provided by Chat GPT.
  String formatDuration(final Duration duration) {
    // Calculate the hours, minutes, and seconds from the duration.
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    // Use two-digit formatting for minutes and seconds.
    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds = seconds.toString().padLeft(2, '0');

    // Return the formatted string as hh:mm:ss.
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}
