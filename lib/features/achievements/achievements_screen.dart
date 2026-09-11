import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

const _tierColors = {
  'bronze': Color(0xFFB07A45),
  'silver': Color(0xFF8E9BAE),
  'gold': Color(0xFFF5A524),
  'platinum': Color(0xFF0EA5A4),
  'diamond': Color(0xFF7C3AED),
};

IconData _achIcon(String name) {
  switch (name) {
    case 'Footprints':
      return Icons.directions_walk_rounded;
    case 'BookOpen':
      return Icons.menu_book_rounded;
    case 'Flame':
      return Icons.local_fire_department_rounded;
    case 'Target':
      return Icons.track_changes_rounded;
    case 'Trophy':
      return Icons.emoji_events_rounded;
    case 'Star':
      return Icons.star_rounded;
    case 'Zap':
      return Icons.bolt_rounded;
    case 'Award':
      return Icons.workspace_premium_rounded;
    default:
      return Icons.military_tech_rounded;
  }
}

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});
  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late Future<List<AchievementDto>> _future;
  String _filter = 'all'; // all | unlocked | locked

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthState>().api.getAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: FutureBuilder<List<AchievementDto>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.cloud_off_rounded,
                  title: 'Achievements unavailable',
                  description: snap.error is ApiException
                      ? (snap.error as ApiException).message
                      : 'Could not load achievements.',
                  action: FilledButton(
                    onPressed: () => setState(() =>
                        _future = context.read<AuthState>().api.getAchievements()),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            );
          }
          final all = snap.data!;
          final unlocked = all.where((a) => a.unlocked).toList();
          final points = unlocked.fold(0, (n, a) => n + a.points);
          final shown = switch (_filter) {
            'unlocked' => unlocked,
            'locked' => all.where((a) => !a.unlocked).toList(),
            _ => all,
          };
          // group by category
          final cats = <String, List<AchievementDto>>{};
          for (final a in shown) {
            cats.putIfAbsent(a.category, () => []).add(a);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              GradientCard(
                child: Row(children: [
                  const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$points points',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      Text('${unlocked.length} of ${all.length} achievements unlocked',
                          style: const TextStyle(color: Colors.white70)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 14),
              Row(children: [
                for (final f in ['all', 'unlocked', 'locked'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f[0].toUpperCase() + f.substring(1)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                  ),
              ]),
              const SizedBox(height: 8),
              for (final entry in cats.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                  child: Text(
                    entry.key[0].toUpperCase() + entry.key.substring(1),
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
                for (final a in entry.value) _card(a),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _card(AchievementDto a) {
    final tint = _tierColors[a.tier] ?? AppColors.primary;
    final locked = !a.unlocked;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
                color: (locked ? AppColors.mutedForeground : tint).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(13)),
            child: Icon(_achIcon(a.icon),
                color: locked ? AppColors.mutedForeground : tint),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                    child: Text(a.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: locked ? AppColors.mutedForeground : AppColors.foreground))),
                const SizedBox(width: 8),
                PillBadge(a.tier, color: tint),
              ]),
              const SizedBox(height: 2),
              Text(a.description,
                  style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
              if (locked && a.progress > 0) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: a.progress / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.muted,
                    valueColor: AlwaysStoppedAnimation(tint),
                  ),
                ),
              ],
            ]),
          ),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('+${a.points}',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: locked ? AppColors.mutedForeground : tint)),
            if (a.unlocked)
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)
            else
              Text('${a.progress}%',
                  style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
          ]),
        ]),
      ),
    );
  }
}
