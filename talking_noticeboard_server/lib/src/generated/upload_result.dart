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

/// The result of uploading a file.
abstract class UploadResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  UploadResult._({
    required this.description,
    required this.path,
  });

  factory UploadResult({
    required String description,
    required String path,
  }) = _UploadResultImpl;

  factory UploadResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return UploadResult(
      description: jsonSerialization['description'] as String,
      path: jsonSerialization['path'] as String,
    );
  }

  /// The upload description.
  String description;

  /// The path where the file exists.
  String path;

  UploadResult copyWith({
    String? description,
    String? path,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'path': path,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'description': description,
      'path': path,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _UploadResultImpl extends UploadResult {
  _UploadResultImpl({
    required String description,
    required String path,
  }) : super._(
          description: description,
          path: path,
        );

  @override
  UploadResult copyWith({
    String? description,
    String? path,
  }) {
    return UploadResult(
      description: description ?? this.description,
      path: path ?? this.path,
    );
  }
}
