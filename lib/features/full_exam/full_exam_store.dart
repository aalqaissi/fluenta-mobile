/// In-memory record of a full-exam session: the band earned per skill as each
/// scored section (listening, reading) is completed in "full mode". Read by the
/// orchestrator and the combined results screen.
class FullExamStore {
  static final Map<String, double> bands = {};

  static void reset() => bands.clear();
  static void record(String skill, double band) => bands[skill] = band;
  static bool has(String skill) => bands.containsKey(skill);

  /// Skills that contribute a scored band to the full exam.
  static const scoredSkills = ['listening', 'reading'];

  static bool get allScoredDone => scoredSkills.every(bands.containsKey);

  /// Overall = mean of the recorded scored bands, rounded to the nearest 0.5.
  static double? get overall {
    final vals = scoredSkills.where(bands.containsKey).map((k) => bands[k]!).toList();
    if (vals.isEmpty) return null;
    final mean = vals.reduce((a, b) => a + b) / vals.length;
    return (mean * 2).round() / 2;
  }
}
