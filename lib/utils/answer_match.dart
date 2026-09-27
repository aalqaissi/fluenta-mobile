/// The single answer-key marking rule for objective (reading/listening) questions — the mobile
/// mirror of the backend `AnswerMatcher.java` (authoritative score) and web `answerMatch.ts`. All
/// three are pinned by the shared `answer-match-vectors.json` (copied to test/fixtures).
///
/// 1. Normalise case, quotes, whitespace and edge punctuation.
/// 2. For text (completion / short-answer) questions, an answer over the stated word/number limit
///    is wrong even if it contains the right words.
/// 3. The answer, or any accepted variant, matches — with `(parenthesised)` words optional.
library;

class AnswerKey {
  final String answer;
  final List<String> accepted;
  final Object? wordLimit; // int, label String, or null
  final String? type; // wire key, e.g. 'sentence-completion'
  const AnswerKey(this.answer, {this.accepted = const [], this.wordLimit, this.type});
}

/// Question types whose answers are typed words, so the word/number limit applies.
const textAnswerTypes = {
  'sentence-completion', 'summary-completion', 'note-completion', 'table-completion',
  'flow-chart-completion', 'form-completion', 'diagram-label', 'short-answer',
};

final _number = RegExp(r'^[£$€]?\d[\d,.:/]*(%|st|nd|rd|th|am|pm)?$');
final _count = RegExp(r'\b(\d+|ONE|TWO|THREE|FOUR|FIVE)\b');
final _optional = RegExp(r'\(([^)]*)\)');
const _edge = '.,;:!?"\'';
const _wordCounts = {'ONE': 1, 'TWO': 2, 'THREE': 3, 'FOUR': 4, 'FIVE': 5};

String normalizeAnswer(String? s) {
  if (s == null) return '';
  var out = s
      .toLowerCase()
      .replaceAll(RegExp('[‘’]'), "'")
      .replaceAll(RegExp('[“”]'), '"')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  var start = 0;
  var end = out.length;
  while (start < end && _edge.contains(out[start])) {
    start++;
  }
  while (end > start && _edge.contains(out[end - 1])) {
    end--;
  }
  return out.substring(start, end).trim();
}

bool _gated(String? type) => type == null || type.trim().isEmpty || textAnswerTypes.contains(type);

bool _withinLimit(String given, Object? limit) {
  if (limit == null || limit == '') return true;
  var words = 0;
  var numbers = 0;
  for (final t in given.split(' ')) {
    if (t.isEmpty) continue;
    if (_number.hasMatch(t)) {
      numbers++;
    } else {
      words++;
    }
  }
  if (limit is num) return limit <= 0 || words + numbers <= limit;
  final label = limit.toString().toUpperCase();
  final hasWord = label.contains('WORD');
  final hasNumber = label.contains('NUMBER');
  if (!hasWord && hasNumber) return words == 0 && numbers <= 1;
  final m = _count.firstMatch(label);
  if (!hasWord || m == null) return true;
  final max = _wordCounts[m.group(1)] ?? int.parse(m.group(1)!);
  if (hasNumber && label.contains('AND/OR')) return words <= max && numbers <= 1;
  return words + numbers <= max;
}

/// Expand `(optional)` words into every with/without combination, normalised.
List<String> _expand(String raw) {
  final m = _optional.firstMatch(raw);
  if (m == null) return [normalizeAnswer(raw)];
  final before = raw.substring(0, m.start);
  final after = raw.substring(m.end);
  return [
    for (final rest in _expand(after)) ...[
      normalizeAnswer('$before $rest'),
      normalizeAnswer('$before ${m.group(1)} $rest'),
    ],
  ];
}

bool answerMatches(String? given, AnswerKey key) {
  final g = normalizeAnswer(given);
  if (g.isEmpty) return false;
  if (_gated(key.type) && !_withinLimit(g, key.wordLimit)) return false;
  final candidates = [key.answer, ...key.accepted].expand(_expand);
  return candidates.any((c) => c.isNotEmpty && c == g);
}
