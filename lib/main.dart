import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'config/brand.dart';
import 'router.dart';
import 'services/api_client.dart';
import 'state/app_state.dart';
import 'state/auth_state.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await AppConfig.load();
  final auth = AuthState(config: config, api: ApiClient(config));
  final app = AppState()..bind(auth);
  auth.bootstrap(); // fire-and-forget; the gate reacts to status
  runApp(FluentaApp(auth: auth, app: app));
}

class FluentaApp extends StatelessWidget {
  final AuthState auth;
  final AppState app;
  const FluentaApp({super.key, required this.auth, required this.app});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: app),
      ],
      child: MaterialApp.router(
        title: Brand.name,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: buildRouter(auth),
      ),
    );
  }
}
