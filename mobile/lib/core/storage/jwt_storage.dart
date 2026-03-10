
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fsp_starter/core/constants/storage_keys.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';
import 'package:fsp_starter/core/storage/secure_storage.dart';

/// Read/Write token to secure storage
class JwtStorage {

  final FlutterSecureStorage _storage;
  String? _accessToken;
  String? _refreshToken;

  JwtStorage(this._storage);

  Future<String?> getAccessToken() async {
    log.d('[JwtStorage] - Retrieving access token');
    // Check memory
    if (_accessToken != null) return _accessToken;

    log.d('[JwtStorage] - Access token not in memory, reading from disk');
    try {
      // Read from disk and SAVE to memory for next time
      _accessToken = await _storage.read(key: StorageKeys.accessToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error reading access token', error: e, stackTrace: st);
      rethrow;
    }
    return _accessToken;
  }

  Future<String?> getRefreshToken() async {
    log.d('[JwtStorage] - Retrieving refresh token');
    // Check memory
    if (_refreshToken != null) return _refreshToken;

    log.d('[JwtStorage] - Refresh token not in memory, reading from disk');
    try {
      // Read from disk and SAVE to memory for next time
      _refreshToken = await _storage.read(key: StorageKeys.refreshToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error reading refresh token', error: e, stackTrace: st);
      rethrow;
    }
    return _refreshToken;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {

    log.d('[JwtStorage] - Saving access and refresh tokens');

    try {
      // Write to disk
      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error saving tokens', error: e, stackTrace: st);
      rethrow;
    }

    // Update memory
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> saveAccessToken(String accessToken) async {
    log.d('[JwtStorage] - Saving access token');
    try {
      // Write to disk
      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error saving access token', error: e, stackTrace: st);
      rethrow;
    }

    // Update memory
    _accessToken = accessToken;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    log.d('[JwtStorage] - Saving refresh token');
    try {
      // Write to disk
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error saving refresh token', error: e, stackTrace: st);
      rethrow;
    }

    // Update memory
    _refreshToken = refreshToken;
  }

  Future<void> clear() async {
    log.d('[JwtStorage] - Clearing tokens from storage');
    try {
      await _storage.delete(key: StorageKeys.accessToken);
      await _storage.delete(key: StorageKeys.refreshToken);
    } catch (e, st) {
      log.e('[JwtStorage] - Error clearing tokens', error: e, stackTrace: st);
      rethrow;
    }
    _accessToken = null;
    _refreshToken = null;
  }
}

/// Provider for JwtStorage
final jwtStorageProvider = Provider<JwtStorage>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return JwtStorage(storage);
});