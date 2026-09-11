import 'package:shared_preferences/shared_preferences.dart';

/// Persisted app configuration: the backend base URL and the auth token.
/// Loaded once at startup; getters are synchronous, setters persist immediately.
class AppConfig {
  static const String serverUrlKey = 'yalla.serverUrl';
  static const String tokenKey = 'yalla.token';
  static const String defaultServerUrl = 'http://localhost:8080/api';

  final SharedPreferences _prefs;
  AppConfig(this._prefs);

  static Future<AppConfig> load() async =>
      AppConfig(await SharedPreferences.getInstance());

  String get serverUrl =>
      _normalize(_prefs.getString(serverUrlKey) ?? defaultServerUrl);

  Future<void> setServerUrl(String url) =>
      _prefs.setString(serverUrlKey, _normalize(url));

  String? get token => _prefs.getString(tokenKey);

  Future<void> setToken(String? value) => value == null
      ? _prefs.remove(tokenKey)
      : _prefs.setString(tokenKey, value);

  static String _normalize(String url) =>
      url.trim().replaceAll(RegExp(r'/+$'), '');
}
