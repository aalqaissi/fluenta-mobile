import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';
import 'package:fluenta_mobile/services/exam_convert.dart';

ExamDto _dto(String skill, Map<String, dynamic> content, {String format = 'studio', String id = 'e1'}) => ExamDto(
      id: id,
      skill: skill,
      title: 'Studio $skill',
      module: 'academic',
      status: 'published',
      scope: 'user',
      timeLimit: 40,
      format: format,
      content: content,
    );

void main() {
  group('studio reading → runner', () {
    final dto = _dto('reading', {
      'passages': [
        {
          'id': 'p1',
          'title': 'The Repair Cafe',
          'text': 'Para one.\n\nPara two.',
          'questionType': 'true-false-notgiven',
          'questions': [
            {'id': 'q1', 'prompt': 'S1', 'answer': 'FALSE'},
            {'id': 'q2', 'prompt': 'S2', 'answer': 'TRUE'},
            {
              'id': 'q3', 'prompt': 'Which?', 'answer': 'B', 'type': 'multiple-choice',
              'options': ['Alpha', 'Beta'],
            },
            {'id': 'q4', 'prompt': 'Para?', 'answer': 'F', 'type': 'matching-information'},
          ],
        },
        {
          'id': 'p2',
          'title': '',
          'text': 'Second.',
          'questionType': 'sentence-completion',
          'questions': [
            {'id': 'q5', 'prompt': 'Fill', 'answer': 'glass', 'wordLimit': 2},
          ],
        },
      ],
    });
    final exam = readingExamFromContent(runnerContent(dto));

    test('keeps exam id/title/duration from the dto', () {
      expect(exam.id, 'e1');
      expect(exam.title, 'Studio reading');
      expect(exam.durationSec, 40 * 60);
    });

    test('maps passages, splitting paragraphs on blank lines', () {
      expect(exam.passages, hasLength(2));
      expect(exam.passages[0].headline, 'The Repair Cafe');
      expect(exam.passages[0].paragraphs, ['Para one.', 'Para two.']);
      expect(exam.passages[1].headline, 'Passage 2');
      expect(exam.passages[1].passageNumber, 2);
      expect(exam.passages[1].totalPassages, 2);
    });

    test('groups consecutive questions by how they render', () {
      final groups = exam.passages[0].groups;
      expect(groups.map((g) => g.type), [
        QuestionType.trueFalseNotGiven,
        QuestionType.multipleChoice,
        QuestionType.shortAnswer, // matching without shared options → typed answer
      ]);
      expect(groups[0].sharedOptions!.map((o) => o.key), ['True', 'False', 'Not Given']);
      expect(groups[1].questions.single.options!.map((o) => '${o.key}:${o.text}'), ['A:Alpha', 'B:Beta']);
    });

    test('numbers questions continuously and keeps answers + word limits', () {
      final qs = [for (final p in exam.passages) for (final g in p.groups) ...g.questions];
      expect(qs.map((q) => q.number), [1, 2, 3, 4, 5]);
      expect(qs.map((q) => q.correct), ['FALSE', 'TRUE', 'B', 'F', 'glass']);
      expect(qs.last.wordLimit, 'Max 2 words');
    });
  });

  test('runner-format content passes through untouched', () {
    final content = {'id': 'r', 'title': 'R', 'passages': []};
    expect(runnerContent(_dto('reading', content, format: 'runner')), same(content));
  });

  test('studio listening → runner sections with audio', () {
    final exam = listeningExamFromContent(runnerContent(_dto('listening', {
      'sections': [
        {
          'id': 's1', 'title': 'Club call', 'audioUrl': '/api/files/a.mp3', 'audioDurationSec': 95,
          'questionType': 'sentence-completion',
          'questions': [{'id': 'q1', 'prompt': 'Name', 'answer': 'Tom'}],
        },
      ],
    })));
    expect(exam.durationSec, 40 * 60);
    expect(exam.sections.single.context, 'Club call');
    expect(exam.sections.single.audioUrl, '/api/files/a.mp3');
    expect(exam.sections.single.audioDurationSec, 95);
    expect(exam.sections.single.group.type, QuestionType.sentenceCompletion);
    expect(exam.sections.single.group.questions.single.correct, 'Tom');
  });

  test('studio speaking → parts (cue card only for part 2)', () {
    final parts = speakingPartsFromContent(runnerContent(_dto('speaking', {
      'parts': [
        {'id': 'a', 'number': 1, 'title': 'Intro', 'cueCard': '', 'topic': '', 'questions': [{'id': 'x', 'text': 'Where do you live?'}, {'id': 'y', 'text': ''}]},
        {'id': 'b', 'number': 2, 'title': 'Long turn', 'cueCard': '', 'topic': 'Describe a trip', 'questions': []},
      ],
    })));
    expect(parts[0].questions, ['Where do you live?']);
    expect(parts[0].cueCard, isNull);
    expect(parts[1].cueCard, 'Describe a trip');
  });

  group('pickRandom', () {
    test('returns null for an empty list', () => expect(pickRandom(<String>[]), isNull));
    test('avoids the given item when there is another choice', () {
      for (var seed = 0; seed < 20; seed++) {
        expect(pickRandom(['a', 'b'], avoid: 'a', rng: Random(seed)), 'b');
      }
    });
    test('still returns the only item even if it is avoided', () {
      expect(pickRandom(['a'], avoid: 'a'), 'a');
    });
  });
}
