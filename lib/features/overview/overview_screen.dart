import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/brand.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';
import '../../widgets/modals.dart';

/// Home = the einstein-style Overview: practice-by-skill, progress report,
/// strengths & weaknesses, recent activity, streak, plan. Fed by GET /overview.
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});
  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late Future<Overview> _future;
  String _seriesKey = 'overall';

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthState>().api.getOverview();
  }

  Future<void> _reload() async {
    final f = context.read<AuthState>().api.getOverview();
    setState(() => _future = f);
    await f;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppState>().user;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
                gradient: AppColors.warmGradient, borderRadius: BorderRadius.circular(9)),
            alignment: Alignment.center,
            child: const Text(Brand.logoInitial,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 8),
          const Text(Brand.name),
        ]),
        actions: [
          IconButton(
              onPressed: () => showFeedbackSheet(context),
              icon: const Icon(Icons.forum_outlined)),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: () => context.go('/more'),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(user.initials,
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Overview>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final msg = snap.error is ApiException
                ? (snap.error as ApiException).message
                : 'Could not load your overview.';
            return EmptyStateView(
              icon: Icons.cloud_off_rounded,
              title: 'Overview unavailable',
              description: msg,
              action: FilledButton(onPressed: _reload, child: const Text('Retry')),
            );
          }
          final o = snap.data!;
          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                _hero(user, o),
                const SizedBox(height: 16),
                _progressReport(o),
                const SizedBox(height: 16),
                _practiceBySkill(o),
                const SizedBox(height: 16),
                _strengthsWeaknesses(o),
                const SizedBox(height: 16),
                _recentActivity(o),
                const SizedBox(height: 16),
                _streak(user),
                const SizedBox(height: 16),
                _plan(user),
              ],
            ),
          );
        },
      ),
    );
  }

  String get _firstName {
    final n = context.read<AppState>().user.name.trim();
    return n.isEmpty ? 'there' : n.split(' ').first;
  }

  Widget _hero(FluentaUser user, Overview o) {
    final examDate = user.examDate;
    final days = examDate?.difference(DateTime.now()).inDays;
    return GradientCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Welcome back, $_firstName 👋',
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(
          o.gapToTarget <= 0
              ? "You've reached your target band — keep it sharp!"
              : 'You are ${_band(o.gapToTarget)} away from your target band.',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 16),
        Row(children: [
          _heroTile('Target', _band(o.targetBand)),
          _heroDivider(),
          _heroTile('Average', _band(o.currentAverage)),
          _heroDivider(),
          _heroTile('Tests', '${o.testsCompleted}'),
          if (days != null) ...[_heroDivider(), _heroTile('Exam in', '${days}d')],
        ]),
      ]),
    );
  }

  Widget _heroTile(String label, String value) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ]),
      );

  Widget _heroDivider() => Container(
      width: 1, height: 34, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 12));

  Widget _progressReport(Overview o) {
    final keys = [...o.series.keys.where((k) => k != 'overall'), 'overall']
        .where((k) => o.series[k]?.isNotEmpty ?? false)
        .toList();
    if (!keys.contains(_seriesKey) && keys.isNotEmpty) _seriesKey = keys.last;
    final points = o.series[_seriesKey] ?? const [];
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader('Progress Report', subtitle: 'Band score over time'),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final k in keys)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(k == 'overall' ? 'Overall' : _label(k)),
                    selected: _seriesKey == k,
                    onSelected: (_) => setState(() => _seriesKey = k),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: points.length < 2
              ? const Center(
                  child: Text('Not enough data yet',
                      style: TextStyle(color: AppColors.mutedForeground)))
              : CustomPaint(
                  size: Size.infinite,
                  painter: _SeriesChartPainter(points,
                      AppColors.bandTone(points.last.band)),
                ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          _statTile('Tests', '${o.testsCompleted}'),
          _statTile('Average', _band(o.currentAverage)),
          _statTile('Gap', _band(o.gapToTarget)),
        ]),
      ]),
    );
  }

  Widget _statTile(String label, String value) => Expanded(
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
        ]),
      );

  Widget _practiceBySkill(Overview o) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader('Practice by Skill'),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.55,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [for (final s in o.skills) _skillCard(s)],
      ),
    ]);
  }

  Widget _skillCard(SkillStat s) {
    final vis = skillVisual(s.key);
    final soon = comingSoonSkills.contains(s.key);
    return FluentaCard(
      padding: const EdgeInsets.all(14),
      onTap: () {
        if (soon) {
          showToast(context, '${s.label} practice is coming soon',
              description: 'Tracked on your dashboard for now.');
        } else {
          context.push('/${s.key}');
        }
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: vis.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11)),
            child: Icon(vis.icon, color: vis.color, size: 20),
          ),
          const Spacer(),
          if (soon)
            const PillBadge('Soon', color: AppColors.mutedForeground)
          else
            Text(s.band == null ? '—' : _band(s.band!),
                style: TextStyle(
                    color: AppColors.bandTone(s.band),
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
        ]),
        const Spacer(),
        Text(s.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
        Text(soon ? 'Coming soon' : '${s.tests} test${s.tests == 1 ? '' : 's'}',
            style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
      ]),
    );
  }

  Widget _strengthsWeaknesses(Overview o) {
    final scored = o.skills.where((s) => s.band != null).toList();
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader('Strengths & Weaknesses'),
        Row(children: [
          if (o.strongest != null)
            Expanded(
              child: _swChip('Strongest', o.strongest!.label,
                  _band(o.strongest!.band), AppColors.success, Icons.arrow_upward_rounded),
            ),
          if (o.strongest != null && o.weakest != null) const SizedBox(width: 12),
          if (o.weakest != null)
            Expanded(
              child: _swChip('Focus area', o.weakest!.label, _band(o.weakest!.band),
                  AppColors.primary, Icons.arrow_downward_rounded),
            ),
        ]),
        const SizedBox(height: 14),
        for (final s in scored) _skillBar(s),
      ]),
    );
  }

  Widget _swChip(String label, String skill, String band, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ]),
        const SizedBox(height: 6),
        Text(skill, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text('Band $band', style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
      ]),
    );
  }

  Widget _skillBar(SkillStat s) {
    final v = (s.band ?? 0) / 9.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        SizedBox(width: 76, child: Text(s.label, style: const TextStyle(fontSize: 12.5))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: v,
              minHeight: 8,
              backgroundColor: AppColors.muted,
              valueColor: AlwaysStoppedAnimation(AppColors.bandTone(s.band)),
            ),
          ),
        ),
        SizedBox(
          width: 34,
          child: Text(s.band == null ? '—' : _band(s.band!),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        ),
      ]),
    );
  }

  Widget _recentActivity(Overview o) {
    if (o.recentActivity.isEmpty) return const SizedBox.shrink();
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader('Recent Activity'),
        for (final a in o.recentActivity.take(5)) _activityRow(a),
      ]),
    );
  }

  Widget _activityRow(ActivityItem a) {
    final (icon, color) = switch (a.type) {
      'completed' => (Icons.check_circle_rounded, AppColors.success),
      'submitted' => (Icons.upload_rounded, AppColors.info),
      'feedback' => (Icons.rate_review_rounded, AppColors.secondary),
      _ => (Icons.play_circle_outline_rounded, AppColors.mutedForeground),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
            Text(a.date, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 11.5)),
          ]),
        ),
        if (a.band != null) PillBadge('Band ${_band(a.band!)}', color: AppColors.bandTone(a.band)),
      ]),
    );
  }

  Widget _streak(FluentaUser user) {
    final s = user.streak;
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_fire_department_rounded, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text('${s.current}-day streak',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const Spacer(),
          Text('Best ${s.best}', style: const TextStyle(color: AppColors.mutedForeground)),
        ]),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final v in s.last30)
              Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  color: v == 0
                      ? AppColors.muted
                      : AppColors.secondary.withValues(alpha: 0.3 + v * 0.23),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ]),
    );
  }

  Widget _plan(FluentaUser user) {
    final isPro = context.watch<AppState>().isPro;
    return FluentaCard(
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.workspace_premium_rounded, color: AppColors.onSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(isPro ? user.planLabel : 'Free plan',
                style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(isPro ? 'Renews in ${user.renewsInDays} days' : 'Unlock all skills & AI feedback',
                style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
          ]),
        ),
        if (!isPro)
          FilledButton(onPressed: () => context.push('/checkout'), child: const Text('Upgrade')),
      ]),
    );
  }

  String _band(double b) => b == b.roundToDouble() ? b.toStringAsFixed(1) : b.toStringAsFixed(1);
  String _label(String key) {
    try {
      return SkillKey.values.firstWhere((s) => s.name == key).label;
    } catch (_) {
      return key[0].toUpperCase() + key.substring(1);
    }
  }
}

class _SeriesChartPainter extends CustomPainter {
  final List<SeriesPoint> points;
  final Color color;
  _SeriesChartPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const minB = 4.0, maxB = 9.0;
    final dx = size.width / (points.length - 1);
    double y(double band) =>
        size.height - ((band - minB) / (maxB - minB)).clamp(0, 1) * size.height;

    // gridlines
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (final b in [5.0, 6.0, 7.0, 8.0]) {
      canvas.drawLine(Offset(0, y(b)), Offset(size.width, y(b)), grid);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final p = Offset(dx * i, y(points[i].band));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    final fill = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round);
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(Offset(dx * i, y(points[i].band)), 2.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SeriesChartPainter old) =>
      old.points != points || old.color != color;
}
