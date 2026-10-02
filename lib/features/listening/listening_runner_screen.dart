import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../utils/answer_match.dart' show answeredSlots, questionSlots;
import '../../services/api_client.dart';
import '../../services/mock_api.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/exam_mode.dart';
import '../../widgets/grading_overlay.dart';
import '../../widgets/runner_timer.dart';
import '../exam/question_group_view.dart';
import '../full_exam/full_exam_store.dart';
import 'section_audio_player.dart';

/// Server-scored listening runner: 4 parts, each with section audio and one question group.
/// Submits to POST /api/attempts.
///
/// Exam mode runs in two phases (owner spec §1, mirrors the web runner): "listening" — one part at
/// a time, each recording played once, advancing when it ends — then "check" — 2 minutes to review
/// and edit every answer, after which the test submits automatically. Practice mode has free
/// navigation, replayable audio and an optional timer.
class ListeningRunnerScreen extends StatefulWidget {
  final ListeningRunExam exam;
  final String examId;
  final bool full; // part of a full-exam session
  final ExamMode mode;
  const ListeningRunnerScreen(
      {super.key, required this.exam, required this.examId, this.full = false, this.mode = ExamMode.practice});
  @override
  State<ListeningRunnerScreen> createState() => _ListeningRunnerScreenState();
}

enum _Phase { listening, check }

class _ListeningRunnerScreenState extends State<ListeningRunnerScreen> {
  ListeningRunExam get exam => widget.exam;
  bool get _isExam => widget.mode == ExamMode.exam;
  int _sIdx = 0;
  final Map<String, String> _answers = {};
  final Set<int> _played = {}; // parts whose audio finished
  _Phase _phase = _Phase.listening;
  bool _submitting = false;
  late final RunnerTimer _timer;

  bool get _listeningPhase => _isExam && _phase == _Phase.listening;
  int get _last => exam.sections.length - 1;

  @override
  void initState() {
    super.initState();
    _timer = RunnerTimer(
      mode: widget.mode,
      durationSec: _isExam ? ExamTiming.listeningCheckSec : exam.durationSec,
      running: !_isExam, // exam: the recording drives timing until the check period
      onExpire: _submit,
    )..start();
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }

  ListeningRunSection get _section => exam.sections[_sIdx];
  // Question numbers, not items: a "Choose TWO" counts as two.
  Iterable<Question> get _questions => exam.sections.expand((s) => s.group.questions);
  int get _totalQ => _questions.fold(0, (n, q) => n + questionSlots(q.marks));
  int get _answered => _questions.fold(0, (n, q) => n + answeredSlots(_answers[q.id], q.marks));

  String? _resolvedAudioUrl(BuildContext context) {
    final path = _section.audioUrl;
    if (path == null) return null;
    if (path.startsWith('http')) return path;
    return '${context.read<AuthState>().api.config.mediaBase}$path';
  }

  void _gotoSection(int i) => setState(() => _sIdx = i);

  void _onSectionEnded(int i) {
    setState(() => _played.add(i));
    if (!_isExam) return;
    if (i < _last) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted && _sIdx == i && _phase == _Phase.listening) _gotoSection(i + 1);
      });
    } else {
      _startCheck();
    }
  }

  void _startCheck() {
    setState(() => _phase = _Phase.check);
    _timer.restart(ExamTiming.listeningCheckSec);
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    _timer.stop();
    try {
      final dto = await context.read<AuthState>().api.submitAttempt(AttemptRequest(
            examId: widget.examId,
            skill: 'listening',
            answers: _answers,
            durationUsedSec: _timer.elapsed,
            mode: widget.mode.wire,
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
      _timer.start();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not submit: ${e.message}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _sIdx == _last;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.canPop() ? context.pop() : context.go('/')),
        titleSpacing: 0,
        title: const Text('Yalla Listening',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        actions: [
          ModeBadge(widget.mode),
          const SizedBox(width: 8),
          Center(
            child: _listeningPhase
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(10)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.headphones_rounded, size: 15),
                      const SizedBox(width: 4),
                      Text('Part ${_section.number}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    ]),
                  )
                : TimerChip(timer: _timer, label: _isExam ? 'Check' : null),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(children: [
        if (_isExam && _phase == _Phase.check)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: AppColors.primary.withValues(alpha: 0.08),
            child: const Text(
              'The recording has finished — you have 2 minutes to check your answers. '
              'They are submitted automatically when the time is up.',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        // part stepper — locked to the recording during the exam listening phase
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
                      onTap: _listeningPhase ? null : () => _gotoSection(i),
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
                          Text('Part ${exam.sections[i].number}',
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
              if (_isExam && _played.contains(_sIdx))
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(14)),
                  child: Text(
                    'The recording for Part ${_section.number} has been played.'
                    '${_listeningPhase && _sIdx < _last ? ' Moving to the next part…' : ''}',
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                  ),
                )
              else
                SectionAudioPlayer(
                  key: ValueKey('audio-$_sIdx'),
                  audioUrl: _resolvedAudioUrl(context),
                  durationSec: _section.audioDurationSec,
                  alreadyPlayed: _isExam && _played.contains(_sIdx),
                  onCompleted: () => _onSectionEnded(_sIdx),
                  playOnce: _isExam, // exam conditions = once; practice replays
                ),
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

  Widget _bottomBar(bool isLast) {
    Widget primary;
    if (_listeningPhase) {
      final heard = _played.contains(_sIdx);
      primary = FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
        onPressed: heard ? () => (isLast ? _startCheck() : _gotoSection(_sIdx + 1)) : null,
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: Text(heard ? 'Next part' : 'Listen first'),
      );
    } else if (isLast) {
      primary = FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: AppColors.success, minimumSize: const Size(0, 46)),
        onPressed: _submitting ? null : _submit,
        icon: _submitting
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.flag_rounded, size: 18),
        label: const Text('Submit'),
      );
    } else {
      primary = FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
        onPressed: () => _gotoSection(_sIdx + 1),
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: const Text('Next'),
      );
    }
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
            color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46), padding: const EdgeInsets.symmetric(horizontal: 14)),
            onPressed: (_sIdx == 0 || _listeningPhase) ? null : () => _gotoSection(_sIdx - 1),
            child: const Icon(Icons.arrow_back_rounded, size: 18),
          ),
          Expanded(
            child: Center(
              child: Text('$_answered / $_totalQ answered',
                  style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ),
          ),
          primary,
        ]),
      ),
    );
  }
}
