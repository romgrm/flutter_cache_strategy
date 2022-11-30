import 'dart:io';

import 'package:dio/dio.dart';

import '../dto/error.dto.dart';

class RestException {
  final int? code;
  final String message;

  RestException(this.message, {this.code = 0});

  @override
  String toString() => message;

  static const String restErrorTimeout = "La connexion a été perdue";
  static const String restErrorNoConnection = "Pas de connexion internet";
  static const String restErrorNotFound = "La donnée n'a pas été trouvée";
  static const String restErrorUnauthorized = "Votre session a expirée, veuillez vous reconnecter";
  static const String restErrorForbidden = "Vous n'êtes pas autorisé à consulter cette donnée";
  static const String restErrorUnexpected = "Oups, une erreur est survenue";
  static const String restErrorData = "Erreur de données";
  static const String restErrorUnableToProcess = "Impossible de traiter les données";

  static RestException parseDioException(error) {
    if (error is Exception) {
      try {
        RestException restException;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              restException = RestException("Requête annulée");
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
                final errors = List<ErrorDto>.from(error.response?.data['errors'].map<ErrorDto>((json) => ErrorDto.fromJson(json)));
                switch (errors.first.code) {
                  case KnownError.missingParameters:
                    restException = RestException(errors.first.code!.message, code: responseCode);
                    break;
                  default:
                    restException = RestException("Un problème a été rencontré, nous mettons tout en oeuvre pour le résoudre. Code erreur : $responseCode", code: responseCode);
                }
              } catch (_) {
                switch (responseCode) {
                  case 401:
                    restException = RestException(restErrorUnauthorized, code: responseCode);
                    break;
                  case 403:
                    restException = RestException(restErrorForbidden, code: responseCode);
                    break;
                  case 404:
                    restException = RestException(restErrorNotFound, code: responseCode);
                    break;
                  case 408:
                    restException = RestException(restErrorTimeout, code: responseCode);
                    break;
                  default:
                    restException = RestException("Un problème a été rencontré, nous mettons tout en oeuvre pour le résoudre. Code erreur : $responseCode", code: responseCode);
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
