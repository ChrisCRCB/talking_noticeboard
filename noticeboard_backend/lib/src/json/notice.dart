import 'package:json_annotation/json_annotation.dart';

part 'notice.g.dart';

/// A notice for the noticeboard.
@JsonSerializable()
class Notice {
  /// Create an instance.
  const Notice({
    required this.text,
    required this.audioPath,
  });

  /// Create an instance from [json].
  factory Notice.fromJson(final Map<String, dynamic> json) =>
      _$NoticeFromJson(json);

  /// The text of the notice.
  final String? text;

  /// The path where this audio can be downloaded from.
  final String? audioPath;

  /// Convert this instance to JSON.
  Map<String, dynamic> toJson() => _$NoticeToJson(this);
}
