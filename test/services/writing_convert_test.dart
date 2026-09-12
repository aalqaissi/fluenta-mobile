import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/services/writing_convert.dart';

void main() {
  const content = {
    'writing': {
      'academicT1': {'chartType': 'bar-chart', 'prompt': 'Describe the chart.', 'minWords': 150, 'timeMinutes': 20},
      'generalT1': {'formality': 'formal', 'prompt': 'Write a complaint letter.', 'minWords': 150, 'timeMinutes': 20},
      'task2': {'prompt': 'Discuss both views.', 'minWords': 250, 'timeMinutes': 40},
    },
  };

  test('produces three tasks with web-matching ids, kinds, visual and durations', () {
    final tasks = writingTasksFromContent('exam9', Map<String, dynamic>.from(content));
    expect(tasks.map((t) => t.id), ['exam9~t1a', 'exam9~t1g', 'exam9~t2']);

    final a = tasks[0];
    expect(a.taskNumber, 1);
    expect(a.kind, 'Report');
    expect(a.module, 'academic');
    expect(a.visual, 'bar');            // bar-chart -> bar
    expect(a.minWords, 150);
    expect(a.durationSec, 20 * 60);
    expect(a.prompt, 'Describe the chart.');

    final g = tasks[1];
    expect(g.kind, 'Formal letter');    // formal -> Formal letter
    expect(g.module, 'general');
    expect(g.visual, isNull);

    final t2 = tasks[2];
    expect(t2.taskNumber, 2);
    expect(t2.kind, 'Opinion Essay');
    expect(t2.module, 'both');
    expect(t2.minWords, 250);
    expect(t2.durationSec, 40 * 60);
  });

  test('no writing block yields no tasks', () {
    expect(writingTasksFromContent('x', const {}), isEmpty);
  });

  test('missing sub-blocks are skipped and defaults apply', () {
    final tasks = writingTasksFromContent('e', {'writing': {'task2': {}}});
    expect(tasks.map((t) => t.id), ['e~t2']);
    expect(tasks[0].minWords, 250);          // default
    expect(tasks[0].durationSec, 40 * 60);   // default
  });
}
