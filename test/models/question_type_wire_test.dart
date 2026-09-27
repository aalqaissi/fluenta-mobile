import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';

void main() {
  test('every question type round-trips through its backend key', () {
    for (final t in QuestionType.values) {
      expect(questionTypeFromKey(t.wireKey), t, reason: t.wireKey);
    }
  });

  test('the IELTS completion types from the owner spec are supported', () {
    expect(questionTypeFromKey('flow-chart-completion'), QuestionType.flowChartCompletion);
    expect(QuestionType.formCompletion.label, 'Form Completion');
  });
}
