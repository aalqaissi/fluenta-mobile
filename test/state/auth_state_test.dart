import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 'sara@example.com',
  'initials': 'SH', 'plan': 'pro', 'planLabel': 'Pro Monthly', 'renewsInDays': 7,
  'targetBand': 7.0, 'examDate': null, 'saveHistory': true, 'track': 'ielts',
  'onboarded': true, 'streak': {'current': 1, 'best': 2, 'last30': []},
};

Future<AuthState> _auth({String? token, required MockClient client}) async {
  SharedPreferences.setMockInitialValues(
      token == null ? {} : {AppConfig.tokenKey: token});
  final config = await AppConfig.load();
  return AuthState(config: config, api: ApiClient(config, client: client));
}

void main() {
  test('bootstrap with no token -> unauthed', () async {
    final auth = await _auth(client: MockClient((_) async => http.Response('', 500)));
    await auth.bootstrap();
    expect(auth.status, BootStatus.unauthed);
    expect(auth.user, isNull);
  });

  test('bootstrap with a valid token -> ready + user', () async {
    final auth = await _auth(
        token: 't1',
        client: MockClient((_) async => http.Response(jsonEncode(_userJson), 200)));
    await auth.bootstrap();
    expect(auth.status, BootStatus.ready);
    expect(auth.user?.name, 'Sara Hamzeh');
  });

  test('bootstrap when the host is unreachable -> offline', () async {
    final auth = await _auth(
        token: 't1', client: MockClient((_) async => throw Exception('down')));
    await auth.bootstrap();
    expect(auth.status, BootStatus.offline);
    expect(auth.error, isNotNull);
  });

  test('login stores the token and becomes ready', () async {
    final auth = await _auth(
        client: MockClient((_) async =>
            http.Response(jsonEncode({'token': 't2', 'user': _userJson}), 200)));
    await auth.login('sara@example.com');
    expect(auth.status, BootStatus.ready);
    expect(auth.config.token, 't2');
  });

  test('logout clears the token -> unauthed', () async {
    final auth = await _auth(
        token: 't1',
        client: MockClient((_) async => http.Response('{"ok":true}', 200)));
    await auth.logout();
    expect(auth.status, BootStatus.unauthed);
    expect(auth.config.token, isNull);
    expect(auth.user, isNull);
  });
}
