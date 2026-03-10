import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fsp_starter/core/auth/auth_notifier.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';
import 'package:fsp_starter/core/storage/jwt_storage.dart';

/// Interceptor to handle authentication, token addition, and refresh
class AuthInterceptor extends Interceptor {
  final JwtStorage _jwtStorage;
  final Dio _dio;
  final AuthNotifier _auth;

  bool _isRefreshing = false;
  final List<void Function()> _retryQueue = [];

  AuthInterceptor(this._jwtStorage, this._dio, this._auth);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async { 
    // Add Authorization header if access token is available
    final token = await _jwtStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // If it's not a 401 error or has already been retried or is refreshing the token, call forward the error.
    final response = err.response;
    if (
        response?.statusCode != 401 ||
        err.requestOptions.extra['retry'] == true ||
        err.requestOptions.extra['isRefreshApi'] == true ||
        _auth.authStatus != AuthStatus.authenticated
    ) {
      return handler.next(err);
    }

    log.w('[AuthInterceptor] ${err.requestOptions.method} ${err.requestOptions.uri} - 401 Unauthorized detected, attempting token refresh');


    // Queue the request to be retried after token refresh
    final completer = Completer<Response>();
    _retryQueue.add(() async { 
      try {
        final retryResponse  = _dio.fetch(err.requestOptions.copyWith(extra: {...err.requestOptions.extra, 'retry': true}));
        completer.complete(retryResponse);
      } catch (e) {
        completer.completeError(e);
      }
    });

    // If not already refreshing, start the token refresh process
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {

        // Call refresh token API
        final response = await _dio.get('/auth/refresh', 
          options: Options(
            extra: {'isRefreshApi': true}
          )
        );

        // Save new access token
        final newAccessToken = response.data['accessToken'] as String;
        await _jwtStorage.saveAccessToken(newAccessToken);

        // Retry all queued requests
        for (final retry in _retryQueue) {
          retry();
        }

      } catch (_) {
        // If refresh fails, clear tokens and fail all queued requests
        for (final retry in _retryQueue) {
          retry();
        }
        
        // all queued requests and tokens
        _retryQueue.clear();
        await _jwtStorage.clear();

        // handle logout if necessary
        _auth.setUnauthenticated();
      } finally {

        // Reset refreshing state
        _isRefreshing = false;

        // Clear the retry queue
        _retryQueue.clear();
      }
    }

    // Wait for the retried request to complete
    try {

      // Retrieve the response from the completer
      final response = await completer.future;

      // Return the retried response
      handler.resolve(response);
    } catch (e) {

      // If retry fails, forward the error
      handler.next(err);
    }
  }


}