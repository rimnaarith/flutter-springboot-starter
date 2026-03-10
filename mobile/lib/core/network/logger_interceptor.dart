import 'package:dio/dio.dart';

import '../logging/app_logger.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.d('[DIO] ${options.method} ${options.uri} \nHeaders: ${options.headers} \nData: ${options.data}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.e(
      '[DIO][ERROR] ${err.requestOptions.method} ${err.requestOptions.uri} '
      '-> Status: ${err.response?.statusCode} '
      '-> Message: ${err.message}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    log.d('[DIO] ${response.requestOptions.method} ${response.requestOptions.uri} -> Status: ${response.statusCode} \nData: ${response.data}');
    handler.next(response);
  }
}