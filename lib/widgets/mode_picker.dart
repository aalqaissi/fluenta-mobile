import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../utils/exam_mode.dart';

/// Ask Practice vs Exam conditions, then open [route] in that mode (owner spec: separate modes).
Future<void> pushWithMode(BuildContext context, String route, {Object? extra}) async {
  final mode = await showModalBottomSheet<ExamMode>(
    context: context,
    showDragHandle: true,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('How do you want to take it?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 12),
          _ModeTile(
            icon: Icons.fitness_center_rounded,
            title: 'Practice',
            subtitle: 'Timer optional · replay audio · re-record',
            onTap: () => Navigator.of(ctx).pop(ExamMode.practice),
          ),
          const SizedBox(height: 10),
          _ModeTile(
            icon: Icons.timer_outlined,
            title: 'Exam conditions',
            subtitle: 'Official timing · audio once · auto-submit',
            onTap: () => Navigator.of(ctx).pop(ExamMode.exam),
          ),
        ]),
      ),
    ),
  );
  if (mode == null || !context.mounted) return;
  context.push(withMode(route, mode), extra: extra);
}

class _ModeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ModeTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(subtitle, style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.mutedForeground),
        ]),
      ),
    );
  }
}
