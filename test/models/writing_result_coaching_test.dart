import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

void main() {
  test('parses essay type and the separate Yalla coaching layer', () {
    final r = WritingResult.fromJson({
      'overall': 6.5,
      'wordCount': 260,
      'answer': 'essay',
      'criteria': [
        {'key': 'task', 'label': 'Task Response', 'band': 6, 'summary': 's'},
      ],
      'annotations': [],
      'essayType': 'discussion',
      'coaching': [
        {'key': 'peel', 'title': 'PEEL paragraph development', 'status': 'improve', 'note': 'Add an example.'},
      ],
    });
    expect(r.criteria.single.label, 'Task Response');
    expect(r.essayType, 'discussion');
    expect(r.coaching.single.status, 'improve');
  });

  test('older results without coaching still parse', () {
    final r = WritingResult.fromJson({'overall': 6, 'criteria': [], 'annotations': []});
    expect(r.coaching, isEmpty);
    expect(r.essayType, isNull);
  });
}
