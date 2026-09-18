import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../services/exam_convert.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

class SpeakingScreen extends StatefulWidget {
  const SpeakingScreen({super.key});
  @override
  State<SpeakingScreen> createState() => _SpeakingScreenState();
}

class _SpeakingScreenState extends State<SpeakingScreen> {
  int _part = 0;
  bool _recording = false;
  int _elapsed = 0;
  Timer? _timer;
  List<SpeakingPart> _parts = speakingParts; // local fallback until API loads

  final _rec = AudioRecorder();
  final Map<int, String> _clips = {}; // part index -> recorded file path
  bool _submitting = false;
  SpeakingResult? _result;

  @override
  void initState() {
    super.initState();
    _loadParts();
  }

  Future<void> _loadParts() async {
    try {
      final list = await context.read<AuthState>().api.listExams(skill: 'speaking', status: 'published');
      final runner = list.where((e) => e.format == 'runner').toList();
      if (runner.isEmpty) return;
      final parts = speakingPartsFromContent(runner.first.content);
      if (parts.isNotEmpty && mounted) {
        setState(() {
          _parts = parts;
          if (_part >= _parts.length) _part = 0;
        });
      }
    } catch (_) {
      /* keep the local fallback */
    }
  }

  Future<void> _toggle() async {
    if (_recording) {
      try {
        final path = await _rec.stop();
        if (!mounted) return;
        setState(() {
          _recording = false;
          if (path != null) _clips[_part] = path;
        });
      } catch (_) {
        _timer?.cancel();
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
      final file = '${dir.path}/speaking_${_part}_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _rec.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: file);
      if (!mounted) return;
      setState(() {
        _recording = true;
        _elapsed = 0;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _elapsed++));
    } catch (_) {
      if (!mounted) return;
      setState(() => _recording = false);
      showToast(context, 'Recording failed. Please try again.');
    }
  }

  /// Stops any in-progress recording (storing the take so it isn't lost)
  /// before switching the active part — otherwise the native recorder keeps
  /// running against the old part's temp file after the UI moves on.
  Future<void> _selectPart(int index) async {
    if (_recording) {
      try {
        final path = await _rec.stop();
        if (path != null) _clips[_part] = path;
      } catch (_) {
        /* best effort: still switch parts even if stop() failed */
      }
    }
    if (!mounted) return;
    setState(() => _part = index);
    _reset();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      final api = context.read<AuthState>().api;
      final parts = <Map<String, dynamic>>[];
      for (var i = 0; i < _parts.length; i++) {
        final path = _clips[i];
        if (path == null) throw Exception('missing recording');
        final url = await api.uploadMedia(File(path));
        parts.add({'number': _parts[i].number, 'prompt': _promptFor(_parts[i]), 'audioUrl': url});
      }
      final res = await api.speakingFeedback(examId: 'speaking', parts: parts);
      if (mounted) setState(() => _result = res);
    } catch (_) {
      if (mounted) showToast(context, 'AI feedback is unavailable right now. Please try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String _promptFor(SpeakingPart p) =>
      p.cueCard != null ? [p.cueCard!, ...(p.bullets ?? const [])].join(' • ') : p.questions.join(' ');

  void _reset() {
    _timer?.cancel();
    setState(() {
      _recording = false;
      _elapsed = 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().isLocked('speaking');
    final part = _parts[_part];
    final hasClip = _clips.containsKey(_part);
    return Scaffold(
      appBar: AppBar(title: const Text('Speaking practice')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (locked) const UpgradeBanner('Speaking practice'),
          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Choose a mode', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(Icons.mic_rounded, color: AppColors.primary),
                      SizedBox(height: 6),
                      Text('Standard Practice', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                      Text('3 parts, self-paced', style: TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
                    ]),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => showToast(context, 'Live Interview is coming soon',
                        description: 'Real-time AI examiner conversation.'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: const [
                          Icon(Icons.record_voice_over_rounded, color: AppColors.mutedForeground),
                          Spacer(),
                          PillBadge('Soon', color: AppColors.mutedForeground),
                        ]),
                        const SizedBox(height: 6),
                        const Text('Live Interview', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                        const Text('Adaptive AI examiner', style: TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
                      ]),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 62,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _parts.asMap().entries.map((e) {
                final sel = _part == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _selectPart(e.key),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: sel ? AppColors.primary : AppColors.border),
                        color: sel ? AppColors.primary.withValues(alpha: 0.06) : null,
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Part ${e.value.number}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        Text(e.value.title, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                      ]),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          if (part.cueCard != null)
            FluentaCard(
              border: Border.all(color: AppColors.border),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const PillBadge('Cue card', color: AppColors.onSecondary, bg: Color(0x26F5A524)),
                const SizedBox(height: 8),
                Text(part.cueCard!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('You should say:', style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                const SizedBox(height: 4),
                ...(part.bullets ?? const <String>[]).map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text('•  $b', style: const TextStyle(fontSize: 13.5)),
                    )),
              ]),
            )
          else
            FluentaCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const PillBadge('Examiner questions', color: AppColors.info),
                const SizedBox(height: 10),
                ...part.questions.asMap().entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text('${e.key + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value, style: const TextStyle(fontSize: 14, height: 1.4))),
                      ]),
                    )),
              ]),
            ),
          const SizedBox(height: 14),
          FluentaCard(
            child: Column(children: [
              GestureDetector(
                onTap: _toggle,
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    gradient: _recording ? null : AppColors.warmGradient,
                    color: _recording ? AppColors.destructive : null,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: (_recording ? AppColors.destructive : AppColors.primary).withValues(alpha: 0.35), blurRadius: 20)],
                  ),
                  child: Icon(_recording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 38),
                ),
              ),
              const SizedBox(height: 10),
              Text('${_recording ? 'Recording…' : hasClip ? 'Recorded' : 'Tap to record'} · ${pad2(_elapsed ~/ 60)}:${pad2(_elapsed % 60)}',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              if (hasClip)
                TextButton.icon(onPressed: _reset, icon: const Icon(Icons.refresh_rounded, size: 16), label: const Text('Re-record')),
              const Text('Your answer is recorded on this device and uploaded when you submit.',
                  style: TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
            ]),
          ),
          const SizedBox(height: 14),
          FluentaCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text('AI feedback', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5)),
              ]),
              const SizedBox(height: 8),
              const Text(
                  'Record each part, then submit for band estimates and per-criterion coaching on your speaking.',
                  style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: (_clips.isEmpty || _submitting) ? null : _submit,
                  icon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(_submitting ? 'Submitting…' : 'Submit for AI feedback'),
                ),
              ),
            ]),
          ),
          if (_result != null) ...[
            const SizedBox(height: 14),
            FluentaCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  ProgressRing(value: _result!.overall / 9, size: 92, stroke: 10, label: formatBand(_result!.overall), sublabel: 'overall'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const PillBadge('AI feedback', color: AppColors.info, icon: Icons.auto_awesome),
                      const SizedBox(height: 6),
                      const Text('Your speaking, reviewed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      Text('Scored across ${_result!.criteria.length} criteria.',
                          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 14),
                ..._result!.criteria.map((c) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(12)),
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
              ]),
            ),
          ],
        ],
      ),
    );
  }
}
