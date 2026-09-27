import '../../utils/exam_mode.dart';

/// In-memory record of a full-exam session (mirrors web `fullexam-store.ts`): the band earned per
/// skill, taken in the fixed IELTS order under exam conditions. Writing is two tasks — the component
/// band is derived once both are graded, with Task 2 double-weighted.
class FullExamStore {
  static final Map<String, double> bands = {};

  /// Fixed exam order.
  static const order = ['listening', 'reading', 'writing', 'speaking'];

  static void reset() => bands.clear();

  static void record(String key, double band) {
    bands[key] = band;
    if (key == 'writingT1' || key == 'writingT2') {
      final t1 = bands['writingT1'];
      final t2 = bands['writingT2'];
      if (t1 != null && t2 != null) {
        bands['writing'] = writingBand(t1, t2);
      } else {
        bands.remove('writing');
      }
    }
  }

  static bool has(String skill) => bands.containsKey(skill);

  /// The next section to take (null when all four are done).
  static String? get next {
    for (final s in order) {
      if (!has(s)) return s;
    }
    return null;
  }

  static bool get allDone => next == null;

  /// Overall = mean of the four component bands, rounded to the nearest 0.5 (null until all are done).
  static double? get overall {
    if (!allDone) return null;
    final mean = order.map((k) => bands[k]!).reduce((a, b) => a + b) / order.length;
    return (mean * 2).round() / 2;
  }
}
