import '../models/models.dart';

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
