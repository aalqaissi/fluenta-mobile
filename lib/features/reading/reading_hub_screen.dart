import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../services/exam_convert.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

class ReadingHubScreen extends StatefulWidget {
  const ReadingHubScreen({super.key});
  @override
  State<ReadingHubScreen> createState() => _ReadingHubScreenState();
}

class _ReadingHubScreenState extends State<ReadingHubScreen> {
  late Future<List<ExamDto>> _future;
  ExamDto? _featured; // random pick, stable until the list reloads or the student shuffles

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  /// Every published reading exam — built-in and Content Studio alike.
  Future<List<ExamDto>> _load() async {
    final list = await context.read<AuthState>().api.listExams(skill: 'reading', status: 'published');
    _featured = pickRandom(list, avoid: _featured);
    return list;
  }

  int _questionCount(ExamDto e) {
    var n = 0;
    for (final p in (runnerContent(e)['passages'] as List? ?? [])) {
      for (final g in ((p as Map)['groups'] as List? ?? [])) {
        n += ((g as Map)['questions'] as List? ?? []).length;
      }
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reading practice')),
      body: FutureBuilder<List<ExamDto>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || (snap.data?.isEmpty ?? true)) {
            final msg = snap.error is ApiException
                ? (snap.error as ApiException).message
                : 'No reading exams are published yet.';
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.menu_book_rounded,
                  title: 'No reading practice yet',
                  description: msg,
                  action: FilledButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            );
          }
          final exams = snap.data!;
          final featured = _featured != null && exams.contains(_featured) ? _featured! : exams.first;
          return RefreshIndicator(
            onRefresh: () async {
              final next = _load();
              setState(() => _future = next);
              await next;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _featuredCard(featured, canShuffle: exams.length > 1, onShuffle: () => setState(() => _featured = pickRandom(exams, avoid: featured))),
                if (exams.length > 1) ...[
                  const SizedBox(height: 20),
                  const SectionHeader('More reading tests'),
                  for (final e in exams.where((e) => e != featured)) _row(e),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _featuredCard(ExamDto e, {required bool canShuffle, required VoidCallback onShuffle}) {
    final qs = _questionCount(e);
    final content = runnerContent(e);
    final mins = ((content['durationSec'] as num?)?.toInt() ?? 3600) ~/ 60;
    final passages = (content['passages'] as List?)?.length ?? 0;
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PillBadge('Picked for you', color: AppColors.success, icon: Icons.menu_book_rounded),
        const SizedBox(height: 8),
        Text(e.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.25)),
        const SizedBox(height: 6),
        Text('$passages passage${passages == 1 ? '' : 's'} · $qs questions',
            style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [
          _Meta(Icons.schedule_rounded, '$mins min'),
          const SizedBox(width: 16),
          _Meta(Icons.checklist_rounded, '$qs questions'),
          const SizedBox(width: 16),
          _Meta(Icons.school_rounded, e.module == 'general' ? 'General' : 'Academic'),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => context.push('/exam/reading?id=${e.id}'),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start reading exam'),
          ),
        ),
        if (canShuffle) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onShuffle,
              icon: const Icon(Icons.shuffle_rounded),
              label: const Text('Pick another'),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _row(ExamDto e) {
    final qs = _questionCount(e);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FluentaCard(
        onTap: () => context.push('/exam/reading?id=${e.id}'),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.menu_book_rounded, color: AppColors.success),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text('${(runnerContent(e)['passages'] as List?)?.length ?? 0} passages · $qs questions',
                  style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
            ]),
          ),
          const Icon(Icons.play_circle_outline_rounded, color: AppColors.primary),
        ]),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Meta(this.icon, this.text);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 15, color: AppColors.mutedForeground),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
    ]);
  }
}
