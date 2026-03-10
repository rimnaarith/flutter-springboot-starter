import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fsp_starter/core/auth/auth_notifier.dart';
import 'package:fsp_starter/core/network/auth_interceptor.dart';
import 'package:fsp_starter/core/network/logger_interceptor.dart';
import 'package:fsp_starter/core/storage/cookie_storage.dart';
import 'package:fsp_starter/core/storage/jwt_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );

  final cookieJar = ref.watch(cookieJarProvider);
  final jwtStorage = ref.read(jwtStorageProvider);
  final authNotifier = ref.read(authProvider.notifier);

  // Add CookieManager interceptor
  dio.interceptors.add(CookieManager(cookieJar));

  // Add AuthInterceptor
  dio.interceptors.add(AuthInterceptor(jwtStorage, dio, authNotifier));

  // Logger Interceptor
  dio.interceptors.add(LoggerInterceptor());

  return dio;
});