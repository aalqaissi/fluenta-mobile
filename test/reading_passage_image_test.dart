import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluenta_mobile/config/app_config.dart';
import 'package:fluenta_mobile/features/reading/reading_runner_screen.dart';
import 'package:fluenta_mobile/models/models.dart';
import 'package:fluenta_mobile/services/api_client.dart';
import 'package:fluenta_mobile/services/exam_convert.dart';
import 'package:fluenta_mobile/state/app_state.dart';
import 'package:fluenta_mobile/state/auth_state.dart';

/// A Content Studio passage as the web Studio saves it: lettered paragraphs + an uploaded diagram.
const _studioExam = ExamDto(
  id: 'e1',
  skill: 'reading',
  title: 'Glass',
  module: 'academic',
  status: 'published',
  scope: 'user',
  timeLimit: 60,
  format: 'studio',
  content: {
    'passages': [
      {
        'id': 'p1',
        'title': 'The History of Glass',
        'text': 'A\nGlass was first made around 3500 BC.\nB\nRomans spread glassblowing.',
        'imageUrl': '/media/furnace.png',
        'imageName': 'furnace.png',
        'questionType': 'diagram-label',
        'questions': [
          {'id': 'q1', 'prompt': 'Label 1', 'answer': 'furnace', 'wordLimit': 1},
        ],
      },
    ],
  },
);

Future<void> _pump(WidgetTester tester, ReadingExam exam) async {
  tester.view.physicalSize = const Size(1000, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  SharedPreferences.setMockInitialValues({});
  final config = await AppConfig.load();
  final auth = AuthState(config: config, api: ApiClient(config, client: MockClient((_) async => http.Response('{}', 200))));
  final app = AppState()..bind(auth);
  await tester.pumpWidget(MultiProvider(
    providers: [ChangeNotifierProvider.value(value: auth), ChangeNotifierProvider.value(value: app)],
    child: MaterialApp(home: ReadingRunnerScreen(exam: exam, examId: 'e1')),
  ));
  await tester.pump();
}

void main() {
  testWidgets('the passage shows its diagram image, paragraph letters and text', (tester) async {
    await _pump(tester, readingExamFromContent(runnerContent(_studioExam)));

    // The uploaded diagram, resolved against the configured server (like listening audio).
    final images = find.byWidgetPredicate(
        (w) => w is Image && w.image is NetworkImage && (w.image as NetworkImage).url == 'http://localhost:8080/media/furnace.png');
    expect(images, findsOneWidget);

    // Paragraph letters and the passage text.
    expect(find.text('A'), findsWidgets);
    expect(find.text('B'), findsWidgets);
    expect(find.textContaining('Glass was first made around 3500 BC.', findRichText: true), findsOneWidget);
    expect(find.textContaining('Romans spread glassblowing.', findRichText: true), findsOneWidget);

    // The image sits between the title and the first paragraph.
    final titleY = tester.getTopLeft(find.text('The History of Glass')).dy;
    final imageY = tester.getTopLeft(images).dy;
    final textY = tester.getTopLeft(find.textContaining('Glass was first made', findRichText: true)).dy;
    expect(titleY < imageY && imageY < textY, isTrue, reason: 'title $titleY, image $imageY, text $textY');
  });

  testWidgets('a passage without an image shows no image', (tester) async {
    final noImage = ExamDto.fromJson({
      'id': 'e2', 'skill': 'reading', 'title': 'T', 'format': 'studio',
      'content': {
        'passages': [
          {'id': 'p1', 'title': 'Plain', 'text': 'Just text.', 'questionType': 'short-answer', 'questions': []},
        ],
      },
    });
    await _pump(tester, readingExamFromContent(runnerContent(noImage)));
    expect(find.byWidgetPredicate((w) => w is Image && w.image is NetworkImage), findsNothing);
    expect(find.textContaining('Just text.', findRichText: true), findsOneWidget);
  });
}
