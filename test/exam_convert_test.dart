import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/models/models.dart';
import 'package:fluenta_mobile/services/exam_convert.dart';

const _content = {
  'id': 'read-x',
  'title': 'Reading X',
  'durationSec': 1200,
  'questionTypes': ['true-false-notgiven', 'multiple-choice'],
  'passages': [
    {
      'id': 'p1',
      'headline': 'The Passage',
      'label': 'Academic',
      'passageNumber': 1,
      'totalPassages': 1,
      'paragraphs': ['Para one.', 'Para two.'],
      'groups': [
        {
          'id': 'p1g1',
          'type': 'true-false-notgiven',
          'rangeLabel': 'Questions 1–2',
          'instructions': 'Choose TFNG.',
          'sharedOptions': [
            {'key': 'True', 'text': 'True'},
            {'key': 'False', 'text': 'False'},
            {'key': 'Not Given', 'text': 'Not Given'},
          ],
          'questions': [
            {'id': 'q1', 'number': 1, 'prompt': 'Statement 1', 'correct': 'False'},
            {'id': 'q2', 'number': 2, 'prompt': 'Statement 2', 'correct': 'True'},
          ],
        },
        {
          'id': 'p1g2',
          'type': 'multiple-choice',
          'rangeLabel': 'Question 3',
          'instructions': 'Pick one.',
          'questions': [
            {
              'id': 'q3', 'number': 3, 'prompt': 'Which?', 'correct': 'B',
              'options': [
                {'key': 'A', 'text': 'Option A'},
                {'key': 'B', 'text': 'Option B'},
              ],
            },
          ],
        },
      ],
    },
  ],
};

void main() {
  test('readingExamFromContent maps passages, groups, questions and types', () {
    final exam = readingExamFromContent(Map<String, dynamic>.from(_content));
    expect(exam.id, 'read-x');
    expect(exam.durationSec, 1200);
    expect(exam.questionTypes.first, QuestionType.trueFalseNotGiven);
    expect(exam.passages.length, 1);
    final p = exam.passages.first;
    expect(p.headline, 'The Passage');
    expect(p.groups.length, 2);
    final g1 = p.groups.first;
    expect(g1.type, QuestionType.trueFalseNotGiven);
    expect(g1.sharedOptions!.length, 3);
    expect(g1.questions.first.correct, 'False');
    final g2 = p.groups[1];
    expect(g2.type, QuestionType.multipleChoice);
    expect(g2.questions.first.options!.map((o) => o.key), ['A', 'B']);
  });

  test('listeningExamFromContent maps sections + single group per section', () {
    const content = {
      'id': 'listen-x', 'title': 'Listening X', 'durationSec': 1800,
      'sections': [
        {
          'id': 'ls1', 'number': 1, 'context': 'A conversation.', 'audioDurationSec': 60,
          'group': {
            'id': 'ls1-g', 'type': 'sentence-completion', 'rangeLabel': 'Questions 1–2',
            'instructions': 'Complete the notes.',
            'questions': [
              {'id': 'ls1q1', 'number': 1, 'prompt': 'Booked for __ hours.', 'correct': 'four', 'wordLimit': 'ONE WORD'},
              {'id': 'ls1q2', 'number': 2, 'prompt': 'Deposit in __ days.', 'correct': 'five'},
            ],
          },
        },
      ],
    };
    final exam = listeningExamFromContent(Map<String, dynamic>.from(content));
    expect(exam.id, 'listen-x');
    expect(exam.durationSec, 1800);
    expect(exam.sections.length, 1);
    final s = exam.sections.first;
    expect(s.number, 1);
    expect(s.audioDurationSec, 60);
    expect(s.group.type, QuestionType.sentenceCompletion);
    expect(s.group.questions.first.correct, 'four');
  });

  test('speakingPartsFromContent maps parts, cue card and questions', () {
    const content = {
      'parts': [
        {'id': 's1', 'number': 1, 'title': 'Interview', 'questions': ['Q1', 'Q2']},
        {'id': 's2', 'number': 2, 'title': 'Long turn', 'cueCard': 'Describe a skill.', 'bullets': ['what', 'why'], 'questions': []},
      ],
    };
    final parts = speakingPartsFromContent(Map<String, dynamic>.from(content));
    expect(parts.length, 2);
    expect(parts.first.questions, ['Q1', 'Q2']);
    expect(parts[1].cueCard, 'Describe a skill.');
    expect(parts[1].bullets, ['what', 'why']);
  });
}
