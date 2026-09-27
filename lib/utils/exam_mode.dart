/// Practice vs Full Exam mode (owner IELTS spec — "Core Platform Modes"), mirroring the web
/// `exam-runner/examMode.ts`:
/// - practice: timer optional, listening audio replayable, flexible writing/speaking conditions;
/// - exam: official component timing that can't be switched off, audio played once, auto-submit.
library;

enum ExamMode { practice, exam }

/// Official Full Exam timings (seconds).
class ExamTiming {
  static const readingSec = 60 * 60;
  static const listeningCheckSec = 2 * 60;
  static const writingTask1Sec = 20 * 60;
  static const writingTask2Sec = 40 * 60;
  static const speakingPrepSec = 60;
  static const speakingPracticeCapSec = 5 * 60;

  /// Recording cap per speaking part. Exam: Part 1 ≈4–5 min, Part 2 long turn 2 min, Part 3 ≈4–5 min.
  static int speakingCapSec(int partNumber, ExamMode mode) {
    if (mode == ExamMode.practice) return speakingPracticeCapSec;
    return partNumber == 2 ? 2 * 60 : 5 * 60;
  }
}

/// `mode=exam` or the orchestrator's `full=1` → exam; anything else → practice.
ExamMode modeFromQuery(Map<String, String> q) =>
    q['mode'] == 'exam' || q['full'] == '1' ? ExamMode.exam : ExamMode.practice;

/// Append the mode to a route.
String withMode(String route, ExamMode mode) =>
    mode == ExamMode.exam ? '$route${route.contains('?') ? '&' : '?'}mode=exam' : route;

double _roundHalf(double v) => (v * 2).round() / 2;

/// Writing component band: Task 2 carries twice the weight of Task 1.
double writingBand(double task1, double task2) => _roundHalf((task1 + 2 * task2) / 3);

extension ExamModeWire on ExamMode {
  /// The value stored on attempts.
  String get wire => this == ExamMode.exam ? 'exam' : 'practice';
}
