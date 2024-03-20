import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static const String _baseUrl = "_baseUrl";
  static const String _email = "_email";
  static const String _userId = "_userId";
  static const String _checkIfAccountCreated = "_checkIfAccountCreated";

  static void saveBaseUrl(String value) => _saveString(_baseUrl, value);

  static Future<String?> getBaseUrl() async => _getString(_baseUrl);

  static void saveEmail(String value) => _saveString(_email, value);

  static Future<String?> getEmail() async => _getString(_email);

  static void saveUserId(String value) => _saveString(_userId, value);

  static Future<String?> getUserId() async => _getString(_userId);

  ///Used to save/update account created
  static void saveUpdateCheckIfAccountCreated(bool value) =>
      _saveBoolean(_checkIfAccountCreated, value);

  static Future<bool?> get checkIfAccountCreated =>
      _getBool(_checkIfAccountCreated);

  static void logoutAccountCreated() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_checkIfAccountCreated);
  }

  static void _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static void _saveInteger(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static void _saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  static void _saveBoolean(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<String?> _getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<int?> _getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double?> _getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool?> _getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }
}
