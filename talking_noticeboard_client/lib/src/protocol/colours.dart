/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Possible colours.
enum Colours implements _i1.SerializableModel {
  /// Completely opaque black.
  black,

  /// Black with 12% opacity.
  black12,

  /// Black with 26% opacity.
  black26,

  /// Black with 38% opacity.
  black38,

  /// Black with 45% opacity.
  black45,

  /// Black with 54% opacity.
  black54,

  /// Black with 87% opacity.
  black87,

  /// Completely invisible.
  transparent,

  /// Completely opaque white.
  white,

  /// White with 10% opacity.
  white10,

  /// White with 12% opacity.
  white12,

  /// White with 24% opacity.
  white24,

  /// White with 30% opacity.
  white30,

  /// White with 38% opacity.
  white38,

  /// White with 54% opacity.
  white54,

  /// White with 60% opacity.
  white60,

  /// White with 70% opacity.
  white70;

  static Colours fromJson(int index) {
    switch (index) {
      case 0:
        return black;
      case 1:
        return black12;
      case 2:
        return black26;
      case 3:
        return black38;
      case 4:
        return black45;
      case 5:
        return black54;
      case 6:
        return black87;
      case 7:
        return transparent;
      case 8:
        return white;
      case 9:
        return white10;
      case 10:
        return white12;
      case 11:
        return white24;
      case 12:
        return white30;
      case 13:
        return white38;
      case 14:
        return white54;
      case 15:
        return white60;
      case 16:
        return white70;
      default:
        throw ArgumentError('Value "$index" cannot be converted to "Colours"');
    }
  }

  @override
  int toJson() => index;
  @override
  String toString() => name;
}
