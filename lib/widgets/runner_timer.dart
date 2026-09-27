import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/exam_mode.dart';
import '../utils/format.dart';

/// Component timer with the two mode rules (mirrors web `useRunnerTimer`):
/// - exam: a mandatory countdown that calls [onExpire] (auto-submit) at 0;
/// - practice: off by default; the student may switch on an informational countdown that never submits.
/// Elapsed time is always tracked (for `durationUsedSec`). [tick] is the unit-testable step.
class RunnerTimer extends ChangeNotifier {
  final ExamMode mode;
  final VoidCallback? onExpire;
  int timeLeft;
  int elapsed = 0;
  bool enabled;
  bool running;
  bool _expired = false;
  Timer? _timer;

  RunnerTimer({required this.mode, required int durationSec, this.onExpire, this.running = true})
      : timeLeft = durationSec,
        enabled = mode == ExamMode.exam;

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    if (!running) return;
    elapsed++;
    if (enabled && timeLeft > 0) timeLeft--;
    notifyListeners();
    if (mode == ExamMode.exam && enabled && timeLeft == 0 && !_expired) {
      _expired = true;
      onExpire?.call();
    }
  }

  /// Practice only — exam timing can't be switched off.
  void toggle() {
    if (mode == ExamMode.exam) return;
    enabled = !enabled;
    notifyListeners();
  }

  /// Start a new countdown phase (e.g. the listening answer-check period).
  void restart(int durationSec) {
    timeLeft = durationSec;
    _expired = false;
    running = true;
    notifyListeners();
  }

  void stop() => _timer?.cancel();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// App-bar chip: exam = countdown; practice = "Timer off" toggle / optional countdown.
class TimerChip extends StatelessWidget {
  final RunnerTimer timer;
  final String? label;
  const TimerChip({super.key, required this.timer, this.label});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: timer,
      builder: (context, _) {
        final low = timer.enabled && timer.timeLeft < 120;
        final clock = '${pad2(timer.timeLeft ~/ 60)}:${pad2(timer.timeLeft % 60)}';
        final practiceOff = timer.mode == ExamMode.practice && !timer.enabled;
        final text = practiceOff
            ? 'Timer off'
            : (timer.mode == ExamMode.practice && timer.timeLeft == 0)
                ? "Time's up"
                : '${label == null ? '' : '$label '}$clock';
        final color = low ? AppColors.destructive : (practiceOff ? AppColors.mutedForeground : AppColors.foreground);
        return GestureDetector(
          onTap: timer.mode == ExamMode.practice ? timer.toggle : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: low ? AppColors.destructive.withValues(alpha: 0.1) : (practiceOff ? null : AppColors.muted),
              border: practiceOff ? Border.all(color: AppColors.border) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(practiceOff ? Icons.timer_off_outlined : Icons.schedule_rounded, size: 15, color: color),
              const SizedBox(width: 4),
              Text(text, style: TextStyle(fontWeight: FontWeight.w800, color: color)),
            ]),
          ),
        );
      },
    );
  }
}

/// Makes the active mode obvious in every runner.
class ModeBadge extends StatelessWidget {
  final ExamMode mode;
  const ModeBadge(this.mode, {super.key});
  @override
  Widget build(BuildContext context) {
    final exam = mode == ExamMode.exam;
    final color = exam ? AppColors.destructive : AppColors.info;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
      child: Text(exam ? 'Exam' : 'Practice', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}
