import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/utils/exam_mode.dart';
import 'package:fluenta_mobile/widgets/runner_timer.dart';

void main() {
  test('mode comes from mode=exam or the orchestrator full=1', () {
    expect(modeFromQuery({}), ExamMode.practice);
    expect(modeFromQuery({'mode': 'exam'}), ExamMode.exam);
    expect(modeFromQuery({'full': '1'}), ExamMode.exam);
    expect(withMode('/listening', ExamMode.exam), '/listening?mode=exam');
    expect(withMode('/exam/reading?id=x', ExamMode.exam), '/exam/reading?id=x&mode=exam');
    expect(withMode('/listening', ExamMode.practice), '/listening');
  });

  test('speaking caps: exam Part 2 long turn is 2 minutes; practice is flexible', () {
    expect(ExamTiming.speakingCapSec(2, ExamMode.exam), 120);
    expect(ExamTiming.speakingCapSec(1, ExamMode.exam), 300);
    expect(ExamTiming.speakingCapSec(2, ExamMode.practice), 300);
  });

  test('exam timer is mandatory and expires once', () {
    var expired = 0;
    final t = RunnerTimer(mode: ExamMode.exam, durationSec: 2, onExpire: () => expired++);
    t.toggle(); // no effect in exam mode
    expect(t.enabled, isTrue);
    t.tick();
    t.tick();
    t.tick();
    expect(t.timeLeft, 0);
    expect(expired, 1);
    expect(t.elapsed, 3);
  });

  test('practice timer is off by default and never auto-submits', () {
    var expired = 0;
    final t = RunnerTimer(mode: ExamMode.practice, durationSec: 1, onExpire: () => expired++);
    expect(t.enabled, isFalse);
    t.tick();
    expect(t.timeLeft, 1); // off: doesn't count down, but elapsed still tracks
    expect(t.elapsed, 1);
    t.toggle();
    t.tick();
    t.tick();
    expect(t.timeLeft, 0);
    expect(expired, 0);
  });

  test('paused timer does not tick until a phase restarts it', () {
    var expired = 0;
    final t = RunnerTimer(mode: ExamMode.exam, durationSec: 120, running: false, onExpire: () => expired++);
    t.tick();
    expect(t.elapsed, 0);
    t.restart(1);
    t.tick();
    expect(expired, 1);
  });
}
