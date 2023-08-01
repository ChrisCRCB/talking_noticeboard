import 'package:json_annotation/json_annotation.dart';

import 'notice.dart';

part 'notices.g.dart';

/// A class to hold a list of [notices].
@JsonSerializable()
class Notices {
  /// Create an instance.
  const Notices(this.notices);

  /// Create an instance from [json].
  factory Notices.fromJson(final Map<String, dynamic> json) =>
      _$NoticesFromJson(json);

  /// The notices to display.
  final List<Notice> notices;

  /// Convert this instance to json.
  Map<String, dynamic> toJson() => _$NoticesToJson(this);
}
