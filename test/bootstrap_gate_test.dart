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
import 'package:fluenta_mobile/router.dart';

Widget _app(AuthState auth, AppState app) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: app),
      ],
      child: MaterialApp.router(routerConfig: buildRouter(auth)),
    );

void main() {
  testWidgets('offline bootstrap shows the retry screen', (tester) async {
    SharedPreferences.setMockInitialValues({AppConfig.tokenKey: 't1'});
    final config = await AppConfig.load();
    final auth = AuthState(
        config: config,
        api: ApiClient(config,
            client: MockClient((_) async => throw Exception('down'))));
    final app = AppState()..bind(auth);
    await tester.pumpWidget(_app(auth, app));
    await auth.bootstrap();
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('no token routes to the login screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final config = await AppConfig.load();
    final auth = AuthState(
        config: config,
        api: ApiClient(config,
            client: MockClient((_) async => http.Response('', 500))));
    final app = AppState()..bind(auth);
    await tester.pumpWidget(_app(auth, app));
    await auth.bootstrap();
    await tester.pumpAndSettle();
    expect(find.textContaining('Welcome back'), findsOneWidget); // login hero copy
  });
}
