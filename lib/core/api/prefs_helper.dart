import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class PrefsHelper {
  final SharedPreferences _sharedPreferences;
  PrefsHelper(this._sharedPreferences);

  static const String _keyAccessToken = 'access_token';
  static const String _keyManagerToken = 'manager_token';
  static const String _keyStoreId = 'store_id';

  Future<void> saveUserData({
    required String accessToken,
    required String managerToken,
    required String storeId,
  }) async {
    await _sharedPreferences.setString(_keyAccessToken, accessToken);
    await _sharedPreferences.setString(_keyManagerToken, managerToken);
    await _sharedPreferences.setString(_keyStoreId, storeId);
  }

  String? getAccessToken() => _sharedPreferences.getString(_keyAccessToken);
  String? getManagerToken() => _sharedPreferences.getString(_keyManagerToken);
  String? getStoreId() => _sharedPreferences.getString(_keyStoreId);

  Future<void> clearData() async {
    await _sharedPreferences.clear();
  }
}
