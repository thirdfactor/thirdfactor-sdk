// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

/// Represents the response object from the ThirdFactor Verification process.
class TfResponse {
  /// The verification status, indicating whether the process was successful (`true`) or not (`false`).
  final bool status;

  /// A message providing additional information about the verification result.
  final String message;

  /// Optional bytes representing an image associated with the verification result.
  final String? imageBytes;

  /// Creates a [TfResponse] instance with the provided properties.
  TfResponse({
    required this.status,
    required this.message,
    this.imageBytes,
  });

  /// Converts the [TfResponse] instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'imageUrl': imageBytes,
    };
  }

  /// Creates a [TfResponse] instance from a map.
  factory TfResponse.fromMap(Map<String, dynamic> map) {
    return TfResponse(
      status: map['status'] as bool,
      message: map['message'] as String,
      imageBytes: map['imageUrl'],
    );
  }

  /// Converts the [TfResponse] instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a [TfResponse] instance from a JSON string.
  factory TfResponse.fromJson(String source) =>
      TfResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Returns a string representation of the [TfResponse] instance.
  @override
  String toString() =>
      'TfResponse(status: $status, message: $message, imageBytes: $imageBytes)';
}
