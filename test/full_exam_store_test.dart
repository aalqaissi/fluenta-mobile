import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/features/full_exam/full_exam_store.dart';

void main() {
  setUp(FullExamStore.reset);

  test('sections unlock in the fixed IELTS order', () {
    expect(FullExamStore.next, 'listening');
    FullExamStore.record('listening', 6.5);
    expect(FullExamStore.next, 'reading');
    FullExamStore.record('reading', 6.0);
    expect(FullExamStore.next, 'writing');
  });

  test('writing completes only when both tasks are graded, Task 2 double-weighted', () {
    FullExamStore.record('writingT1', 6.0);
    expect(FullExamStore.has('writing'), isFalse);
    FullExamStore.record('writingT2', 7.0);
    // (6 + 2*7) / 3 = 6.67 -> 6.5
    expect(FullExamStore.bands['writing'], 6.5);
  });

  test('overall is the mean of all four sections, null until complete', () {
    FullExamStore.record('listening', 6.5);
    FullExamStore.record('reading', 6.0);
    expect(FullExamStore.overall, isNull);
    FullExamStore.record('writingT1', 6.0);
    FullExamStore.record('writingT2', 6.0);
    FullExamStore.record('speaking', 7.0);
    // (6.5 + 6 + 6 + 7) / 4 = 6.375 -> 6.5
    expect(FullExamStore.overall, 6.5);
  });

  test('reset clears the session', () {
    FullExamStore.record('reading', 7.0);
    FullExamStore.reset();
    expect(FullExamStore.has('reading'), isFalse);
    expect(FullExamStore.next, 'listening');
  });
}
