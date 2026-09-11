import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

class _Item {
  final String key, title, sub, route;
  final String? lockKey;
  final bool soon;
  const _Item(this.key, this.title, this.sub, this.route, this.lockKey, {this.soon = false});
}

class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    const items = [
      _Item('reading', 'Reading', '3 passages · all 11 question types', '/reading', null),
      _Item('writing', 'Writing', 'Task 1 & 2', '/writing', null),
      _Item('listening', 'Listening', '4 sections, played once', '/listening', 'listening'),
      _Item('speaking', 'Speaking', '3 parts + Live Interview', '/speaking', 'speaking'),
      _Item('vocabulary', 'Vocabulary', 'Build your word bank', '', null, soon: true),
      _Item('grammar', 'Grammar', 'Targeted grammar drills', '', null, soon: true),
      _Item('general', 'Full IELTS exam', 'All four sections, timed', '/full-exam', 'full-exam'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const Text('Choose a skill to practice', style: TextStyle(color: AppColors.mutedForeground)),
          const SizedBox(height: 12),
          ...items.map((it) {
            final vis = skillVisual(it.key);
            final locked = it.lockKey != null && app.isLocked(it.lockKey!);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FluentaCard(
                onTap: () {
                  if (it.soon) {
                    showToast(context, '${it.title} practice is coming soon',
                        description: 'Tracked on your dashboard for now.');
                  } else {
                    context.push(it.route);
                  }
                },
                child: Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: vis.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                    child: Icon(vis.icon, color: vis.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(child: Text(it.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5))),
                        if (it.soon) ...[const SizedBox(width: 8), const PillBadge('Soon', color: AppColors.mutedForeground)],
                        if (locked) ...[const SizedBox(width: 8), const LockPill()],
                      ]),
                      const SizedBox(height: 2),
                      Text(it.sub, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
                    ]),
                  ),
                  Icon(it.soon ? Icons.lock_clock_outlined : Icons.chevron_right_rounded, color: AppColors.mutedForeground),
                ]),
              ),
            );
          }),
        ],
      ),
    );
  }
}
