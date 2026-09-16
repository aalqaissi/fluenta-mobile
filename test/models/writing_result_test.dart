import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

void main() {
  test('WritingResult.fromJson parses the backend shape', () {
    final json = {
      'id': 'wf1',
      'source': 'offline',
      'overall': 6.0,
      'wordCount': 248,
      'answer': 'My essay text.',
      'criteria': [
        {'key': 'task', 'label': 'Task Achievement', 'band': 6, 'summary': 's1'},
        {'key': 'coherence', 'label': 'Coherence & Cohesion', 'band': 6, 'summary': 's2'},
        {'key': 'lexical', 'label': 'Lexical Resource', 'band': 6, 'summary': 's3'},
        {'key': 'grammar', 'label': 'Grammatical Range & Accuracy', 'band': 5, 'summary': 's4'},
      ],
      'annotations': [
        {'criterion': 'grammar', 'quote': 'is are', 'note': 'agreement'},
      ],
    };
    final r = WritingResult.fromJson(json);
    expect(r.overall, 6.0);
    expect(r.wordCount, 248);
    expect(r.answer, 'My essay text.');
    expect(r.criteria.length, 4);
    expect(r.criteria.first.key, WritingCriterionKey.task);
    expect(r.criteria.last.key, WritingCriterionKey.grammar);
    expect(r.annotations.single.criterion, WritingCriterionKey.grammar);
    expect(r.annotations.single.quote, 'is are');
  });
}
