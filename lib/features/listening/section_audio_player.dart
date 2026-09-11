import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';
import '../../widgets/ui.dart';

/// Play-once section audio. Streams a real clip when [audioUrl] is set; otherwise
/// falls back to a simulated timer (no sound), preserving the prototype behavior.
class SectionAudioPlayer extends StatefulWidget {
  final String? audioUrl; // fully-resolved URL (mediaBase + path), or null
  final int durationSec;
  final bool alreadyPlayed;
  final VoidCallback onCompleted;
  const SectionAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.durationSec,
    required this.alreadyPlayed,
    required this.onCompleted,
  });

  @override
  State<SectionAudioPlayer> createState() => _SectionAudioPlayerState();
}

class _SectionAudioPlayerState extends State<SectionAudioPlayer> {
  AudioPlayer? _player;
  StreamSubscription? _posSub;
  StreamSubscription? _stateSub;
  Timer? _simTimer;
  int _t = 0;
  int _realDur = 0;
  bool _playing = false;
  bool _played = false;
  String? _error;

  bool get _isReal => widget.audioUrl != null;
  int get _total => (_isReal && _realDur > 0) ? _realDur : (widget.durationSec > 0 ? widget.durationSec : 1);

  @override
  void initState() {
    super.initState();
    _played = widget.alreadyPlayed;
    if (_isReal) _initReal();
  }

  Future<void> _initReal() async {
    final p = AudioPlayer();
    _player = p;
    _posSub = p.positionStream.listen((d) {
      if (mounted) setState(() => _t = d.inSeconds);
    });
    _stateSub = p.playerStateStream.listen((st) {
      if (!mounted) return;
      if (st.processingState == ProcessingState.completed) {
        setState(() { _playing = false; _played = true; });
        p.pause();
        p.seek(Duration.zero);
        widget.onCompleted();
      } else {
        setState(() => _playing = st.playing);
      }
    });
    try {
      final dur = await p.setUrl(widget.audioUrl!);
      if (mounted && dur != null) setState(() => _realDur = dur.inSeconds);
    } catch (_) {
      if (mounted) setState(() => _error = 'Audio unavailable');
    }
  }

  void _toggle() {
    if (_played) return;
    if (_isReal) {
      final p = _player;
      if (p == null || _error != null) return;
      _playing ? p.pause() : p.play();
      return;
    }
    // simulated fallback: count once to the end
    if (_playing) return;
    setState(() { _playing = true; _t = 0; });
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_t >= _total) {
        _simTimer?.cancel();
        setState(() { _playing = false; _played = true; });
        widget.onCompleted();
      } else {
        setState(() => _t++);
      }
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _stateSub?.cancel();
    _simTimer?.cancel();
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _played ? 1.0 : (_t / _total).clamp(0.0, 1.0);
    final dur = _total;
    return FluentaCard(
      child: Column(children: [
        Row(children: [
          FilledButton(
            style: FilledButton.styleFrom(
                shape: const CircleBorder(), minimumSize: const Size(52, 52), padding: EdgeInsets.zero,
                backgroundColor: _played ? AppColors.mutedForeground : AppColors.primary),
            onPressed: (_played || _error != null) ? null : _toggle,
            child: Icon(
              _played ? Icons.check_rounded : (_playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
              size: 26,
            ),
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
                Text('${pad2(_t ~/ 60)}:${pad2(_t % 60)}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
                Text('${pad2(dur ~/ 60)}:${pad2(dur % 60)}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
              ]),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        Text(
          _error ??
              (_played
                  ? 'Audio played. In the real test each section plays once.'
                  : _isReal
                      ? 'The audio plays once.'
                      : 'The audio plays once — playback is simulated in this preview.'),
          style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground),
        ),
      ]),
    );
  }
}
