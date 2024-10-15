import 'package:json_annotation/json_annotation.dart';

part 'app_preferences.g.dart';

/// The application preferences.
@JsonSerializable()
class AppPreferences {
  /// Create an instance.
  AppPreferences({
    this.fontSize = 400,
  });

  /// Create an instance from a JSON object.
  factory AppPreferences.fromJson(final Map<String, dynamic> json) =>
      _$AppPreferencesFromJson(json);

  /// The preferences key to use.
  static const preferencesKey = 'noticeboard_preferences';

  /// The font size to use.
  int fontSize;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$AppPreferencesToJson(this);
}
