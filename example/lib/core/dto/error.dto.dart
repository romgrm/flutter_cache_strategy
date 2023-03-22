import 'package:json_annotation/json_annotation.dart';

part 'error.dto.g.dart';

@JsonSerializable()
class ErrorDto {
  final String? id;
  final String status;
  final KnownError? code;
  final String title;
  final String detail;
  ErrorDto({
    this.id,
    required this.status,
    this.code,
    required this.title,
    required this.detail,
  });

  factory ErrorDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDtoToJson(this);
}

enum KnownError {
  missingParameters,
  unknown,
}

extension KnownErrorExtension on KnownError {
  String get message {
    switch (this) {
      case KnownError.missingParameters:
        return "Paramètres manquants";
      case KnownError.unknown:
        return "Erreur inconnue";
    }
  }
}
