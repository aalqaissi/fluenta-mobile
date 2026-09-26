import 'dart:math';

import '../models/models.dart';

/// Picks a random item, avoiding [avoid] whenever there is any other choice.
/// Students get a random published exam rather than always the first one.
T? pickRandom<T>(List<T> items, {T? avoid, Random? rng}) {
  final pool = items.length > 1 && avoid != null ? items.where((e) => e != avoid).toList() : items;
  if (pool.isEmpty) return null;
  return pool[(rng ?? Random()).nextInt(pool.length)];
}

/// The runner-format `content` for any published exam. Built-in exams are
/// stored in runner format already; Content Studio exams ("studio" format) are
/// converted the same way the web app does, so both play in the same runners.
Map<String, dynamic> runnerContent(ExamDto e) {
  if (e.format != 'studio') return e.content;
  return switch (e.skill) {
    'reading' => _studioReading(e),
    'listening' => _studioListening(e),
    'speaking' => _studioSpeaking(e),
    _ => e.content,
  };
}

const _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
const _wordLimitTypes = {'sentence-completion', 'summary-completion', 'short-answer', 'diagram-label'};
const _tfng = [
  {'key': 'True', 'text': 'True'},
  {'key': 'False', 'text': 'False'},
  {'key': 'Not Given', 'text': 'Not Given'},
];
const _ynng = [
  {'key': 'Yes', 'text': 'Yes'},
  {'key': 'No', 'text': 'No'},
  {'key': 'Not Given', 'text': 'Not Given'},
];

