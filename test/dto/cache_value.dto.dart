class CacheValueDto {
  int id;
  String value;
  CacheValueDto({
    required this.id,
    required this.value,
  });

  static fromJson(Map<String, dynamic> json) =>
      CacheValueDto(id: json['id'] as int, value: json['value'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'value': value};
}
