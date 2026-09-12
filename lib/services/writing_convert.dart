import '../models/models.dart';

const _chartVisual = {
  'bar-chart': 'bar',
  'line-graph': 'line',
  'pie-chart': 'pie',
  'process-diagram': 'process',
  'diagram': 'process',
  'maps': 'map',
  'table': 'table',
  'multiple-graph': 'line',
};

const _formalityKind = {
  'formal': 'Formal letter',
  'informal': 'Informal letter',
  'semi-formal': 'Semi-formal letter',
};

/// Converts a Studio-authored writing exam's `content` into up to three runtime
/// [WritingTask]s (Academic Task 1, General Task 1, Task 2) — the Dart port of the
/// web's `studioWritingToExam`. Ids match the web scheme so results/routing align.
List<WritingTask> writingTasksFromContent(String examId, Map<String, dynamic> content) {
  final w = content['writing'];
  if (w is! Map) return const [];
  final writing = Map<String, dynamic>.from(w);
  final out = <WritingTask>[];

  Map<String, dynamic>? block(String key) {
    final v = writing[key];
    return v is Map ? Map<String, dynamic>.from(v) : null;
  }

  int minWords(Map<String, dynamic>? m, int def) => (m?['minWords'] as num?)?.toInt() ?? def;
  int seconds(Map<String, dynamic>? m, int defMin) => ((m?['timeMinutes'] as num?)?.toInt() ?? defMin) * 60;
  String prompt(Map<String, dynamic>? m, String def) {
    final p = (m?['prompt'] as String?)?.trim();
    return (p == null || p.isEmpty) ? def : p;
  }

  final a = block('academicT1');
  if (a != null) {
    out.add(WritingTask(
      id: '$examId~t1a',
      taskNumber: 1,
      kind: 'Report',
      module: 'academic',
      prompt: prompt(a, 'Summarise the information shown in the chart.'),
      minWords: minWords(a, 150),
      durationSec: seconds(a, 20),
      visual: _chartVisual[a['chartType'] as String?],
    ));
  }

  final g = block('generalT1');
  if (g != null) {
    out.add(WritingTask(
      id: '$examId~t1g',
      taskNumber: 1,
      kind: _formalityKind[g['formality'] as String?] ?? 'Formal letter',
      module: 'general',
      prompt: prompt(g, 'Write a letter as described.'),
      minWords: minWords(g, 150),
      durationSec: seconds(g, 20),
    ));
  }

  final t2 = block('task2');
  if (t2 != null) {
    out.add(WritingTask(
      id: '$examId~t2',
      taskNumber: 2,
      kind: 'Opinion Essay',
      module: 'both',
      prompt: prompt(t2, 'Discuss the topic and give your own opinion.'),
      minWords: minWords(t2, 250),
      durationSec: seconds(t2, 40),
    ));
  }

  return out;
}
