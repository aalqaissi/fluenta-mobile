import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/features/writing/visual_prompt.dart';
import 'package:go_router/go_router.dart';
import 'package:fluenta_mobile/features/writing/writing_editor_screen.dart';
import 'package:fluenta_mobile/models/models.dart';
import 'package:fluenta_mobile/utils/exam_mode.dart';

void main() {
  testWidgets('VisualPrompt renders a caption when visual is set', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: 'bar'))));
    expect(find.textContaining('internet access'), findsOneWidget);
  });

  testWidgets('VisualPrompt renders nothing when visual is null', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: null))));
    expect(find.descendant(of: find.byType(VisualPrompt), matching: find.byType(CustomPaint)), findsNothing);
  });

  testWidgets('editor starts empty and shows the visual for an Academic task', (tester) async {
    // Tall viewport so the ListView lays out the chart + TextField without
    // virtualizing them out of the tree (same pattern as onboarding_test.dart).
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const task = WritingTask(
        id: 'e~t1a', taskNumber: 1, kind: 'Report', prompt: 'Describe the chart.',
        minWords: 150, durationSec: 1200, visual: 'bar', module: 'academic');
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (c, s) => const WritingEditorScreen(taskId: 'e~t1a', task: task)),
    ]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    // text box is empty
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text ?? '', '');
    // visual prompt rendered
    expect(find.textContaining('internet access'), findsOneWidget);
  });

  Future<void> pumpEditor(WidgetTester tester, {ExamMode mode = ExamMode.practice}) async {
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const task = WritingTask(
        id: 'e~t1a', taskNumber: 1, kind: 'Report', prompt: 'Describe the chart.',
        minWords: 150, durationSec: 1500, visual: null, module: 'academic');
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (c, s) => WritingEditorScreen(taskId: 'e~t1a', task: task, mode: mode)),
    ]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  testWidgets('practice: the timer is optional and starts switched off', (tester) async {
    await pumpEditor(tester);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Timer off'), findsOneWidget);
    await tester.tap(find.text('Timer off'));
    await tester.pump();
    expect(find.text('25:00'), findsOneWidget); // the task's own time once switched on
  });

  testWidgets('exam: Task 1 runs the official 20-minute countdown', (tester) async {
    await pumpEditor(tester, mode: ExamMode.exam);
    expect(find.text('Exam'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('19:59'), findsOneWidget);
  });
}
