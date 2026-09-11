import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';

void main() {
  test('defaults to localhost when unset', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    expect(config.serverUrl, 'http://localhost:8080/api');
  });

  test('persists and trims a trailing slash on the server URL', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    await config.setServerUrl('http://192.168.1.50:8080/api/');
    expect(config.serverUrl, 'http://192.168.1.50:8080/api');
  });

  test('stores and clears the token', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    expect(config.token, isNull);
    await config.setToken('abc123');
    expect(config.token, 'abc123');
    await config.setToken(null);
    expect(config.token, isNull);
  });
}
