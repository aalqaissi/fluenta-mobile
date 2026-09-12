import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'avatarUrl': '', 'plan': 'pro', 'planLabel': 'Pro Monthly',
  'renewsInDays': 7, 'targetBand': 7.0, 'examDate': '2026-12-01',
  'saveHistory': true, 'track': 'ielts', 'examType': 'IELTS (Academic)',
  'purpose': 'Study Abroad', 'level': 'upper-intermediate', 'onboarded': true,
  'streak': {'current': 4, 'best': 11, 'last30': [0, 1, 2, 3]},
};

Future<AppConfig> _config({String? token}) async {
  SharedPreferences.setMockInitialValues(
      token == null ? {} : {AppConfig.tokenKey: token});
  return AppConfig.load();
}

void main() {
  test('login parses token + user and hits /api/auth/login', () async {
    final config = await _config();
    final api = ApiClient(config, client: MockClient((req) async {
      expect(req.url.path, '/api/auth/login');
      expect(jsonDecode(req.body)['email'], 'sara@example.com');
      return http.Response(jsonEncode({'token': 't1', 'user': _userJson}), 200,
          headers: {'content-type': 'application/json'});
    }));
    final result = await api.login('sara@example.com', 'yalla-demo');
    expect(result.token, 't1');
    expect(result.user.name, 'Sara Hamzeh');
    expect(result.user.onboarded, isTrue);
  });

  test('getMe attaches the bearer token', () async {
    final config = await _config(token: 't1');
    late String authHeader;
    final api = ApiClient(config, client: MockClient((req) async {
      authHeader = req.headers['Authorization'] ?? '';
      return http.Response(jsonEncode(_userJson), 200);
    }));
    await api.getMe();
    expect(authHeader, 'Bearer t1');
  });

  test('401 clears the token and throws ApiException(401)', () async {
    final config = await _config(token: 't1');
    final api = ApiClient(config, client: MockClient((req) async => http.Response('', 401)));
    await expectLater(
      api.getMe(),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 401)),
    );
    expect(config.token, isNull);
  });

  test('network failure surfaces ApiException(0)', () async {
    final config = await _config();
    final api = ApiClient(config, client: MockClient((req) async => throw Exception('down')));
    await expectLater(
      api.login('x@y.com', 'yalla-demo'),
      throwsA(isA<ApiException>().having((e) => e.status, 'status', 0)),
    );
  });
}
