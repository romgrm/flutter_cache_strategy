import 'package:dio/dio.dart';

class RestManager {
  static const defaultTimeout = 15000;

  final Dio _httpClient = Dio();

  Future get({required String path}) async {
    try {
      final response = await _httpClient.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
