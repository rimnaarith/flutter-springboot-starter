import 'package:dio/dio.dart';

/// Standard Api Exception class to handle API errors.
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final Map<String, String>? errors;

  ApiException({
    this.statusCode,
    required this.message,
    this.errors,
  });

  factory ApiException.fromDio(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(message: 'Connection timeout');
    }

    if (e.type == DioExceptionType.badResponse) {
      final status = e.response?.statusCode;
      final data = e.response?.data;

      return ApiException(
        message: data is Map && data['message'] != null
            ? data['message'].toString()
            : 'Server error',
        statusCode: status,
        errors: data is Map && data['errors'] != null 
          ?  Map<String, String>.from(
              (data['errors'] as Map).map(
                (key, value) => MapEntry(key.toString(), value.toString()),
              ),
            ) 
          : null,
      );
    }

    if (e.type == DioExceptionType.cancel) {
      return ApiException(message: 'Request cancelled');
    }

    return ApiException(message: 'Unexpected error occurred');
  }

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, errors: $errors)';
}
