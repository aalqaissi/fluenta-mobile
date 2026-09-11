import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'full_exam_store.dart';

class FullExamResultsScreen extends StatefulWidget {
  const FullExamResultsScreen({super.key});
  @override
  State<FullExamResultsScreen> createState() => _FullExamResultsScreenState();
}

class _FullExamResultsScreenState extends State<FullExamResultsScreen> {
  bool _issuing = false;

  Future<void> _generateCertificate(double overall) async {
    final app = context.read<AppState>();
    final api = context.read<AuthState>().api;
    final l = FullExamStore.bands['listening'];
    final r = FullExamStore.bands['reading'];
    setState(() => _issuing = true);
    try {
      await api.createCertificate({
        'title': 'Full Practice Test — Academic',
        'candidate': app.user.name,
        'type': 'ielts-report',
        'module': 'academic',
        'centre': 'Online Practice',
        'issuedOn': DateTime.now().toIso8601String().split('T').first,
        'scores': {
          'listening': l ?? overall,
          'reading': r ?? overall,
          'writing': overall,
          'speaking': overall,
        },
        'overall': overall,
        'cefr': cefrForBand(overall),
        'comments':
            'Practice Test Report. Listening & Reading are auto-scored; Writing & Speaking are estimates (AI grading coming soon).',
        'status': 'issued',
      });
      if (!mounted) return;
      showToast(context, 'Certificate issued', description: 'Find it under Certificates.');
      context.go('/certificates');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _issuing = false);
      showToast(context, 'Could not issue certificate', description: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final overall = FullExamStore.overall;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/')),
        title: const Text('Full exam results'),
      ),
      body: overall == null
          ? const Padding(
              padding: EdgeInsets.all(24),
              child: EmptyStateView(
                icon: Icons.emoji_events_outlined,
                title: 'No results yet',
                description: 'Complete the Listening and Reading sections to see your combined band.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                GradientCard(
                  child: Row(children: [
                    Column(children: [
                      Text(formatBand(overall),
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
                      const Text('Overall band', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Mock exam complete', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('CEFR ${cefrForBand(overall)} · scored from Listening & Reading',
                            style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                const SectionHeader('By section'),
                _skillRow('Listening', 'listening', scored: true),
                _skillRow('Reading', 'reading', scored: true),
                _skillRow('Writing', 'writing', scored: false),
                _skillRow('Speaking', 'speaking', scored: false),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
                    onPressed: _issuing ? null : () => _generateCertificate(overall),
                    icon: _issuing
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.workspace_premium_rounded, size: 18),
                    label: const Text('Generate certificate'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Back to home'),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _skillRow(String label, String key, {required bool scored}) {
    final band = FullExamStore.bands[key];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: skillVisual(key).color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(11)),
            child: Icon(skillVisual(key).icon, color: skillVisual(key).color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))),
          if (band != null)
            Text('Band ${formatBand(band)}',
                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.bandTone(band)))
          else if (scored)
            const Text('Not taken', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12.5))
          else
            const PillBadge('AI soon', color: AppColors.mutedForeground),
        ]),
      ),
    );
  }
}
