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
import 'package:fluenta_mobile/state/app_state.dart';
import 'package:fluenta_mobile/features/overview/overview_screen.dart';

const _overview = {
  'targetBand': 7, 'currentAverage': 6, 'gapToTarget': 1, 'testsCompleted': 37,
  'skills': [
    {'key': 'reading', 'label': 'Reading', 'band': 6.0, 'tests': 9},
    {'key': 'writing', 'label': 'Writing', 'band': 5.5, 'tests': 5},
    {'key': 'listening', 'label': 'Listening', 'band': 6.5, 'tests': 8},
    {'key': 'speaking', 'label': 'Speaking', 'band': 6.0, 'tests': 4},
    {'key': 'vocabulary', 'label': 'Vocabulary', 'band': 6.5, 'tests': 6},
    {'key': 'grammar', 'label': 'Grammar', 'band': 5.5, 'tests': 5},
  ],
  'strongest': {'key': 'listening', 'label': 'Listening', 'band': 6.5},
  'weakest': {'key': 'writing', 'label': 'Writing', 'band': 5.5},
  'series': {
    'overall': [
      {'date': '2026-08-18', 'band': 4.5},
      {'date': '2026-08-25', 'band': 5.5},
      {'date': '2026-09-02', 'band': 6.0},
    ],
  },
  'recentActivity': [
    {'id': 'ra1', 'type': 'completed', 'skill': 'reading', 'title': 'Completed Reading Practice', 'date': '2026-09-04', 'band': 6.0},
  ],
};

void main() {
  testWidgets('Overview renders its sections and the 6-skill grid', (tester) async {
    tester.view.physicalSize = const Size(1000, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    final auth = AuthState(
      config: config,
      api: ApiClient(config,
          client: MockClient((_) async => http.Response(jsonEncode(_overview), 200))),
    );
    final app = AppState()..bind(auth);

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: app),
      ],
      child: const MaterialApp(home: OverviewScreen()),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Practice by Skill'), findsOneWidget);
    expect(find.text('Progress Report'), findsOneWidget);
    expect(find.text('Strengths & Weaknesses'), findsOneWidget);
    expect(find.text('Vocabulary'), findsWidgets); // in the skill grid
    expect(find.text('Soon'), findsWidgets); // vocabulary/grammar coming-soon pill
  });
}
