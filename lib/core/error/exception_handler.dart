import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';

class ErrorHandler {
  static String handle(dynamic exception) {
    _logException(exception);

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is FormatException) {
      return AppStrings.parseError; 
    }


    return AppStrings.unknownError; 
  }

  static String _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return AppStrings.timeoutError;

      case DioExceptionType.connectionError:
        return AppStrings.networkError;

      case DioExceptionType.badResponse:
        return _handleHttpError(exception.response?.statusCode, exception.response?.data);

      case DioExceptionType.badCertificate:
        return AppStrings.connectionError;

      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      default:
        return AppStrings.unknownError;
    }
  }

  static String _handleHttpError(int? statusCode, dynamic responseData) {

    switch (statusCode) {
      case 400:
        return _extractServerMessage(responseData) ?? AppStrings.badRequestError;
      case 401:
        return AppStrings.unauthorizedError;
      case 403:
        return AppStrings.forbiddenError;
      case 404:
        return AppStrings.notFoundError;
      case 422:

        return _extractServerMessage(responseData) ?? AppStrings.badRequestError;
      case 429:
        return 'تم تجاوز الحد المسموح به من الطلبات. يرجى المحاولة لاحقاً.';
      case 500:
      case 502:
      case 503:
      case 504:
        return AppStrings.serverError; 
      default:
        return AppStrings.unknownError;
    }
  }

  static String? _extractServerMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {

        final message = data['message'] ?? data['error'] ?? data['description'];

        if (message != null && message.toString().isNotEmpty) {

          final msgLower = message.toString().toLowerCase();
          if (msgLower.contains('exception') ||
              msgLower.contains('stacktrace') ||
              msgLower.contains('sql') ||
              msgLower.contains('null pointer')) {
            return null;
          }
          return message.toString();
        }
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static void _logException(dynamic exception) {


    if (kDebugMode) {
      debugPrint('--- [ERROR LOG] ---');
      if (exception is DioException) {
        debugPrint('Type: ${exception.type}');
        debugPrint('Status Code: ${exception.response?.statusCode}');
        debugPrint('Response Data: ${exception.response?.data}');
      } else {
        debugPrint('Exception: $exception');
      }
      debugPrint('-------------------');
    }
  }
}
