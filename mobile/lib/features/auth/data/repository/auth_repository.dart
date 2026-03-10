import 'package:fsp_starter/core/core_providers.dart';
import 'package:fsp_starter/core/logging/app_logger.dart';
import 'package:fsp_starter/features/auth/data/models/auth_request.dart';
import 'package:fsp_starter/features/auth/data/models/login_response.dart';

class AuthRepository {
  final ApiClient _api;
  final JwtStorage _jwtStorage;
  final AuthNotifier _authNotifier;

  AuthRepository(this._api, this._jwtStorage, this._authNotifier);

  Future<void> login(String email, String password) async {
    try {

      var response = await _api.post<LoginResponse>(
        '/auth/login',
        data: AuthRequest(email: email, password: password).toJson(),
        parser: (data) => LoginResponse.fromJson(data),
      );


      // Save JWT access token
      await _jwtStorage.saveAccessToken(response.accessToken);
      // Update auth state
      _authNotifier.setAuthenticated();

    } catch (e) {
      log.e('[AuthRepository] - Login failed with error: $e');
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    await _api.post(
      '/auth/register',
      data: AuthRequest(email: email, password: password).toJson(),
    );
  }

  Future<void> test() async {
    await _api.get(
      '/users/my-info',
    );
  }

}
