import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/brand.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _serverUrl;
  late final TextEditingController _password;
  late final TextEditingController _name;
  bool _busy = false;
  bool _register = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthState>();
    _email = TextEditingController(text: 'sara.hamzeh@example.com');
    _serverUrl = TextEditingController(text: auth.config.serverUrl);
    _password = TextEditingController();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _serverUrl.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final auth = context.read<AuthState>();
    if (_register && _name.text.trim().isEmpty) {
      _snack('Please enter your name.'); return;
    }
    if (_password.text.length < 8) {
      _snack('Password must be at least 8 characters.'); return;
    }
    setState(() => _busy = true);
    try {
      await auth.config.setServerUrl(_serverUrl.text);
      if (_register) {
        await auth.register(_email.text.trim(), _password.text, _name.text.trim());
      } else {
        await auth.login(_email.text.trim(), _password.text);
      }
      // The router redirect moves us to '/' once status == ready.
    } on ApiException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _fillDemo() {
    setState(() {
      _register = false;
      _email.text = 'sara.hamzeh@example.com';
      _password.text = 'yalla-demo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 36),
              decoration: const BoxDecoration(
                gradient: AppColors.warmGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: const Text(Brand.logoInitial,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
                  ),
                  const SizedBox(width: 10),
                  const Text(Brand.name,
                      style: TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 24),
                const Text(Brand.tagline,
                    style: TextStyle(
                        color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.2)),
                const SizedBox(height: 8),
                const Text(Brand.shortPitch,
                    style: TextStyle(color: Colors.white70, height: 1.4)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_register ? 'Create your account' : 'Welcome back',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const Text('Sign in to continue your IELTS journey.',
                    style: TextStyle(color: AppColors.mutedForeground)),
                const SizedBox(height: 20),
                if (_register) ...[
                  TextField(
                    key: const Key('login-name'),
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  key: const Key('login-email'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('login-password'),
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('login-server-url'),
                  controller: _serverUrl,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Server URL',
                    helperText: 'e.g. http://192.168.1.50:8080/api',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('login-submit'),
                    style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                    onPressed: _busy ? null : _signIn,
                    child: _busy
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : Text(_register ? 'Create account' : 'Sign in'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextButton(
                    onPressed: _busy ? null : () => setState(() => _register = !_register),
                    child: Text(_register ? 'I have an account' : 'Create an account'),
                  ),
                  TextButton(onPressed: _busy ? null : _fillDemo, child: const Text('Fill demo credentials')),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
