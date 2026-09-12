import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/state/auth_state.dart';
import 'package:fluenta_mobile/features/auth/login_screen.dart';

const _userJson = {
  'id': 'u1', 'name': 'Sara Hamzeh', 'email': 's@e.com', 'plan': 'pro',
  'planLabel': 'Pro', 'renewsInDays': 7, 'targetBand': 7.0, 'examDate': null,
  'saveHistory': true, 'onboarded': true, 'streak': {'current': 0, 'best': 0, 'last30': []},
};

void main() {
  testWidgets('signing in calls the API and stores the token', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    final auth = AuthState(
      config: config,
      api: ApiClient(config, client: MockClient((_) async =>
          http.Response(jsonEncode({'token': 'tk', 'user': _userJson}), 200))),
    );
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: auth,
      child: const MaterialApp(home: LoginScreen()),
    ));
    await tester.enterText(find.byKey(const Key('login-email')), 's@e.com');
    await tester.enterText(find.byKey(const Key('login-password')), 'yalla-demo');
    await tester.ensureVisible(find.byKey(const Key('login-submit')));
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pumpAndSettle();
    expect(config.token, 'tk');
    expect(auth.status, BootStatus.ready);
  });
}
