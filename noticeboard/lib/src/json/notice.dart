import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

/// A notice.
@JsonSerializable()
class Notice {
  /// Create an instance.
  const Notice({
    required this.text,
    this.soundPath,
  });

  /// Create an instance from a JSON object.
  factory Notice.fromJson(final Map<String, dynamic> json) =>
      _$NoticeFromJson(json);

  /// The text of the notice.
  final String text;

  /// The sound file to play.
  final String? soundPath;

  /// Convert an instance to JSON.
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
