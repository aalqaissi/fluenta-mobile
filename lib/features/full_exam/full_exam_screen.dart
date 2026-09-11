import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'full_exam_store.dart';

/// Full-exam orchestrator: runs the two objectively-scored sections (Listening,
/// Reading) back-to-back in "full mode" (each records its band and returns here),
/// then unlocks the combined results. Writing/Speaking are offered as extra
/// practice (AI-graded — not scored yet).
const _scored = [
  ('listening', 'Listening', Icons.headphones_rounded, 30, '4 sections', '/listening?full=1', AppColors.secondary),
  ('reading', 'Reading', Icons.menu_book_rounded, 60, '3 passages', '/exam/reading?full=1', AppColors.success),
];
const _extra = [
  ('Writing', Icons.edit_rounded, 60, 'Task 1 & Task 2', AppColors.info),
  ('Speaking', Icons.mic_rounded, 15, '3 parts', AppColors.primary),
];

class FullExamScreen extends StatefulWidget {
  const FullExamScreen({super.key});
  @override
  State<FullExamScreen> createState() => _FullExamScreenState();
}

class _FullExamScreenState extends State<FullExamScreen> {
  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().isLocked('full-exam');
    final doneCount = FullExamStore.scoredSkills.where(FullExamStore.has).length;
    final allDone = FullExamStore.allScoredDone;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full IELTS exam'),
        actions: [
          if (doneCount > 0)
            TextButton(
              onPressed: () => setState(FullExamStore.reset),
              child: const Text('Reset'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (locked) const UpgradeBanner('The full IELTS exam'),
          GradientCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Complete mock exam', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    Text('Sit the scored sections back-to-back, then get a combined band.', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                  ]),
                ),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: doneCount / FullExamStore.scoredSkills.length,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text('$doneCount of ${FullExamStore.scoredSkills.length} scored sections complete',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 16),
          const SectionHeader('Scored sections'),
          for (final s in _scored) _scoredCard(context, s),
          if (allDone) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 52), backgroundColor: AppColors.success),
                onPressed: () => context.push('/results/full'),
                icon: const Icon(Icons.emoji_events_rounded, size: 18),
                label: const Text('See your combined results'),
              ),
            ),
          ],
          const SizedBox(height: 20),
          const SectionHeader('Extra practice', subtitle: 'AI feedback is coming soon — not scored yet'),
          for (final e in _extra) _extraCard(context, e),
        ],
      ),
    );
  }

  Widget _scoredCard(BuildContext context, (String, String, IconData, int, String, String, Color) s) {
    final band = FullExamStore.bands[s.$1];
    final done = band != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: s.$7.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(s.$3, color: s.$7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                if (done) const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              ]),
              Text('${s.$5} · ${s.$4}m', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
          ),
          if (done)
            Column(children: [
              Text('Band ${formatBand(band)}',
                  style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.bandTone(band))),
              GestureDetector(
                onTap: () => context.push(s.$6),
                child: const Text('Retake', style: TextStyle(fontSize: 11.5, color: AppColors.primary)),
              ),
            ])
          else
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 40), padding: const EdgeInsets.symmetric(horizontal: 16)),
              onPressed: () => context.push(s.$6),
              child: const Text('Start'),
            ),
        ]),
      ),
    );
  }

  Widget _extraCard(BuildContext context, (String, IconData, int, String, Color) e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        onTap: () => context.push('/${e.$1.toLowerCase()}'),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: e.$5.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(e.$2, color: e.$5),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('${e.$4} · ${e.$3}m', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
          ),
          const PillBadge('AI soon', color: AppColors.mutedForeground),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mutedForeground),
        ]),
      ),
    );
  }
}
