import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

Future<void> showTrackSwitcher(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _TrackSheet(),
  );
}

IconData _trackIcon(String name) {
  switch (name) {
    case 'GraduationCap':
      return Icons.school_rounded;
    case 'MessageCircle':
      return Icons.chat_bubble_outline_rounded;
    case 'Briefcase':
      return Icons.work_outline_rounded;
    case 'Globe':
      return Icons.public_rounded;
    case 'Baby':
      return Icons.child_care_rounded;
    default:
      return Icons.menu_book_rounded;
  }
}

class _TrackSheet extends StatefulWidget {
  const _TrackSheet();
  @override
  State<_TrackSheet> createState() => _TrackSheetState();
}

class _TrackSheetState extends State<_TrackSheet> {
  late Future<List<Track>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthState>().api.getTracks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: FutureBuilder<List<Track>>(
          future: _future,
          builder: (context, snap) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 14),
                const Text('Learning tracks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const Text('IELTS is active. More programs are on the way.',
                    style: TextStyle(color: AppColors.mutedForeground)),
                const SizedBox(height: 14),
                if (snap.connectionState == ConnectionState.waiting)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (snap.hasError)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Could not load tracks.', style: TextStyle(color: AppColors.mutedForeground)),
                  )
                else
                  ...snap.data!.map((t) => _row(t)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _row(Track t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FluentaCard(
        padding: const EdgeInsets.all(14),
        onTap: () {
          if (t.active) {
            Navigator.pop(context);
          } else {
            showToast(context, '${t.name} is coming soon');
          }
        },
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: (t.active ? AppColors.primary : AppColors.mutedForeground).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(_trackIcon(t.icon),
                color: t.active ? AppColors.primary : AppColors.mutedForeground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(t.description,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12.5)),
            ]),
          ),
          if (t.active)
            const PillBadge('Active', color: AppColors.success, icon: Icons.check_rounded)
          else
            const PillBadge('Soon', color: AppColors.mutedForeground),
        ]),
      ),
    );
  }
}
