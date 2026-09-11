import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/modals.dart';
import '../../widgets/ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final user = app.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Account & privacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.mail_outline_rounded, size: 18, color: AppColors.mutedForeground), SizedBox(width: 8), Text('Email', style: TextStyle(fontWeight: FontWeight.w800))]),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.muted.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                child: Text(user.email, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
              const Text('Email can\'t be changed. Contact support if you need to update it.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
            ]),
          ),
          const SizedBox(height: 14),
          const _ServerUrlCard(),
          const SizedBox(height: 14),
          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Privacy', style: TextStyle(fontWeight: FontWeight.w800)),
              const Text('Control your data and privacy settings.', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
              const SizedBox(height: 10),
              Row(children: [
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Save history', style: TextStyle(fontWeight: FontWeight.w700)),
                    Text('Save your exam history and progress for personalized insights.',
                        style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
                  ]),
                ),
                Switch(
                  value: user.saveHistory,
                  onChanged: (v) {
                    app.setSaveHistory(v);
                    showToast(context, v ? 'History saving on' : 'History saving off');
                  },
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          FluentaCard(
            border: Border.all(color: AppColors.destructive.withValues(alpha: 0.3)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.destructive), SizedBox(width: 8), Text('Danger zone', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.destructive))]),
              const SizedBox(height: 4),
              const Text('Irreversible actions that will permanently affect your account.',
                  style: TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.destructive, side: const BorderSide(color: Color(0x66DC2626))),
                onPressed: () async {
                  final ok = await showConfirm(context,
                      title: 'Are you absolutely sure?',
                      message: 'This will permanently delete your account and all of your data. This action cannot be undone.',
                      confirmLabel: 'Delete account');
                  if (ok && context.mounted) {
                    showToast(context, 'Account deleted (demo)');
                    context.read<AuthState>().logout();
                  }
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete account'),
              ),
            ]),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.destructive,
                side: const BorderSide(color: Color(0x66DC2626))),
            onPressed: () => context.read<AuthState>().logout(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

/// Editable, persisted backend Server URL — lets the owner-demo point the app
/// at the laptop's LAN IP over WiFi, and re-connect without reinstalling.
class _ServerUrlCard extends StatefulWidget {
  const _ServerUrlCard();
  @override
  State<_ServerUrlCard> createState() => _ServerUrlCardState();
}

class _ServerUrlCardState extends State<_ServerUrlCard> {
  late final TextEditingController _c;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: context.read<AuthState>().config.serverUrl);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _saveAndReconnect() async {
    final auth = context.read<AuthState>();
    setState(() => _busy = true);
    await auth.config.setServerUrl(_c.text);
    try {
      await auth.bootstrap(); // re-fetch /me against the new URL
      if (!mounted) return;
      showToast(context, 'Connected', description: auth.config.serverUrl);
    } on ApiException catch (e) {
      if (!mounted) return;
      showToast(context, 'Saved, but could not connect', description: e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.dns_outlined, size: 18, color: AppColors.mutedForeground),
          SizedBox(width: 8),
          Text('Server connection', style: TextStyle(fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 4),
        const Text('Point the app at the backend. On the same WiFi, use your laptop IP.',
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
        const SizedBox(height: 10),
        TextField(
          controller: _c,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            helperText: 'e.g. http://192.168.1.50:8080/api',
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _busy ? null : _saveAndReconnect,
            icon: _busy
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.sync_rounded, size: 18),
            label: const Text('Save & reconnect'),
          ),
        ),
      ]),
    );
  }
}
