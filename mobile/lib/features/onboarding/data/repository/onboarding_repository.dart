import 'package:fsp_starter/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepository {
  final SharedPreferences _prefs;

  OnboardingRepository(this._prefs);

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(StorageKeys.onboardingComplete, true);
  }
}