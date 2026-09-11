import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

const _json = {
  'targetBand': 7, 'currentAverage': 6, 'gapToTarget': 1, 'testsCompleted': 37,
  'skills': [
    {'key': 'reading', 'label': 'Reading', 'band': 6.0, 'tests': 9},
    {'key': 'vocabulary', 'label': 'Vocabulary', 'band': 6.5, 'tests': 6},
    {'key': 'writing', 'label': 'Writing', 'band': null, 'tests': 0},
  ],
  'strongest': {'key': 'listening', 'label': 'Listening', 'band': 6.5},
  'weakest': {'key': 'writing', 'label': 'Writing', 'band': 5.5},
  'series': {
    'overall': [
      {'date': '2026-08-18', 'band': 4.5},
      {'date': '2026-09-02', 'band': 6.0},
    ],
  },
  'recentActivity': [
    {'id': 'ra1', 'type': 'completed', 'skill': 'reading', 'title': 'Completed Reading', 'date': '2026-09-04', 'band': 6.0},
  ],
};

void main() {
  test('Overview.fromJson parses all sections', () {
    final o = Overview.fromJson(Map<String, dynamic>.from(_json));
    expect(o.targetBand, 7);
    expect(o.gapToTarget, 1);
    expect(o.testsCompleted, 37);
    expect(o.skills.length, 3);
    expect(o.skills.firstWhere((s) => s.key == 'writing').band, isNull);
    expect(o.strongest?.label, 'Listening');
    expect(o.series['overall']!.length, 2);
    expect(o.recentActivity.first.type, 'completed');
    expect(o.recentActivity.first.band, 6.0);
  });

  test('SkillKey has 6 skills and coming-soon set', () {
    expect(SkillKey.values.length, 6);
    expect(comingSoonSkills, containsAll(['vocabulary', 'grammar']));
    expect(SkillKey.vocabulary.label, 'Vocabulary');
  });
}
