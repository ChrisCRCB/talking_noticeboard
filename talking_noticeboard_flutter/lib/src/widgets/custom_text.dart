import 'package:flutter/material.dart';

/// A custom text widget.
class CustomText extends StatelessWidget {
  /// Create an instance.
  const CustomText(
    this.data, {
    super.key,
  });

  /// The data to show.
  final String data;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Text(
        data,
        style: const TextStyle(fontSize: 24),
      );
}