List<Map<String, dynamic>> _maps(dynamic raw) =>
    ((raw as List?) ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();

/// How a studio question can be answered on mobile: TF/NG and Y/N/NG keep their
/// pills, multiple choice keeps its lettered options, and everything else (which
/// the Studio captures as prompt + answer only) becomes a typed answer.
String _renderKind(String type) => switch (type) {
      'true-false-notgiven' || 'yes-no-notgiven' => type,
      'multiple-choice' || 'multi-select' => 'multiple-choice',
      _ when _wordLimitTypes.contains(type) => type,
      _ => 'short-answer',
    };

String _instructions(String kind) => switch (kind) {
      'true-false-notgiven' => 'Do the following statements agree with the information in the passage? Choose True, False or Not Given.',
      'yes-no-notgiven' => "Do the following statements agree with the writer's views? Choose Yes, No or Not Given.",
      'multiple-choice' => 'Choose the correct letter for each question.',
      'short-answer' => 'Answer the questions. Write no more than the stated number of words.',
      _ => 'Complete each sentence. Write no more than the stated number of words.',
    };

/// Splits a passage/section's studio questions into runner groups — one per run
/// of consecutive questions that render the same way. [counter] numbers
/// questions continuously across the whole exam.
List<Map<String, dynamic>> _studioGroups(String ownerId, String defaultType, List<Map<String, dynamic>> questions, List<int> counter) {
  final groups = <Map<String, dynamic>>[];
  for (final q in questions) {
    final kind = _renderKind((q['type'] as String?) ?? defaultType);
    if (groups.isEmpty || groups.last['type'] != kind) {
      groups.add({
        'id': '$ownerId-g${groups.length + 1}',
        'type': kind,
        'rangeLabel': 'Questions (${questionTypeFromKey(kind).label})',
        'instructions': _instructions(kind),
        if (kind == 'true-false-notgiven') 'sharedOptions': _tfng,
        if (kind == 'yes-no-notgiven') 'sharedOptions': _ynng,
        'questions': <Map<String, dynamic>>[],
      });
    }
    final limit = (q['wordLimit'] as num?)?.toInt();
    final options = (q['options'] as List?) ?? const [];
    (groups.last['questions'] as List).add({
      'id': q['id'],
      'number': counter[0]++,
      'prompt': (q['prompt'] as String?) ?? '',
      'correct': (q['answer'] as String?) ?? '',
      if (limit != null && limit > 0 && kind != 'multiple-choice') 'wordLimit': 'Max $limit word${limit == 1 ? '' : 's'}',
      if (kind == 'multiple-choice')
        'options': [
          for (var i = 0; i < options.length && i < _letters.length; i++)
            {'key': _letters[i], 'text': '${options[i]}'.isEmpty ? 'Option ${_letters[i]}' : '${options[i]}'},
        ],
    });
  }
  return groups;
}

Map<String, dynamic> _studioReading(ExamDto e) {
  final passages = _maps(e.content['passages']);
  final counter = [1];
  return {
    'id': e.id,
    'title': e.title,
    'durationSec': (e.timeLimit > 0 ? e.timeLimit : 60) * 60,
    'questionTypes': passages.map((p) => p['questionType']).toSet().toList(),
    'passages': [
      for (var i = 0; i < passages.length; i++)
        {
          'id': passages[i]['id'],
          'headline': ((passages[i]['title'] as String?) ?? '').isEmpty ? 'Passage ${i + 1}' : passages[i]['title'],
          'label': e.module == 'general' ? 'General Training' : 'Academic',
          'passageNumber': i + 1,
          'totalPassages': passages.length,
          'paragraphs': ((passages[i]['text'] as String?) ?? '')
              .split(RegExp(r'\n{2,}'))
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
          'groups': _studioGroups('${passages[i]['id']}', (passages[i]['questionType'] as String?) ?? 'short-answer',
              _maps(passages[i]['questions']), counter),
        },
    ],
  };
}

Map<String, dynamic> _studioListening(ExamDto e) {
  final sections = _maps(e.content['sections']);
  final counter = [1];
  return {
    'id': e.id,
    'title': e.title,
    'durationSec': (e.timeLimit > 0 ? e.timeLimit : 30) * 60,
    'sections': [
      for (var i = 0; i < sections.length; i++)
        {
          'number': i + 1,
          'context': ((sections[i]['title'] as String?) ?? '').isEmpty ? 'Section ${i + 1}' : sections[i]['title'],
          'audioDurationSec': (sections[i]['audioDurationSec'] as num?)?.toInt() ?? 60,
          'audioUrl': sections[i]['audioUrl'],
          // The mobile runner shows one group per section; a mixed section falls
          // back to typed answers so every question stays answerable.
          'group': _singleGroup(_studioGroups('${sections[i]['id']}',
              (sections[i]['questionType'] as String?) ?? 'short-answer', _maps(sections[i]['questions']), counter)),
        },
    ],
  };
}

Map<String, dynamic> _singleGroup(List<Map<String, dynamic>> groups) {
  if (groups.length == 1) return groups.single;
  final questions = [for (final g in groups) ...(g['questions'] as List)];
  return {
    'id': groups.isEmpty ? 'g' : groups.first['id'],
    'type': 'short-answer',
    'rangeLabel': 'Questions',
    'instructions': _instructions('short-answer'),
    'questions': questions.map((q) => Map<String, dynamic>.from(q as Map)..remove('options')).toList(),
  };
}

Map<String, dynamic> _studioSpeaking(ExamDto e) => {
      'id': e.id,
      'title': e.title,
      'parts': [
        for (final p in _maps(e.content['parts']))
          {
            'number': p['number'],
            'title': p['title'],
            if (p['number'] == 2)
              'cueCard': ((p['cueCard'] as String?) ?? '').isNotEmpty ? p['cueCard'] : (((p['topic'] as String?) ?? '').isEmpty ? null : p['topic']),
            'questions': p['number'] == 2
                ? <String>[]
                : _maps(p['questions']).map((q) => (q['text'] as String?) ?? '').where((t) => t.isNotEmpty).toList(),
          },
      ],
    };

/// Converts a backend reading exam (runner-format `content` JSON) into the
/// runtime [ReadingExam] the mobile runner already understands.
ReadingExam readingExamFromContent(Map<String, dynamic> content) {
  final passages = ((content['passages'] as List?) ?? [])
      .map((p) => _passage(Map<String, dynamic>.from(p as Map)))
      .toList();
  final types = ((content['questionTypes'] as List?) ?? [])
      .map((t) => questionTypeFromKey(t as String?))
      .toList();
  return ReadingExam(
    id: (content['id'] as String?) ?? 'reading',
    title: (content['title'] as String?) ?? 'Reading practice',
    durationSec: (content['durationSec'] as num?)?.toInt() ?? 60 * 60,
    questionTypes: types,
    passages: passages,
  );
}

/// Converts a backend listening exam (runner-format `content` JSON) into the
/// runtime [ListeningRunExam]. Each section carries a single question group.
ListeningRunExam listeningExamFromContent(Map<String, dynamic> content) {
  final sections = ((content['sections'] as List?) ?? [])
      .map((s) => _listeningSection(Map<String, dynamic>.from(s as Map)))
      .toList();
  return ListeningRunExam(
    id: (content['id'] as String?) ?? 'listening',
    title: (content['title'] as String?) ?? 'Listening practice',
    durationSec: (content['durationSec'] as num?)?.toInt() ?? 30 * 60,
    sections: sections,
  );
}

ListeningRunSection _listeningSection(Map<String, dynamic> s) => ListeningRunSection(
      number: (s['number'] as num?)?.toInt() ?? 1,
      context: (s['context'] as String?) ?? '',
      audioDurationSec: (s['audioDurationSec'] as num?)?.toInt() ?? 60,
      audioUrl: s['audioUrl'] as String?,
      group: _group(Map<String, dynamic>.from((s['group'] as Map?) ?? const {})),
    );

Passage _passage(Map<String, dynamic> p) => Passage(
      id: (p['id'] as String?) ?? '',
      headline: (p['headline'] as String?) ?? (p['title'] as String?) ?? '',
      label: (p['label'] as String?) ?? 'Academic',
      passageNumber: (p['passageNumber'] as num?)?.toInt() ?? 1,
      totalPassages: (p['totalPassages'] as num?)?.toInt() ?? 1,
      paragraphs:
          ((p['paragraphs'] as List?) ?? []).map((e) => '$e').toList(),
      groups: ((p['groups'] as List?) ?? [])
          .map((g) => _group(Map<String, dynamic>.from(g as Map)))
          .toList(),
    );

/// Converts a backend speaking exam's `content.parts` into the runtime
/// [SpeakingPart] list. Speaking is AI-graded (held) — this loads the prompts only.
List<SpeakingPart> speakingPartsFromContent(Map<String, dynamic> content) {
  return ((content['parts'] as List?) ?? []).map((p) {
    final m = Map<String, dynamic>.from(p as Map);
    return SpeakingPart(
      number: (m['number'] as num?)?.toInt() ?? 1,
      title: (m['title'] as String?) ?? '',
      cueCard: m['cueCard'] as String?,
      bullets: (m['bullets'] as List?)?.map((e) => '$e').toList(),
      questions: ((m['questions'] as List?) ?? []).map((e) => '$e').toList(),
    );
  }).toList();
}

QuestionGroup _group(Map<String, dynamic> g) => QuestionGroup(
      id: (g['id'] as String?) ?? '',
      type: questionTypeFromKey(g['type'] as String?),
      rangeLabel: (g['rangeLabel'] as String?) ?? '',
      instructions: (g['instructions'] as String?) ?? '',
      sharedOptions: _options(g['sharedOptions']),
      questions: ((g['questions'] as List?) ?? [])
          .map((q) => _question(Map<String, dynamic>.from(q as Map)))
          .toList(),
    );

Question _question(Map<String, dynamic> q) => Question(
      id: (q['id'] as String?) ?? '',
      number: (q['number'] as num?)?.toInt() ?? 0,
      prompt: (q['prompt'] as String?) ?? '',
      correct: '${q['correct'] ?? ''}',
      wordLimit: q['wordLimit'] as String?,
      options: _options(q['options']),
    );

List<QuestionOption>? _options(dynamic raw) {
  if (raw is! List || raw.isEmpty) return null;
  return raw.map((o) {
    if (o is Map) {
      return QuestionOption('${o['key'] ?? ''}', '${o['text'] ?? o['key'] ?? ''}');
    }
    return QuestionOption('$o', '$o');
  }).toList();
}
