import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';
import 'package:fluenta_mobile/state/app_state.dart';
import 'package:fluenta_mobile/models/models.dart';

void main() {
  test('unbound AppState falls back to the seed user', () {
    final app = AppState();
    expect(app.user.name, 'Sara Hamzeh'); // from mock/data currentUser
  });

  test('bound AppState reflects the AuthState user and rebuilds on change', () async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    const userJson = {
      'id': 'u9', 'name': 'Test Learner', 'email': 't@e.com', 'plan': 'free',
      'planLabel': 'Free', 'renewsInDays': 0, 'targetBand': 6.0, 'examDate': null,
      'saveHistory': true, 'onboarded': true,
      'streak': {'current': 0, 'best': 0, 'last30': []},
    };
    final auth = AuthState(
      config: config,
      api: ApiClient(config,
          client: MockClient((_) async =>
              http.Response(jsonEncode({'token': 't', 'user': userJson}), 200))),
    );
    final app = AppState()..bind(auth);
    var rebuilds = 0;
    app.addListener(() => rebuilds++);
    await auth.login('t@e.com');
    expect(app.user.name, 'Test Learner');
    expect(app.effectivePlan, PlanTier.free);
    expect(rebuilds, greaterThan(0));
  });
}
