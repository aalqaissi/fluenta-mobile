import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/features/full_exam/full_exam_store.dart';

void main() {
  setUp(FullExamStore.reset);

  test('overall is null until a scored section is recorded', () {
    expect(FullExamStore.overall, isNull);
    expect(FullExamStore.allScoredDone, isFalse);
  });

  test('records bands and computes overall rounded to nearest 0.5', () {
    FullExamStore.record('listening', 6.5);
    expect(FullExamStore.allScoredDone, isFalse); // reading still missing
    FullExamStore.record('reading', 6.0);
    expect(FullExamStore.allScoredDone, isTrue);
    // mean 6.25 -> nearest 0.5 -> 6.5
    expect(FullExamStore.overall, 6.5);
  });

  test('reset clears the session', () {
    FullExamStore.record('reading', 7.0);
    FullExamStore.reset();
    expect(FullExamStore.has('reading'), isFalse);
    expect(FullExamStore.overall, isNull);
  });
}
