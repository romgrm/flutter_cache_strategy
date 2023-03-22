import 'dart:io';

import 'package:dio/dio.dart';

import '../dto/error.dto.dart';

class RestException {
  final int? code;
  final String message;

  RestException(this.message, {this.code = 0});

  @override
  String toString() => message;

  static const String restErrorTimeout = "The connection has been lost ";
  static const String restErrorNoConnection = "No internet connection";
  static const String restErrorNotFound = "The data wasn't found";
  static const String restErrorUnauthorized = "Unauthorized";
  static const String restErrorForbidden = "Forbidden";
  static const String restErrorUnexpected = "Unexpected error";
  static const String restErrorData = "Error with the data";
  static const String restErrorUnableToProcess =
      "Unable to process the data further";

  static RestException parseDioException(error) {
    if (error is Exception) {
      try {
        RestException restException;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              restException = RestException("Cancel request");
              break;
            case DioErrorType.connectTimeout:
              restException = RestException(restErrorTimeout);
              break;
            case DioErrorType.other:
              restException = RestException(restErrorUnexpected);
              break;
            case DioErrorType.receiveTimeout:
              restException = RestException(restErrorTimeout);
              break;
            case DioErrorType.response:
              var responseCode = error.response?.statusCode;
              try {
                final errors = List<ErrorDto>.from(error
                    .response?.data['errors']
                    .map<ErrorDto>((json) => ErrorDto.fromJson(json)));
                switch (errors.first.code) {
                  case KnownError.missingParameters:
                    restException = RestException(errors.first.code!.message,
                        code: responseCode);
                    break;
                  default:
                    restException = RestException(
                        "An issue was raised. Error code : $responseCode",
                        code: responseCode);
                }
              } catch (_) {
                switch (responseCode) {
                  case 401:
                    restException = RestException(restErrorUnauthorized,
                        code: responseCode);
                    break;
                  case 403:
                    restException =
                        RestException(restErrorForbidden, code: responseCode);
                    break;
                  case 404:
                    restException =
                        RestException(restErrorNotFound, code: responseCode);
                    break;
                  case 408:
                    restException =
                        RestException(restErrorTimeout, code: responseCode);
                    break;
                  default:
                    restException = RestException(
                        "An issue was raised. Error code : $responseCode",
                        code: responseCode);
                }
              }
              break;
            case DioErrorType.sendTimeout:
              restException = RestException(restErrorTimeout);
              break;
          }
        } else if (error is SocketException) {
          restException = RestException(restErrorNoConnection);
        } else {
          restException = RestException(restErrorUnexpected);
        }
        return restException;
      } on FormatException {
        return RestException(restErrorData);
      } catch (_) {
        return RestException(restErrorUnexpected);
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return RestException(restErrorUnableToProcess);
      } else {
        return RestException(restErrorUnexpected);
      }
    }
  }
}
