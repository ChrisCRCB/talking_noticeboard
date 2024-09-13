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

/// An error message to send to clients.
abstract class ErrorMessage
    implements _i1.SerializableException, _i1.SerializableModel {
  ErrorMessage._({String? message})
      : message = message ?? 'An error has occurred.';

  factory ErrorMessage({String? message}) = _ErrorMessageImpl;

  factory ErrorMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ErrorMessage(message: jsonSerialization['message'] as String);
  }

  /// The message to show.
  String message;

  ErrorMessage copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {'message': message};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ErrorMessageImpl extends ErrorMessage {
  _ErrorMessageImpl({String? message}) : super._(message: message);

  @override
  ErrorMessage copyWith({String? message}) {
    return ErrorMessage(message: message ?? this.message);
  }
}
