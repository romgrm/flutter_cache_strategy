// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorDto _$ErrorDtoFromJson(Map<String, dynamic> json) => ErrorDto(
      id: json['id'] as String?,
      status: json['status'] as String,
      code: $enumDecodeNullable(_$KnownErrorEnumMap, json['code']),
      title: json['title'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$ErrorDtoToJson(ErrorDto instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'code': _$KnownErrorEnumMap[instance.code],
      'title': instance.title,
      'detail': instance.detail,
    };

const _$KnownErrorEnumMap = {
  KnownError.missingParameters: 'missingParameters',
  KnownError.unknown: 'unknown',
};
