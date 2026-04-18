import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:zed_store_mangent/core/resources/app_string.dart';

import '../resources/app_strings.dart';

class ErrorHandler {
  static String handle(dynamic exception) {
    _logException(exception);
    
    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is FormatException) {
      return AppStrings.parseError;
    }

    if (exception is Exception) {
      return _handleGeneralException(exception);
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
      case DioExceptionType.unknown:
        return _detectNetworkError(exception) ? AppStrings.networkError : AppStrings.connectionError;

      case DioExceptionType.cancel:
        return AppStrings.unknownError;
    }
  }

  static String _handleHttpError(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return AppStrings.badRequestError;
      case 401:
        return AppStrings.unauthorizedError;
      case 403:
        return AppStrings.forbiddenError;
      case 404:
        return AppStrings.notFoundError;
      case 429:
        return 'خطا: تم تجاوز الحد المسموح به من الطلبات. الرجاء المحاولة لاحقًا.';
      case 500:
      case 502:
      case 503:
      case 504:
        return AppStrings.serverError;
      default:
        return _extractServerMessage(responseData) ?? AppStrings.unknownError;
    }
  }

  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('error')) return data['error'].toString();
      if (data.containsKey('description')) return data['description'].toString();
    }
    return null;
  }

  static String _handleGeneralException(Exception exception) {
    final message = exception.toString();

    if (message.contains('SocketException') || message.contains('socket')) {
      return AppStrings.networkError;
    }

    if (message.contains('TimeoutException')) {
      return AppStrings.timeoutError;
    }

    if (message.contains('FormatException')) {
      return AppStrings.parseError;
    }

    if (message.contains('FileSystemException')) {
      return AppStrings.fileNotFoundError;
    }

    if (message.contains('Permission') || message.contains('permission')) {
      return AppStrings.permissionDeniedError;
    }

    return AppStrings.unknownError;
  }

  static bool _detectNetworkError(DioException exception) {
    final error = exception.error;
    if (error == null) return false;
    
    final errorString = error.toString().toLowerCase();
    return errorString.contains('socket') ||
           errorString.contains('network') ||
           errorString.contains('connection') ||
           errorString.contains('refused');
  }

  static void _logException(dynamic exception) {
    if (exception is DioException) {
      debugPrint('DioException Type: ${exception.type}');
      debugPrint('Status Code: ${exception.response?.statusCode}');
      debugPrint('Message: ${exception.message}');
      debugPrint('Error: ${exception.error}');
    } else {
      debugPrint('Exception: $exception');
      debugPrint('Type: ${exception.runtimeType}');
    }
  }
}

