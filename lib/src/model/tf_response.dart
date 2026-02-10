import 'dart:convert';

/// Represents the document photo with all associated attributes.
class DocumentPhoto {
  String? claimedDocType;
  DateTime? createdAt;
  String? detectedDocType;
  String? documentNumber;
  bool? isVerified;
  String? nationality;
  String? originalPhoto;
  String? photo;
  String? reason;

  DocumentPhoto({
    this.claimedDocType,
    this.createdAt,
    this.detectedDocType,
    this.documentNumber,
    this.isVerified,
    this.nationality,
    this.originalPhoto,
    this.photo,
    this.reason,
  });

  /// Creates a [DocumentPhoto] instance from a JSON map.
  factory DocumentPhoto.fromJson(Map<String, dynamic> json) => DocumentPhoto(
    claimedDocType: json["claimed_doc_type"],
    createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
    detectedDocType: json["detected_doc_type"],
    documentNumber: json["document_number"],
    isVerified: json["is_verified"],
    nationality: json["nationality"],
    originalPhoto: json["original_photo"].replaceFirst('data:image/jpeg;base64,', ''),
    photo: json["photo"],
    reason: json["reason"],
  );

  /// Converts the [DocumentPhoto] instance to a JSON map.
  Map<String, dynamic> toJson() => {
    "claimed_doc_type": claimedDocType,
    "created_at": createdAt?.toIso8601String(),
    "detected_doc_type": detectedDocType,
    "document_number": documentNumber,
    "is_verified": isVerified,
    "nationality": nationality,
    "original_photo": originalPhoto,
    "photo": photo,
    "reason": reason,
  };

  @override
  String toString() {
    return 'DocumentPhoto(claimedDocType: $claimedDocType, createdAt: $createdAt, detectedDocType: $detectedDocType, documentNumber: $documentNumber, isVerified: $isVerified, nationality: $nationality, originalPhoto: $originalPhoto, photo: $photo, reason: $reason)';
  }
}


/// Represents the response object containing the document photo information.
class TfResponse {
  /// Represents the list of document photos. It is now nullable.
  final List<DocumentPhoto>? documentPhotos;

  /// Creates a [TfResponse] instance with the provided list of document photos.
  TfResponse({
    this.documentPhotos,
  });

  /// Converts the [TfResponse] instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentPhoto': documentPhotos?.map((photo) => photo.toJson()).toList(), // Handle nullable documentPhotos
    };
  }

  /// Creates a [TfResponse] instance from a map.
  factory TfResponse.fromMap(Map<String, dynamic> map) {
    return TfResponse(
      documentPhotos: map['documentPhoto'] != null
          ? List<DocumentPhoto>.from(
          map['documentPhoto'].map((item) => DocumentPhoto.fromJson(item)))
          : null, // Handle possible null value
    );
  }

  /// Converts the [TfResponse] instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a [TfResponse] instance from a JSON string.
  factory TfResponse.fromJson(String source) =>
      TfResponse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TfResponse(documentPhoto: $documentPhotos)';
}


