import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../services/mock_api.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/grading_overlay.dart';
import '../../widgets/ui.dart';
import '../exam/question_group_view.dart';
import '../full_exam/full_exam_store.dart';

/// Server-scored listening runner: 4 sections, each with a play-once audio clip
/// and one question group. Submits to POST /api/attempts.
class ListeningRunnerScreen extends StatefulWidget {
  final ListeningRunExam exam;
  final String examId;
  final bool full; // part of a full-exam session
  const ListeningRunnerScreen({super.key, required this.exam, required this.examId, this.full = false});
  @override
  State<ListeningRunnerScreen> createState() => _ListeningRunnerScreenState();
}

class _ListeningRunnerScreenState extends State<ListeningRunnerScreen> {
  ListeningRunExam get exam => widget.exam;
  int _sIdx = 0;
  final Map<String, String> _answers = {};
  final Set<int> _played = {}; // sections whose audio finished
  int _audioT = 0; // current playback position (sec) for the active section
  bool _playing = false;
  Timer? _audioTimer;
  late int _timeLeft;
  bool _submitting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = exam.durationSec;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_timeLeft <= 0) {
        _submit();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioTimer?.cancel();
    super.dispose();
  }

  ListeningRunSection get _section => exam.sections[_sIdx];
  int get _totalQ => exam.sections.fold(0, (n, s) => n + s.group.questions.length);
  int get _answered => _answers.values.where((v) => v.trim().isNotEmpty).length;

  void _playAudio() {
    if (_played.contains(_sIdx) || _playing) return;
    setState(() {
      _playing = true;
      _audioT = 0;
    });
    _audioTimer?.cancel();
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_audioT >= _section.audioDurationSec) {
        _audioTimer?.cancel();
        setState(() {
          _playing = false;
          _played.add(_sIdx);
        });
      } else {
        setState(() => _audioT++);
      }
    });
  }

  void _gotoSection(int i) {
    _audioTimer?.cancel();
    setState(() {
      _sIdx = i;
      _playing = false;
      _audioT = 0;
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _timer?.cancel();
    _audioTimer?.cancel();
    final used = exam.durationSec - _timeLeft;
    try {
      final dto = await context.read<AuthState>().api.submitAttempt(AttemptRequest(
            examId: widget.examId,
            skill: 'listening',
            answers: _answers,
            durationUsedSec: used,
          ));
      AttemptStore.lastListening = ReadingAttempt(
        answers: _answers,
        correct: dto.correct,
        total: dto.total,
        band: dto.band,
        durationUsedSec: dto.durationUsedSec,
      );
      AttemptStore.lastListeningExam = exam;
      if (!mounted) return;
      await showGradingDialog(context);
      if (!mounted) return;
      if (widget.full) {
        FullExamStore.record('listening', dto.band);
        context.go('/full-exam');
      } else {
        context.go('/results/listening');
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        _timeLeft > 0 ? setState(() => _timeLeft--) : _submit();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not submit: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final low = _timeLeft < 120;
    final isLast = _sIdx == exam.sections.length - 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        titleSpacing: 0,
        title: const Text('Yalla Listening',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: low ? AppColors.destructive.withValues(alpha: 0.1) : AppColors.muted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.schedule_rounded, size: 15,
                    color: low ? AppColors.destructive : AppColors.foreground),
                const SizedBox(width: 4),
                Text('${pad2(_timeLeft ~/ 60)}:${pad2(_timeLeft % 60)}',
                    style: TextStyle(fontWeight: FontWeight.w800,
                        color: low ? AppColors.destructive : AppColors.foreground)),
              ]),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(children: [
        // section stepper
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border))),
          child: SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < exam.sections.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _gotoSection(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: i == _sIdx ? AppColors.primary : AppColors.border),
                          color: i == _sIdx ? AppColors.primary.withValues(alpha: 0.06) : null,
                        ),
                        child: Row(children: [
                          if (_played.contains(i))
                            const Icon(Icons.check_circle, size: 14, color: AppColors.success)
                          else
                            const Icon(Icons.headphones_rounded, size: 14, color: AppColors.mutedForeground),
                          const SizedBox(width: 6),
                          Text('Section ${exam.sections[i].number}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        ]),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _audioCard(),
              const SizedBox(height: 14),
              Text(_section.context, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(_section.group.instructions,
                  style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
              const SizedBox(height: 12),
              QuestionGroupView(
                group: _section.group,
                answers: _answers,
                onChanged: (id, v) => setState(() => _answers[id] = v),
              ),
            ],
          ),
        ),
        _bottomBar(isLast),
      ]),
    );
  }

  Widget _audioCard() {
    final played = _played.contains(_sIdx);
    final dur = _section.audioDurationSec;
    final progress = _playing ? (_audioT / dur).clamp(0.0, 1.0) : (played ? 1.0 : 0.0);
    return FluentaCard(
      child: Column(children: [
        Row(children: [
          FilledButton(
            style: FilledButton.styleFrom(
                shape: const CircleBorder(), minimumSize: const Size(52, 52), padding: EdgeInsets.zero,
                backgroundColor: played ? AppColors.mutedForeground : AppColors.primary),
            onPressed: (played || _playing) ? null : _playAudio,
            child: Icon(played ? Icons.check_rounded : Icons.play_arrow_rounded, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(children: [
              SizedBox(
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(40, (i) {
                    final active = (i / 40) <= progress;
                    final h = 6 + ((i * 7) % 22).toDouble();
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.8),
                        height: h,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${pad2(_playing ? _audioT ~/ 60 : (played ? dur ~/ 60 : 0))}:${pad2(_playing ? _audioT % 60 : (played ? dur % 60 : 0))}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
                Text('${pad2(dur ~/ 60)}:${pad2(dur % 60)}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        Text(
          played
              ? 'Audio played. In the real test each section plays once.'
              : 'The audio plays once — playback is simulated in this preview.',
          style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground),
        ),
      ]),
    );
  }

  Widget _bottomBar(bool isLast) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
            color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46), padding: const EdgeInsets.symmetric(horizontal: 14)),
            onPressed: _sIdx == 0 ? null : () => _gotoSection(_sIdx - 1),
            child: const Icon(Icons.arrow_back_rounded, size: 18),
          ),
          Expanded(
            child: Center(
              child: Text('$_answered / $_totalQ answered',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ),
          ),
          if (isLast)
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.success, minimumSize: const Size(0, 46)),
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.flag_rounded, size: 18),
              label: const Text('Submit'),
            )
          else
            FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
              onPressed: () => _gotoSection(_sIdx + 1),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Next'),
            ),
        ]),
      ),
    );
  }
}
