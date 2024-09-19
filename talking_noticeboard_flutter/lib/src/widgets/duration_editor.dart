import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

/// A widget for editing a [Duration] instance by modifying hours, minutes, and
/// seconds.
///
/// Code created by Chat GPT.
class DurationEditor extends StatefulWidget {
  /// Constructor for [DurationEditor] widget.
  const DurationEditor({
    required this.initialDuration,
    required this.onDurationChanged,
    super.key,
  });

  /// The current [Duration] value to be edited.
  final Duration initialDuration;

  /// Callback function to notify when the [Duration] changes.
  final ValueChanged<Duration> onDurationChanged;

  @override
  DurationEditorState createState() => DurationEditorState();
}

/// State for [DurationEditor].
class DurationEditorState extends State<DurationEditor> {
  /// Controller for the hours input field.
  late TextEditingController _hoursController;

  /// Controller for the minutes input field.
  late TextEditingController _minutesController;

  /// Controller for the seconds input field.
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with the initial values from the
    // [initialDuration].
    _hoursController =
        TextEditingController(text: widget.initialDuration.inHours.toString());
    _minutesController = TextEditingController(
      text: (widget.initialDuration.inMinutes % 60).toString(),
    );
    _secondsController = TextEditingController(
      text: (widget.initialDuration.inSeconds % 60).toString(),
    );
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the tree.
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  /// Helper method to update the duration based on the input values.
  void _updateDuration() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    // Create a new Duration instance based on user input.
    final newDuration =
        Duration(hours: hours, minutes: minutes, seconds: seconds);

    // Trigger the callback to notify the parent widget of the change.
    widget.onDurationChanged(newDuration);
  }

  @override
  Widget build(final BuildContext context) => Cancel(
        child: SimpleScaffold(
          title: 'Edit Duration',
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hours input field
              Flexible(
                child: TextFormField(
                  controller: _hoursController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Hours'),
                  onChanged: (final value) => _updateDuration(),
                ),
              ),
              const SizedBox(width: 10),

              // Minutes input field
              Flexible(
                child: TextFormField(
                  autofocus: true,
                  controller: _minutesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Minutes'),
                  onChanged: (final value) => _updateDuration(),
                ),
              ),
              const SizedBox(width: 10),

              // Seconds input field
              Flexible(
                child: TextFormField(
                  controller: _secondsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Seconds'),
                  onChanged: (final value) => _updateDuration(),
                ),
              ),
            ],
          ),
        ),
      );
}
