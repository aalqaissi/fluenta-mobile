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
import 'package:fluenta_mobile/features/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('completing onboarding PATCHes /me with onboarded:true', (tester) async {
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({AppConfig.tokenKey: 't1'});
    final config = await AppConfig.load();
    Map<String, dynamic>? sentPatch;
    final auth = AuthState(
      config: config,
      api: ApiClient(config, client: MockClient((req) async {
        sentPatch = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response(
            jsonEncode({
              'id': 'u1', 'name': 'New User', 'email': 'n@e.com', 'plan': 'free',
              'planLabel': 'Free', 'renewsInDays': 0, 'targetBand': 6.5,
              'examDate': null, 'saveHistory': true, 'onboarded': true,
              'streak': {'current': 0, 'best': 0, 'last30': []},
            }),
            200);
      })),
    );

    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: auth,
      child: const MaterialApp(home: OnboardingScreen()),
    ));

    // Step 1 -> 2
    await tester.tap(find.text("Let's get started!"));
    await tester.pumpAndSettle();
    // exam type default is set; pick a purpose
    await tester.tap(find.text('Study Abroad'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue')); // -> step 3
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue')); // date optional -> step 4
    await tester.pumpAndSettle();
    await tester.tap(find.text('Intermediate'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Complete setup'));
    await tester.pump(); // run the tap + setState(saving)
    await tester.pump(const Duration(milliseconds: 100)); // resolve updateMe future

    expect(sentPatch, isNotNull);
    expect(sentPatch!['onboarded'], true);
    expect(sentPatch!['purpose'], 'Study Abroad');
    expect(sentPatch!['level'], 'intermediate');
    expect(auth.user?.onboarded, true);
  });
}
