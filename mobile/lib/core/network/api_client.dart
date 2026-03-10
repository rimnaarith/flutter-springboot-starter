import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/network/api_exception.dart';
import 'package:fsp_starter/core/network/dio_provider.dart';
class ApiClient {
  final Dio _dio;
  final String baseUrl;

  ApiClient({required Dio dio, required this.baseUrl}) : _dio = dio {
    _dio.options.baseUrl = baseUrl;
  }

  /// Generic GET request
  /// 
  /// [T] is the expected return type
  /// 
  /// throws [ApiException] on error
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _request<T>(
      path,
      queryParameters: queryParameters,
      method: 'GET',
      cancelToken: cancelToken,
      parser: parser,
    );
  }


  /// Generic POST request
  /// 
  /// [T] is the expected return type
  /// 
  /// throws [ApiException] on error
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      method: 'POST',
      cancelToken: cancelToken,
      parser: parser,
    );
    
  }

  /// Generic PUT request
  /// 
  /// [T] is the expected return type
  /// 
  /// throws [ApiException] on error
  Future<T> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    return _request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      method: 'PUT',
      cancelToken: cancelToken,
      parser: parser,
    );
  }

  /// Generic DELETE request
  /// 
  /// [T] is the expected return type
  /// 
  /// throws [ApiException] on error
  Future<T> delete<T>(String path) async {
    return _request<T>(
      path,
      method: 'DELETE',
    );
  }


  /// Generic request handler
  /// 
  /// [T] is the expected return type
  /// 
  /// throws [ApiException] on error
  Future<T> _request<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    String method = 'GET',
    CancelToken? cancelToken,
    T Function(dynamic data)? parser,
  }) async {
    try {
      var response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
        cancelToken: cancelToken,
      );
      return parser != null ? parser(response.data) : response.data as T;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return ApiClient(
    baseUrl: Platform.isAndroid
        ? 'http://10.0.2.2:8222/api/v1'
        : 'http://localhost:8222/api/v1',
    dio: dio,
  );
});
