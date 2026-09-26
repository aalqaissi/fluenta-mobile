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

const _letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
const _wordLimitTypes = {'sentence-completion', 'summary-completion', 'short-answer', 'diagram-label'};
/// Matching types answered from a lettered list the admin writes in the Studio.
const _authoredOptionTypes = {'matching-headings', 'matching-features', 'matching-sentence-endings'};
/// Matching types answered with the passage's paragraph letters.
const _paragraphOptionTypes = {'matching-information'};
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

// ---- passage text (mirrors the web app's src/features/studio/passageText.ts) ----

class ParsedPassage {
  final List<String> paragraphs;
  /// Letter per paragraph when the admin labelled them ("A", "B", … IELTS style).
  final List<String>? labels;
  const ParsedPassage(this.paragraphs, [this.labels]);
}

// A line holding only a paragraph letter: "A", "B.", "(C)", "Paragraph D".
final _labelLine = RegExp(r'^\s*(?:paragraph\s+)?\(?([A-Z])[.):]?\s*$', caseSensitive: false);
String _squash(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();

/// Splits passage text into paragraphs. A line containing only a letter labels
/// the paragraph below it (text up to the next label is one paragraph).
/// Unlabelled text splits on blank lines, or on single line breaks when the
/// text has no blank lines at all.
ParsedPassage parsePassageText(String text) {
  final t = text.replaceAll(RegExp(r'\r\n?'), '\n');
  final lines = t.split('\n');
  if (lines.any(_labelLine.hasMatch)) {
    final paragraphs = <String>[];
    final labels = <String>[];
    var body = <String>[];
    String? label;
    void flush() {
      final p = _squash(body.join(' '));
      if (p.isNotEmpty) {
        paragraphs.add(p);
        labels.add(label ?? '');
      }
      body = [];
    }

    for (final line in lines) {
      final m = _labelLine.firstMatch(line);
      if (m != null) {
        flush();
        label = m.group(1)!.toUpperCase();
      } else {
        body.add(line);
      }
    }
    flush();
    return ParsedPassage(paragraphs, labels);
  }
  final chunks = RegExp(r'\n\s*\n').hasMatch(t) ? t.split(RegExp(r'\n\s*\n')) : lines;
  return ParsedPassage(chunks.map(_squash).where((s) => s.isNotEmpty).toList());
}

List<String> _paragraphKeys(ParsedPassage p) {
  final labelled = (p.labels ?? const <String>[]).where((l) => l.isNotEmpty).toList();
  return labelled.isNotEmpty ? labelled : [for (var i = 0; i < p.paragraphs.length && i < _letters.length; i++) _letters[i]];
}

/// The lettered choices students pick from for a matching [type] in this passage:
/// the paragraph letters, the admin's answer list, or — for an exam authored
/// before the Studio captured a list — bare letters A…(highest used in [answers]).
List<Map<String, String>>? _matchingOptions(String type, Map<String, dynamic> passage, ParsedPassage parsed, List<String> answers) {
  if (_paragraphOptionTypes.contains(type)) {
    return [for (final k in _paragraphKeys(parsed)) {'key': k, 'text': 'Paragraph $k'}];
  }
  if (!_authoredOptionTypes.contains(type)) return null;
  final raw = (passage['options'] as List?) ?? const [];
  final authored = [
    for (var i = 0; i < raw.length && i < _letters.length; i++)
      if ('${raw[i]}'.trim().isNotEmpty) {'key': _letters[i], 'text': '${raw[i]}'.trim()},
  ];
  if (authored.isNotEmpty) return authored;
  final highest = answers.map((a) => _letters.indexOf(a.trim().toUpperCase())).fold(-1, max);
  return [for (var i = 0; i < max(highest + 1, 4); i++) {'key': _letters[i], 'text': ''}];
}

/// How a studio question is answered on mobile. With [matching] (reading, where
/// the passage supplies the lettered list) matching types keep their type;
/// otherwise anything without its own choices becomes a typed answer.
String _renderKind(String type, {required bool matching}) => switch (type) {
      'true-false-notgiven' || 'yes-no-notgiven' => type,
      'multiple-choice' || 'multi-select' => 'multiple-choice',
      _ when _wordLimitTypes.contains(type) => type,
      _ when matching && (_authoredOptionTypes.contains(type) || _paragraphOptionTypes.contains(type)) => type,
      _ => 'short-answer',
    };

String _instructions(String kind) => switch (kind) {
      'true-false-notgiven' => 'Do the following statements agree with the information in the passage? Choose True, False or Not Given.',
      'yes-no-notgiven' => "Do the following statements agree with the writer's views? Choose Yes, No or Not Given.",
      'multiple-choice' => 'Choose the correct letter for each question.',
      'short-answer' => 'Answer the questions. Write no more than the stated number of words.',
      'matching-information' => 'Which paragraph contains the following information? Choose the correct letter. You may use any letter more than once.',
      'matching-headings' => 'Choose the correct heading for each paragraph from the list of headings.',
      'matching-features' => 'Match each statement with the correct option from the list. You may use any letter more than once.',
      'matching-sentence-endings' => 'Complete each sentence with the correct ending from the list.',
      _ => 'Complete each sentence. Write no more than the stated number of words.',
    };

/// Splits a passage/section's studio questions into runner groups — one per run
/// of consecutive same-type questions ("Questions 1–5", "Questions 6–9", …).
/// [counter] numbers questions continuously across the whole exam.
/// [optionsFor] supplies a matching group's lettered list (reading only).
List<Map<String, dynamic>> _studioGroups(
  String ownerId,
  String defaultType,
  List<Map<String, dynamic>> questions,
  List<int> counter, {
  List<Map<String, String>>? Function(String kind, List<String> answers)? optionsFor,
}) {
  final groups = <Map<String, dynamic>>[];
  String kindOf(Map<String, dynamic> q) => _renderKind((q['type'] as String?) ?? defaultType, matching: optionsFor != null);
  for (final q in questions) {
    final kind = kindOf(q);
    if (groups.isEmpty || groups.last['type'] != kind) {
      final shared = kind == 'true-false-notgiven'
          ? _tfng
          : kind == 'yes-no-notgiven'
              ? _ynng
              : optionsFor?.call(kind, [for (final x in questions) if (kindOf(x) == kind) '${x['answer'] ?? ''}']);
      groups.add({
        'id': '$ownerId-g${groups.length + 1}',
        'type': kind,
        'instructions': _instructions(kind),
        'sharedOptions': ?shared,
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
      if (limit != null && limit > 0 && _wordLimitTypes.contains(kind)) 'wordLimit': 'Max $limit word${limit == 1 ? '' : 's'}',
      if (kind == 'multiple-choice')
        'options': [
          for (var i = 0; i < options.length && i < _letters.length; i++)
            {'key': _letters[i], 'text': '${options[i]}'.isEmpty ? 'Option ${_letters[i]}' : '${options[i]}'},
        ],
    });
  }
  for (final g in groups) {
    final qs = g['questions'] as List;
    final first = (qs.first as Map)['number'];
    final last = (qs.last as Map)['number'];
    g['rangeLabel'] = first == last ? 'Question $first' : 'Questions $first–$last';
  }
  return groups;
}

Map<String, dynamic> _studioReading(ExamDto e) {
  final passages = _maps(e.content['passages']);
  final counter = [1];
  final out = <Map<String, dynamic>>[];
  for (var i = 0; i < passages.length; i++) {
    final p = passages[i];
    final text = (p['text'] as String?) ?? '';
    final parsed = parsePassageText(text.trim().isEmpty ? 'This passage was authored in the Content Studio.' : text);
    final groups = _studioGroups('${p['id']}', (p['questionType'] as String?) ?? 'short-answer', _maps(p['questions']), counter,
        optionsFor: (kind, answers) => _matchingOptions(kind, p, parsed, answers));
    // Unlabelled passages get A, B, C… when a question asks "which paragraph".
    final asksParagraph = groups.any((g) => _paragraphOptionTypes.contains(g['type']));
    out.add({
      'id': p['id'],
      'headline': ((p['title'] as String?) ?? '').isEmpty ? 'Passage ${i + 1}' : p['title'],
      'label': e.module == 'general' ? 'General Training' : 'Academic',
      'passageNumber': i + 1,
      'totalPassages': passages.length,
      'paragraphs': parsed.paragraphs,
      if (parsed.labels != null || asksParagraph) 'paragraphLabels': parsed.labels ?? _paragraphKeys(parsed),
      'groups': groups,
    });
  }
  return {
    'id': e.id,
    'title': e.title,
    'durationSec': (e.timeLimit > 0 ? e.timeLimit : 60) * 60,
    'questionTypes': {for (final p in out) for (final g in p['groups'] as List) (g as Map)['type']}.toList(),
    'passages': out,
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
      paragraphLabels: (p['paragraphLabels'] as List?)?.map((e) => '$e').toList(),
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
