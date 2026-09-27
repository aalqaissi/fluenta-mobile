import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fluenta_mobile/features/full_exam/full_exam_screen.dart';
import 'package:fluenta_mobile/features/full_exam/full_exam_store.dart';
import 'package:fluenta_mobile/state/app_state.dart';

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = GoRouter(routes: [GoRoute(path: '/', builder: (c, s) => const FullExamScreen())]);
  await tester.pumpWidget(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: MaterialApp.router(routerConfig: router),
  ));
  await tester.pump();
}

void main() {
  setUp(FullExamStore.reset);

  testWidgets('only the next section can be started; the rest are locked', (tester) async {
    await _pump(tester);
    expect(find.text('Start'), findsOneWidget); // listening
    expect(find.text('Locked'), findsNWidgets(3));
    expect(find.text('Up next'), findsOneWidget);
  });

  testWidgets('writing resumes at Task 2 once Task 1 is graded', (tester) async {
    FullExamStore.record('listening', 6.5);
    FullExamStore.record('reading', 6.0);
    FullExamStore.record('writingT1', 6.0);
    await _pump(tester);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.textContaining('continue with Task 2'), findsOneWidget);
    expect(find.text('Band 6.5'), findsOneWidget); // listening done, no retake button
  });
}
