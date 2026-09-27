import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/brand.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../services/mock_api.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

const _critColor = {
  WritingCriterionKey.task: AppColors.primary,
  WritingCriterionKey.coherence: AppColors.info,
  WritingCriterionKey.lexical: AppColors.secondary,
  WritingCriterionKey.grammar: AppColors.destructive,
};

class WritingResultsScreen extends StatefulWidget {
  const WritingResultsScreen({super.key});
  @override
  State<WritingResultsScreen> createState() => _WritingResultsScreenState();
}

class _WritingResultsScreenState extends State<WritingResultsScreen> {
  WritingResult get result {
    final r = AttemptStore.lastWriting?.result;
    return (r != null && r.criteria.isNotEmpty) ? r : sampleWritingResult;
  }
  bool _feedback = true;
  WritingCriterionKey _crit = WritingCriterionKey.task;

  @override
  Widget build(BuildContext context) {
    final written = AttemptStore.lastWriting;
    final answer = (written != null && written.answer.trim().isNotEmpty) ? written.answer : result.answer;
    final wordCount = written?.wordCount ?? result.wordCount;
    final critMeta = result.criteria.firstWhere((c) => c.key == _crit, orElse: () => result.criteria.first);
    final notes = result.annotations.where((a) => a.criterion == _crit).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/progress')),
        title: const Text('Writing feedback'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          FluentaCard(
            child: Column(children: [
              Row(children: [
                ProgressRing(value: result.overall / 9, size: 92, stroke: 10, label: formatBand(result.overall), sublabel: 'estimated'),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const PillBadge('AI feedback', color: AppColors.info, icon: Icons.auto_awesome),
                    const SizedBox(height: 6),
                    const Text('Your writing, reviewed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    Text('$wordCount words · scored on all four criteria.', style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                    const Text('Estimated IELTS band — not an official result.', style: TextStyle(color: AppColors.mutedForeground, fontSize: 11.5, fontWeight: FontWeight.w600)),
                    if (result.essayType != null) ...[
                      const SizedBox(height: 4),
                      PillBadge('Essay type: ${_essayTypeLabel[result.essayType] ?? result.essayType}', color: AppColors.mutedForeground),
                    ],
                  ]),
                ),
              ]),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.15,
                children: result.criteria.map((c) {
                  final sel = _crit == c.key;
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _crit = c.key),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sel ? AppColors.primary : AppColors.border),
                        color: sel ? AppColors.primary.withValues(alpha: 0.05) : null,
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(c.label, style: const TextStyle(fontSize: 10.5, color: AppColors.mutedForeground, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(formatBand(c.band), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.bandTone(c.band))),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(value: c.band / 9, minHeight: 5, color: _critColor[c.key]),
                        ),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Your answer', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                SegmentedButton<bool>(
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  segments: const [
                    ButtonSegment(value: false, label: Text('Original')),
                    ButtonSegment(value: true, label: Text('Feedback')),
                  ],
                  selected: {_feedback},
                  onSelectionChanged: (s) => setState(() => _feedback = s.first),
                ),
              ]),
              const SizedBox(height: 12),
              _feedback
                  ? Text.rich(_annotated(answer), style: const TextStyle(fontSize: 15, height: 1.8))
                  : Text(answer, style: const TextStyle(fontSize: 15, height: 1.8)),
            ]),
          ),
          const SizedBox(height: 16),

          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${critMeta.label} · ${formatBand(critMeta.band)}',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5, color: AppColors.bandTone(critMeta.band))),
              const SizedBox(height: 4),
              Text(critMeta.summary, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
              const SizedBox(height: 12),
              if (notes.isEmpty)
                const Text('No specific issues flagged for this criterion.', style: TextStyle(color: AppColors.mutedForeground, fontSize: 13))
              else
                ...notes.asMap().entries.map((e) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('"${e.value.quote}"', style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.mutedForeground, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text(e.value.note, style: const TextStyle(fontSize: 13.5)),
                      ]),
                    )),
            ]),
          ),
          if (result.coaching.isNotEmpty) ...[
            const SizedBox(height: 16),
            _CoachingCard(notes: result.coaching),
          ],
          const SizedBox(height: 16),

          GradientCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.smart_toy_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('Get personalized guidance', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.5)),
              ]),
              const SizedBox(height: 6),
              const Text('Chat with Fluenta Coach to understand your mistakes and practice targeted exercises.',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary),
                  onPressed: () => context.go('/coach'),
                  child: Text('Start conversation with ${Brand.coachName}'),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  TextSpan _annotated(String text) {
    var segs = <(String, WritingCriterionKey?)>[(text, null)];
    for (final a in result.annotations) {
      final next = <(String, WritingCriterionKey?)>[];
      for (final seg in segs) {
        if (seg.$2 != null) {
          next.add(seg);
          continue;
        }
        final idx = seg.$1.indexOf(a.quote);
        if (idx == -1) {
          next.add(seg);
          continue;
        }
        if (idx > 0) next.add((seg.$1.substring(0, idx), null));
        next.add((a.quote, a.criterion));
        next.add((seg.$1.substring(idx + a.quote.length), null));
      }
      segs = next;
    }
    return TextSpan(
      children: segs.map((s) {
        if (s.$2 == null) return TextSpan(text: s.$1);
        return TextSpan(
          text: s.$1,
          style: TextStyle(
            backgroundColor: _critColor[s.$2]!.withValues(alpha: 0.22),
            decoration: TextDecoration.underline,
            decorationColor: _critColor[s.$2],
          ),
        );
      }).toList(),
    );
  }
}

const _essayTypeLabel = {
  'opinion': 'Opinion (agree / disagree)',
  'extent': 'Opinion (to what extent)',
  'discussion': 'Discussion (both views)',
  'adv-disadv': 'Advantages & disadvantages',
  'outweigh': 'Advantages outweigh disadvantages',
  'problem-solution': 'Problems & solutions',
  'cause-solution': 'Causes & solutions',
  'two-part': 'Two-part question',
  'other': 'Other / mixed',
};

/// The Yalla teaching layer — shown apart from the IELTS criteria because it never changes a band.
class _CoachingCard extends StatelessWidget {
  final List<CoachingNote> notes;
  const _CoachingCard({required this.notes});

  @override
  Widget build(BuildContext context) {
    return FluentaCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.school_rounded, color: AppColors.primary),
          SizedBox(width: 8),
          Text('Yalla strategy coaching', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
        ]),
        const SizedBox(height: 4),
        const Text("Teaching recommendations from the Yalla method — they don't change your IELTS criterion bands.",
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
        const SizedBox(height: 10),
        ...notes.map((n) {
          final (label, icon, color) = switch (n.status) {
            'good' => ('Working well', Icons.check_circle_rounded, AppColors.success),
            'improve' => ('To improve', Icons.warning_amber_rounded, AppColors.destructive),
            _ => ('Strategy tip', Icons.lightbulb_rounded, AppColors.primary),
          };
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5))),
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 4),
                Text(label.toUpperCase(), style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 4),
              Text(n.note, style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
            ]),
          );
        }),
      ]),
    );
  }
}
