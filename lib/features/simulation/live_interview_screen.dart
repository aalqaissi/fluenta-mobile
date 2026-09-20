import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

/// Turn-based, text-only AI examiner (no read-aloud on mobile v1).
///
/// Reuses the `speaking_screen.dart` recording pattern (record + mic
/// permission + upload) and mirrors `writing_results_screen.dart`'s
/// criteria layout for the final results card.
class LiveInterviewScreen extends StatefulWidget {
  const LiveInterviewScreen({super.key});
  @override
  State<LiveInterviewScreen> createState() => _LiveInterviewScreenState();
}

class _LiveInterviewScreenState extends State<LiveInterviewScreen> {
  final _rec = AudioRecorder();
  final _scroll = ScrollController();
  final List<InterviewTurn> _history = [];
  final List<Map<String, dynamic>> _answers = []; // {part, text}
  final List<_Bubble> _bubbles = [];
  int _part = 1;
  bool _recording = false;
  bool _busy = false; // a turn or the grade is in flight
  bool _ended = false;
  SpeakingResult? _result;

  ApiClient get _api => context.read<AuthState>().api;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openInterview());
  }

  @override
  void dispose() {
    _rec.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(_scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220), curve: Curves.easeOut);
    });
  }

  Future<void> _openInterview() => _sendTurn(null);

  Future<void> _sendTurn(String? audioUrl, {int? answeredPart}) async {
    setState(() => _busy = true);
    try {
      final reply = await _api.liveInterviewTurn(
          part: answeredPart ?? _part, history: _history, answerAudioUrl: audioUrl);
      // if this turn carried an answer, record its transcript for grading
      if (audioUrl != null || answeredPart != null) {
        _history.add(InterviewTurn(
            role: 'candidate', text: reply.transcript.isEmpty ? '(spoken answer)' : reply.transcript));
        _answers.add({'part': answeredPart ?? _part, 'text': reply.transcript});
        _bubbles.add(_Bubble(you: true, text: reply.transcript.isEmpty ? '(your spoken response)' : reply.transcript));
      }
      _history.add(InterviewTurn(role: 'examiner', text: reply.reply));
      _bubbles.add(_Bubble(you: false, text: reply.reply));
      _part = reply.part;
      if (reply.done) await _grade();
    } catch (_) {
      _bubbles.add(const _Bubble(you: false, text: "Thank you, that's the end of the interview."));
      await _grade();
    } finally {
      if (mounted) setState(() => _busy = false);
      _scrollToEnd();
    }
  }

  Future<void> _toggleMic() async {
    if (_busy) return;
    if (_recording) {
      try {
        final path = await _rec.stop();
        if (!mounted) return;
        setState(() => _recording = false);
        if (path != null) await _submitAnswer(path);
      } catch (_) {
        if (!mounted) return;
        setState(() => _recording = false);
        showToast(context, 'Recording failed. Please try again.');
      }
      return;
    }
    if (!await Permission.microphone.request().isGranted) {
      if (mounted) showToast(context, 'Microphone permission is needed to record.');
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final file = '${dir.path}/interview_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _rec.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: file);
      if (!mounted) return;
      setState(() => _recording = true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _recording = false);
      showToast(context, 'Recording failed. Please try again.');
    }
  }

  Future<void> _submitAnswer(String path) async {
    final answeredPart = _part;
    setState(() => _busy = true);
    String? url;
    try {
      url = await _api.uploadMedia(File(path));
    } catch (_) {
      url = null;
    }
    await _sendTurn(url, answeredPart: answeredPart);
  }

  Future<void> _grade() async {
    setState(() {
      _busy = true;
      _ended = true;
    });
    final byPart = <int, List<String>>{};
    for (final a in _answers) {
      final t = a['text'] as String;
      if (t.isEmpty) continue;
      byPart.putIfAbsent(a['part'] as int, () => []).add(t);
    }
    final parts = (byPart.keys.toList()..sort())
        .map((p) => {'number': p, 'transcript': byPart[p]!.join(' '), 'note': ''})
        .toList();
    try {
      if (parts.isEmpty) throw Exception('no answers');
      final res = await _api.liveInterviewGrade(examId: 'live-interview', parts: parts);
      if (mounted) setState(() => _result = res);
    } catch (_) {
      // leave _result null -> the UI shows a "feedback unavailable" card
    } finally {
      if (mounted) setState(() => _busy = false);
      _scrollToEnd();
    }
  }

  Future<void> _endInterview() async {
    if (_recording) {
      try {
        await _rec.stop();
      } catch (_) {
        /* best effort */
      }
      if (mounted) setState(() => _recording = false);
    }
    await _grade();
  }

  @override
  Widget build(BuildContext context) {
    _scrollToEnd();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Interview'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: PillBadge('Part $_part of 3', color: AppColors.info)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  if (_bubbles.isEmpty && _busy)
                    const _TypingBubble(label: 'Connecting to the examiner…'),
                  ..._bubbles.map(_bubbleTile),
                  if (_busy && _bubbles.isNotEmpty && !_ended) const _TypingBubble(label: 'Examiner is typing…'),
                  if (_ended) ...[
                    const SizedBox(height: 8),
                    if (_busy)
                      const _TypingBubble(label: 'Scoring your interview…')
                    else if (_result != null)
                      _resultsCard(_result!)
                    else
                      _feedbackUnavailableCard(),
                  ],
                ],
              ),
            ),
            if (!_ended) _controlBar(),
          ],
        ),
      ),
    );
  }

  Widget _bubbleTile(_Bubble b) {
    return Align(
      alignment: b.you ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: b.you ? AppColors.primary.withValues(alpha: 0.1) : AppColors.muted,
          borderRadius: BorderRadius.circular(16),
          border: b.you ? Border.all(color: AppColors.primary.withValues(alpha: 0.3)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(b.you ? 'You' : 'Examiner',
                style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: b.you ? AppColors.primary : AppColors.mutedForeground)),
            const SizedBox(height: 4),
            Text(b.text, style: const TextStyle(fontSize: 14, height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _controlBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Text(
            _busy
                ? 'Please wait…'
                : _recording
                    ? 'Recording… tap the mic to stop and send'
                    : 'Tap the mic to answer',
            style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: _busy ? null : _endInterview,
                  icon: const Icon(Icons.stop_circle_outlined, size: 18),
                  label: const Text('End interview'),
                ),
              ),
              const SizedBox(width: 12),
              Opacity(
                opacity: _busy ? 0.5 : 1,
                child: GestureDetector(
                  onTap: _busy ? null : _toggleMic,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: _recording ? null : AppColors.warmGradient,
                      color: _recording ? AppColors.destructive : null,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: (_recording ? AppColors.destructive : AppColors.primary)
                                .withValues(alpha: 0.35),
                            blurRadius: 16),
                      ],
                    ),
                    child: Icon(_recording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white, size: 28),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultsCard(SpeakingResult r) {
    return FluentaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            ProgressRing(value: r.overall / 9, size: 92, stroke: 10, label: formatBand(r.overall), sublabel: 'overall'),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const PillBadge('AI feedback', color: AppColors.info, icon: Icons.auto_awesome),
                const SizedBox(height: 6),
                const Text('Your interview, reviewed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text('Scored across ${r.criteria.length} criteria.',
                    style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          ...r.criteria.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration:
                    BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(c.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14))),
                    Text(formatBand(c.band),
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.bandTone(c.band))),
                  ]),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(value: c.band / 9, minHeight: 5, color: AppColors.bandTone(c.band)),
                  ),
                  const SizedBox(height: 8),
                  Text(c.note, style: const TextStyle(fontSize: 13.5, color: AppColors.mutedForeground)),
                ]),
              )),
        ],
      ),
    );
  }

  Widget _feedbackUnavailableCard() {
    return FluentaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.info_outline_rounded, color: AppColors.mutedForeground),
            SizedBox(width: 8),
            Text("Feedback isn't available right now", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
          ]),
          const SizedBox(height: 8),
          const Text('AI feedback is unavailable right now. Please try again later.',
              style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Bubble {
  final bool you;
  final String text;
  const _Bubble({required this.you, required this.text});
}

class _TypingBubble extends StatelessWidget {
  final String label;
  const _TypingBubble({required this.label});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(16)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.mutedForeground),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
        ]),
      ),
    );
  }
}
