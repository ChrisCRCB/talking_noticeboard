/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// Options for the server.
abstract class ServerOptions
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ServerOptions._({
    int? fontSize,
    _i2.Colours? backgroundColour,
    _i2.Colours? textColour,
    Duration? skipInterval,
    Duration? playLocationInterval,
    String? locationSoundFilename,
  })  : fontSize = fontSize ?? 48,
        backgroundColour = backgroundColour ?? _i2.Colours.black,
        textColour = textColour ?? _i2.Colours.white,
        skipInterval = skipInterval ??
            Duration(
              days: 0,
              hours: 0,
              minutes: 0,
              seconds: 5,
              milliseconds: 0,
            ),
        playLocationInterval = playLocationInterval ??
            Duration(
              days: 0,
              hours: 0,
              minutes: 10,
              seconds: 0,
              milliseconds: 0,
            ),
        locationSoundFilename = locationSoundFilename ?? 'location.wav';

  factory ServerOptions({
    int? fontSize,
    _i2.Colours? backgroundColour,
    _i2.Colours? textColour,
    Duration? skipInterval,
    Duration? playLocationInterval,
    String? locationSoundFilename,
  }) = _ServerOptionsImpl;

  factory ServerOptions.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerOptions(
      fontSize: jsonSerialization['fontSize'] as int,
      backgroundColour:
          _i2.Colours.fromJson((jsonSerialization['backgroundColour'] as int)),
      textColour:
          _i2.Colours.fromJson((jsonSerialization['textColour'] as int)),
      skipInterval:
          _i1.DurationJsonExtension.fromJson(jsonSerialization['skipInterval']),
      playLocationInterval: _i1.DurationJsonExtension.fromJson(
          jsonSerialization['playLocationInterval']),
      locationSoundFilename:
          jsonSerialization['locationSoundFilename'] as String,
    );
  }

  /// The size of the font.
  int fontSize;

  /// The background colour.
  _i2.Colours backgroundColour;

  /// The text colour.
  _i2.Colours textColour;

  /// How often notices can be skipped.
  Duration skipInterval;

  /// How often the location sound plays.
  Duration playLocationInterval;

  /// The file where the location sound is stored.
  String locationSoundFilename;

  ServerOptions copyWith({
    int? fontSize,
    _i2.Colours? backgroundColour,
    _i2.Colours? textColour,
    Duration? skipInterval,
    Duration? playLocationInterval,
    String? locationSoundFilename,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'backgroundColour': backgroundColour.toJson(),
      'textColour': textColour.toJson(),
      'skipInterval': skipInterval.toJson(),
      'playLocationInterval': playLocationInterval.toJson(),
      'locationSoundFilename': locationSoundFilename,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'fontSize': fontSize,
      'backgroundColour': backgroundColour.toJson(),
      'textColour': textColour.toJson(),
      'skipInterval': skipInterval.toJson(),
      'playLocationInterval': playLocationInterval.toJson(),
      'locationSoundFilename': locationSoundFilename,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ServerOptionsImpl extends ServerOptions {
  _ServerOptionsImpl({
    int? fontSize,
    _i2.Colours? backgroundColour,
    _i2.Colours? textColour,
    Duration? skipInterval,
    Duration? playLocationInterval,
    String? locationSoundFilename,
  }) : super._(
          fontSize: fontSize,
          backgroundColour: backgroundColour,
          textColour: textColour,
          skipInterval: skipInterval,
          playLocationInterval: playLocationInterval,
          locationSoundFilename: locationSoundFilename,
        );

  @override
  ServerOptions copyWith({
    int? fontSize,
    _i2.Colours? backgroundColour,
    _i2.Colours? textColour,
    Duration? skipInterval,
    Duration? playLocationInterval,
    String? locationSoundFilename,
  }) {
    return ServerOptions(
      fontSize: fontSize ?? this.fontSize,
      backgroundColour: backgroundColour ?? this.backgroundColour,
      textColour: textColour ?? this.textColour,
      skipInterval: skipInterval ?? this.skipInterval,
      playLocationInterval: playLocationInterval ?? this.playLocationInterval,
      locationSoundFilename:
          locationSoundFilename ?? this.locationSoundFilename,
    );
  }
}
