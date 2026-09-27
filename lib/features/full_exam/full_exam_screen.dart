import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../mock/data.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';
import 'full_exam_store.dart';

final _writingT1 = writingTasks.firstWhere((t) => t.taskNumber == 1, orElse: () => writingTasks.first).id;
final _writingT2 = writingTasks.firstWhere((t) => t.taskNumber == 2, orElse: () => writingTasks.first).id;

/// (key, label, icon, minutes, detail, color). Exam order is fixed — Listening → Reading → Writing →
/// Speaking — and every section runs under exam conditions (`full=1`).
final _sections = [
  ('listening', 'Listening', Icons.headphones_rounded, 30, '4 parts · played once + 2-min check', AppColors.secondary),
  ('reading', 'Reading', Icons.menu_book_rounded, 60, '3 passages · 60 minutes', AppColors.success),
  ('writing', 'Writing', Icons.edit_rounded, 60, 'Task 1 (20 min) + Task 2 (40 min) · Task 2 counts double', AppColors.info),
  ('speaking', 'Speaking', Icons.mic_rounded, 15, '3 parts · 1-min Part 2 preparation', AppColors.primary),
];

/// Full-exam orchestrator (mirrors web `FullExamPage`): sections unlock strictly in order, no
/// per-section retake (Reset restarts the whole run), then the combined results.
class FullExamScreen extends StatefulWidget {
  const FullExamScreen({super.key});
  @override
  State<FullExamScreen> createState() => _FullExamScreenState();
}

class _FullExamScreenState extends State<FullExamScreen> {
  String _startRoute(String key) => switch (key) {
        'listening' => '/listening?full=1',
        'reading' => '/exam/reading?full=1',
        // resume at Task 2 when Task 1 is already graded
        'writing' => FullExamStore.has('writingT1')
            ? '/exam/writing/$_writingT2?full=1'
            : '/exam/writing/$_writingT1?full=1&next=$_writingT2',
        _ => '/speaking?full=1',
      };

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().isLocked('full-exam');
    final doneCount = FullExamStore.order.where(FullExamStore.has).length;
    final next = FullExamStore.next;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full IELTS exam'),
        actions: [
          if (doneCount > 0 || FullExamStore.has('writingT1'))
            TextButton(onPressed: () => setState(FullExamStore.reset), child: const Text('Reset')),
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
                    Text('All four sections in order, under exam conditions (about 2h 45m).',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                  ]),
                ),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: doneCount / FullExamStore.order.length,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Text('$doneCount of ${FullExamStore.order.length} sections complete',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          const SizedBox(height: 16),
          const SectionHeader('Sections'),
          for (final s in _sections) _card(context, s, next),
          if (next == null) ...[
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
        ],
      ),
    );
  }

  Widget _card(BuildContext context, (String, String, IconData, int, String, Color) s, String? next) {
    final band = FullExamStore.bands[s.$1];
    final done = band != null;
    final isNext = next == s.$1;
    final writingHalf = s.$1 == 'writing' && FullExamStore.has('writingT1') && !done;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: s.$6.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(s.$3, color: s.$6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(width: 8),
                if (done) const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                if (isNext && !done) const PillBadge('Up next', color: AppColors.primary),
              ]),
              Text(writingHalf ? 'Task 1 done · continue with Task 2' : '${s.$5} · ${s.$4}m',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
          ),
          if (done)
            Text('Band ${formatBand(band)}', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.bandTone(band)))
          else
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 40), padding: const EdgeInsets.symmetric(horizontal: 16)),
              // strict order: only the next section can be started; restart the whole run with Reset
              onPressed: isNext ? () => context.push(_startRoute(s.$1)) : null,
              child: Text(isNext ? (writingHalf ? 'Continue' : 'Start') : 'Locked'),
            ),
        ]),
      ),
    );
  }
}
