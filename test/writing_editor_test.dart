import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/features/writing/visual_prompt.dart';

void main() {
  testWidgets('VisualPrompt renders a caption when visual is set', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: 'bar'))));
    expect(find.textContaining('internet access'), findsOneWidget);
  });

  testWidgets('VisualPrompt renders nothing when visual is null', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: null))));
    expect(find.descendant(of: find.byType(VisualPrompt), matching: find.byType(CustomPaint)), findsNothing);
  });
}
