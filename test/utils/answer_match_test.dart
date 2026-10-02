import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/utils/answer_match.dart';

/// Shared vectors copied verbatim from fluenta-web backend/src/test/resources/answer-match-vectors.json.
void main() {
  final vectors = jsonDecode(File('test/fixtures/answer-match-vectors.json').readAsStringSync()) as List;

  for (final raw in vectors) {
    final v = raw as Map<String, dynamic>;
    test(v['note'] as String, () {
      final key = AnswerKey(
        v['answer'] as String,
        accepted: ((v['accepted'] as List?) ?? const []).cast<String>(),
        wordLimit: v['wordLimit'],
        type: v['type'] as String?,
      );
      expect(answerMatches(v['given'] as String, key), v['expect']);
    });
  }

  // Per-letter marks for multi-select ("Choose TWO/THREE") — answer-marks-vectors.json, same source.
  final marks = jsonDecode(File('test/fixtures/answer-marks-vectors.json').readAsStringSync()) as List;
  for (final raw in marks) {
    final v = raw as Map<String, dynamic>;
    test('marks: ${v['note']}', () {
      final m = answerMarks(v['given'] as String, AnswerKey(v['answer'] as String, wordLimit: v['wordLimit'], type: v['type'] as String?));
      expect('${m.earned}/${m.total}', '${v['earned']}/${v['total']}');
    });
  }
}
