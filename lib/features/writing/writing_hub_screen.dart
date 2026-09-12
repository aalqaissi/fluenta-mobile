import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../services/writing_convert.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

class WritingHubScreen extends StatefulWidget {
  const WritingHubScreen({super.key});
  @override
  State<WritingHubScreen> createState() => _WritingHubScreenState();
}

class _WritingHubScreenState extends State<WritingHubScreen> {
  List<WritingTask> _authored = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final exams = await context.read<AuthState>().api.listExams(skill: 'writing', status: 'published');
      final tasks = <WritingTask>[];
      for (final e in exams) {
        tasks.addAll(writingTasksFromContent(e.id, e.content));
      }
      if (mounted) setState(() { _authored = tasks; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _authored = const []; _loading = false; }); // samples still show
    }
  }

  Widget _card(WritingTask t, {bool authored = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: FluentaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                    color: (authored ? AppColors.success : AppColors.info).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.edit_rounded, color: authored ? AppColors.success : AppColors.info),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                PillBadge('Task ${t.taskNumber}', color: authored ? AppColors.success : AppColors.info),
                const SizedBox(height: 2),
                Text(t.kind, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 12),
            Text(t.prompt, style: const TextStyle(fontSize: 14, height: 1.45)),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.schedule_rounded, size: 15, color: AppColors.mutedForeground),
              const SizedBox(width: 4),
              Text('${t.durationSec ~/ 60} min', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
              const SizedBox(width: 14),
              const Icon(Icons.notes_rounded, size: 15, color: AppColors.mutedForeground),
              const SizedBox(width: 4),
              Text('min ${t.minWords} words', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: authored ? FilledButton.styleFrom(backgroundColor: AppColors.success) : null,
                onPressed: () => context.push('/exam/writing/${t.id}', extra: t),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(authored ? 'Take exam' : 'Start writing'),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().isLocked('writing');
    return Scaffold(
      appBar: AppBar(title: const Text('Writing practice')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (locked) const UpgradeBanner('Writing practice'),
          ...writingTasks.map((t) => _card(t)),
          if (_loading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: CircularProgressIndicator()))
          else if (_authored.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 6, 4, 12),
              child: Text('From your Content Studio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            ..._authored.map((t) => _card(t, authored: true)),
          ],
        ],
      ),
    );
  }
}
