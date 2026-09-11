import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/modals.dart';
import '../../widgets/ui.dart';

class FeedbackListScreen extends StatefulWidget {
  const FeedbackListScreen({super.key});
  @override
  State<FeedbackListScreen> createState() => _FeedbackListScreenState();
}

class _FeedbackListScreenState extends State<FeedbackListScreen> {
  late Future<List<FeedbackDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = context.read<AuthState>().api.listFeedback();
  }

  void _reload() =>
      setState(() => _future = context.read<AuthState>().api.listFeedback());

  ({Color color, String label}) _statusStyle(String s) => switch (s) {
        'completed' => (color: AppColors.success, label: 'Completed'),
        'under_review' => (color: AppColors.info, label: 'Under review'),
        _ => (color: AppColors.secondary, label: 'New'),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My feedback')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showFeedbackSheet(context);
          _reload();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New feedback'),
      ),
      body: FutureBuilder<List<FeedbackDto>>(
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
                  title: 'Feedback unavailable',
                  description: snap.error is ApiException
                      ? (snap.error as ApiException).message
                      : 'Could not load your feedback.',
                  action: FilledButton(onPressed: _reload, child: const Text('Retry')),
                ),
              ),
            );
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.forum_outlined,
                  title: 'No feedback yet',
                  description: 'Share an idea or report an issue — we read every note.',
                  action: FilledButton(
                    onPressed: () async {
                      await showFeedbackSheet(context);
                      _reload();
                    },
                    child: const Text('Give feedback'),
                  ),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
            children: [
              for (final f in items) _card(f),
            ],
          );
        },
      ),
    );
  }

  Widget _card(FeedbackDto f) {
    final st = _statusStyle(f.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FluentaCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
              child: Text(f.subject.isEmpty ? '(no subject)' : f.subject,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            PillBadge(st.label, color: st.color),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            PillBadge(f.category, color: AppColors.mutedForeground),
            if (f.rating != null) ...[
              const SizedBox(width: 8),
              Row(children: List.generate(f.rating!, (_) =>
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.secondary))),
            ],
          ]),
          if (f.message.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(f.message, style: const TextStyle(fontSize: 13.5)),
          ],
          if (f.adminReply != null && f.adminReply!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Reply from the team',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.info)),
                const SizedBox(height: 4),
                Text(f.adminReply!, style: const TextStyle(fontSize: 13)),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}
