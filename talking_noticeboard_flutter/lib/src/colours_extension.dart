// ignore_for_file: prefer_single_quotes
import 'package:flutter/material.dart';
import 'package:talking_noticeboard_client/talking_noticeboard_client.dart';

import 'friendly_colour.dart';

/// Convert [Colours] to [Colors].
extension ColoursX on Colours {
  /// Return a Flutter-friendly color.
  Color get color => switch(this) {
    Colours.black => Colors.black,
    Colours.black12 => Colors.black12,
    Colours.black26 => Colors.black26,
    Colours.black38 => Colors.black38,
    Colours.black45 => Colors.black45,
    Colours.black54 => Colors.black54,
    Colours.black87 => Colors.black87,
    Colours.transparent => Colors.transparent,
    Colours.white => Colors.white,
    Colours.white10 => Colors.white10,
    Colours.white12 => Colors.white12,
    Colours.white24 => Colors.white24,
    Colours.white30 => Colors.white30,
    Colours.white38 => Colors.white38,
    Colours.white54 => Colors.white54,
    Colours.white60 => Colors.white60,
    Colours.white70 => Colors.white70,
  };

 /// Returns a list of friendly colours.
List<FriendlyColour> get friendlyColours => const [
    FriendlyColour(
      serverColour: Colours.black,
      flutterColour: Colors.black,
      description: "Completely opaque black.",
    ),
    FriendlyColour(
      serverColour: Colours.black12,
      flutterColour: Colors.black12,
      description: "Black with 12% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.black26,
      flutterColour: Colors.black26,
      description: "Black with 26% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.black38,
      flutterColour: Colors.black38,
      description: "Black with 38% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.black45,
      flutterColour: Colors.black45,
      description: "Black with 45% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.black54,
      flutterColour: Colors.black54,
      description: "Black with 54% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.black87,
      flutterColour: Colors.black87,
      description: "Black with 87% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.transparent,
      flutterColour: Colors.transparent,
      description: "Completely invisible.",
    ),
    FriendlyColour(
      serverColour: Colours.white,
      flutterColour: Colors.white,
      description: "Completely opaque white.",
    ),
    FriendlyColour(
      serverColour: Colours.white10,
      flutterColour: Colors.white10,
      description: "White with 10% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white12,
      flutterColour: Colors.white12,
      description: "White with 12% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white24,
      flutterColour: Colors.white24,
      description: "White with 24% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white30,
      flutterColour: Colors.white30,
      description: "White with 30% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white38,
      flutterColour: Colors.white38,
      description: "White with 38% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white54,
      flutterColour: Colors.white54,
      description: "White with 54% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white60,
      flutterColour: Colors.white60,
      description: "White with 60% opacity.",
    ),
    FriendlyColour(
      serverColour: Colours.white70,
      flutterColour: Colors.white70,
      description: "White with 70% opacity.",
    ),
  ];
}
