import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

/// A friendly colour class.
class FriendlyColour {
  /// Create an instance.
  const FriendlyColour({
    required this.serverColour,
    required this.flutterColour,
    required this.description,
  });

  /// The server colour.
  final Colours serverColour;

  /// The Flutter colour.
  final Color flutterColour;

  /// The colour description.
  final String description;
}
