// Domain models for the Fluenta mobile prototype (mirror the web TS types).

enum SkillKey { reading, writing, listening, speaking, vocabulary, grammar }

extension SkillLabel on SkillKey {
  String get label => switch (this) {
        SkillKey.reading => 'Reading',
        SkillKey.writing => 'Writing',
        SkillKey.listening => 'Listening',
        SkillKey.speaking => 'Speaking',
        SkillKey.vocabulary => 'Vocabulary',
        SkillKey.grammar => 'Grammar',
      };
  String get key => name;
}

/// Vocabulary & Grammar are dashboard-tracked but their practice runners are
/// "coming soon" (parity with the web app's COMING_SOON_SKILLS).
const Set<String> comingSoonSkills = {'vocabulary', 'grammar'};

enum PlanTier { free, pro }

enum ExamStatus { notStarted, inProgress, completed }

enum QuestionType {
  trueFalseNotGiven,
  yesNoNotGiven,
  multipleChoice,
  matchingInformation,
  matchingHeadings,
  matchingFeatures,
  matchingSentenceEndings,
  sentenceCompletion,
  summaryCompletion,
  diagramLabel,
  shortAnswer,
}

extension QuestionTypeLabel on QuestionType {
  String get label => switch (this) {
        QuestionType.trueFalseNotGiven => 'True / False / Not Given',
        QuestionType.yesNoNotGiven => 'Yes / No / Not Given',
        QuestionType.multipleChoice => 'Multiple Choice',
        QuestionType.matchingInformation => 'Matching Information',
        QuestionType.matchingHeadings => 'Matching Headings',
        QuestionType.matchingFeatures => 'Matching Features',
        QuestionType.matchingSentenceEndings => 'Matching Sentence Endings',
        QuestionType.sentenceCompletion => 'Sentence Completion',
        QuestionType.summaryCompletion => 'Summary Completion',
        QuestionType.diagramLabel => 'Diagram Label Completion',
        QuestionType.shortAnswer => 'Short Answer',
      };
}

/// Parse the backend's kebab-case type string (e.g. "true-false-notgiven").
QuestionType questionTypeFromKey(String? key) {
  switch (key) {
    case 'true-false-notgiven':
      return QuestionType.trueFalseNotGiven;
    case 'yes-no-notgiven':
      return QuestionType.yesNoNotGiven;
    case 'multiple-choice':
    case 'multi-select':
      return QuestionType.multipleChoice;
    case 'matching-information':
      return QuestionType.matchingInformation;
    case 'matching-headings':
      return QuestionType.matchingHeadings;
    case 'matching-features':
      return QuestionType.matchingFeatures;
    case 'matching-sentence-endings':
      return QuestionType.matchingSentenceEndings;
    case 'sentence-completion':
      return QuestionType.sentenceCompletion;
    case 'summary-completion':
      return QuestionType.summaryCompletion;
    case 'diagram-label':
      return QuestionType.diagramLabel;
    case 'short-answer':
      return QuestionType.shortAnswer;
    default:
      return QuestionType.sentenceCompletion;
  }
}

class Streak {
  final int current;
  final int best;
  final List<int> last30; // intensity 0..3
  const Streak({required this.current, required this.best, required this.last30});

  factory Streak.fromJson(Map<String, dynamic> json) => Streak(
        current: (json['current'] as num?)?.toInt() ?? 0,
        best: (json['best'] as num?)?.toInt() ?? 0,
        last30: (json['last30'] as List?)
                ?.map((e) => (e as num).toInt())
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() =>
      {'current': current, 'best': best, 'last30': last30};
}

class FluentaUser {
  final String id;
  final String name;
  final String email;
  final String initials;
  final String avatarUrl;
  final PlanTier plan;
  final String planLabel;
  final int renewsInDays;
  final double targetBand;
  final DateTime? examDate;
  final bool saveHistory;
  final String? track;
  final String? examType;
  final String? purpose;
  final String? level;
  final bool onboarded;
  final Streak streak;
  final String role;

  const FluentaUser({
    this.id = '',
    required this.name,
    required this.email,
    required this.initials,
    this.avatarUrl = '',
    required this.plan,
    required this.planLabel,
    required this.renewsInDays,
    required this.targetBand,
    required this.examDate,
    required this.saveHistory,
    this.track,
    this.examType,
    this.purpose,
    this.level,
    this.onboarded = false,
    required this.streak,
    this.role = 'student',
  });

  factory FluentaUser.fromJson(Map<String, dynamic> json) {
    final examDateRaw = json['examDate'];
    final initialsRaw = json['initials'] as String?;
    return FluentaUser(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      initials: (initialsRaw != null && initialsRaw.isNotEmpty)
          ? initialsRaw
          : _initialsFrom((json['name'] as String?) ?? ''),
      avatarUrl: (json['avatarUrl'] as String?) ?? '',
      plan: _planFrom(json['plan'] as String?),
      planLabel: (json['planLabel'] as String?) ?? 'Free',
      renewsInDays: (json['renewsInDays'] as num?)?.toInt() ?? 0,
      targetBand: (json['targetBand'] as num?)?.toDouble() ?? 6.5,
      examDate: (examDateRaw is String && examDateRaw.isNotEmpty)
          ? DateTime.tryParse(examDateRaw)
          : null,
      saveHistory: (json['saveHistory'] as bool?) ?? true,
      track: json['track'] as String?,
      examType: json['examType'] as String?,
      purpose: json['purpose'] as String?,
      level: json['level'] as String?,
      onboarded: (json['onboarded'] as bool?) ?? false,
      streak: json['streak'] is Map
          ? Streak.fromJson(Map<String, dynamic>.from(json['streak'] as Map))
          : const Streak(current: 0, best: 0, last30: []),
      role: (json['role'] as String?) ?? 'student',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'initials': initials,
        'avatarUrl': avatarUrl,
        'plan': plan.name,
        'planLabel': planLabel,
        'renewsInDays': renewsInDays,
        'targetBand': targetBand,
        'examDate': examDate?.toIso8601String().split('T').first,
        'saveHistory': saveHistory,
        'track': track,
        'examType': examType,
        'purpose': purpose,
        'level': level,
        'onboarded': onboarded,
        'streak': streak.toJson(),
      };

  FluentaUser copyWith({
    String? name,
    double? targetBand,
    DateTime? examDate,
    bool clearExamDate = false,
    bool? saveHistory,
    String? track,
    String? examType,
    String? purpose,
    String? level,
    bool? onboarded,
    String? role,
  }) {
    return FluentaUser(
      id: id,
      name: name ?? this.name,
      email: email,
      initials: initials,
      avatarUrl: avatarUrl,
      plan: plan,
      planLabel: planLabel,
      renewsInDays: renewsInDays,
      targetBand: targetBand ?? this.targetBand,
      examDate: clearExamDate ? null : (examDate ?? this.examDate),
      saveHistory: saveHistory ?? this.saveHistory,
      track: track ?? this.track,
      examType: examType ?? this.examType,
      purpose: purpose ?? this.purpose,
      level: level ?? this.level,
      onboarded: onboarded ?? this.onboarded,
      streak: streak,
      role: role ?? this.role,
    );
  }

  static PlanTier _planFrom(String? s) =>
      s == 'pro' ? PlanTier.pro : PlanTier.free;

  static String _initialsFrom(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class SectionSummary {
  final SkillKey skill;
  final double? band;
  final int tests;
  const SectionSummary({required this.skill, required this.band, required this.tests});
}

// ---- Overview / analytics (mirrors backend OverviewDto) ----
class SkillStat {
  final String key;
  final String label;
  final double? band;
  final int tests;
  const SkillStat({required this.key, required this.label, this.band, required this.tests});
  factory SkillStat.fromJson(Map<String, dynamic> j) => SkillStat(
        key: j['key'] as String,
        label: j['label'] as String,
        band: (j['band'] as num?)?.toDouble(),
        tests: (j['tests'] as num?)?.toInt() ?? 0,
      );
}

class SkillPoint {
  final String key;
  final String label;
  final double band;
  const SkillPoint({required this.key, required this.label, required this.band});
  factory SkillPoint.fromJson(Map<String, dynamic> j) => SkillPoint(
        key: j['key'] as String,
        label: j['label'] as String,
        band: (j['band'] as num).toDouble(),
      );
}

class SeriesPoint {
  final String date;
  final double band;
  const SeriesPoint({required this.date, required this.band});
  factory SeriesPoint.fromJson(Map<String, dynamic> j) => SeriesPoint(
        date: j['date'] as String,
        band: (j['band'] as num).toDouble(),
      );
}

class ActivityItem {
  final String id;
  final String type; // completed | submitted | feedback | unfinished
  final String skill;
  final String title;
  final String date;
  final double? band;
  const ActivityItem({
    required this.id,
    required this.type,
    required this.skill,
    required this.title,
    required this.date,
    this.band,
  });
  factory ActivityItem.fromJson(Map<String, dynamic> j) => ActivityItem(
        id: j['id'] as String,
        type: j['type'] as String,
        skill: (j['skill'] as String?) ?? '',
        title: j['title'] as String,
        date: (j['date'] as String?) ?? '',
        band: (j['band'] as num?)?.toDouble(),
      );
}

class Overview {
  final double targetBand;
  final double currentAverage;
  final double gapToTarget;
  final int testsCompleted;
  final List<SkillStat> skills;
  final SkillPoint? strongest;
  final SkillPoint? weakest;
  final Map<String, List<SeriesPoint>> series;
  final List<ActivityItem> recentActivity;
  const Overview({
    required this.targetBand,
    required this.currentAverage,
    required this.gapToTarget,
    required this.testsCompleted,
    required this.skills,
    required this.strongest,
    required this.weakest,
    required this.series,
    required this.recentActivity,
  });

  factory Overview.fromJson(Map<String, dynamic> j) {
    final rawSeries = (j['series'] as Map?) ?? const {};
    return Overview(
      targetBand: (j['targetBand'] as num?)?.toDouble() ?? 0,
      currentAverage: (j['currentAverage'] as num?)?.toDouble() ?? 0,
      gapToTarget: (j['gapToTarget'] as num?)?.toDouble() ?? 0,
      testsCompleted: (j['testsCompleted'] as num?)?.toInt() ?? 0,
      skills: ((j['skills'] as List?) ?? [])
          .map((e) => SkillStat.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      strongest: j['strongest'] is Map
          ? SkillPoint.fromJson(Map<String, dynamic>.from(j['strongest'] as Map))
          : null,
      weakest: j['weakest'] is Map
          ? SkillPoint.fromJson(Map<String, dynamic>.from(j['weakest'] as Map))
          : null,
      series: {
        for (final entry in rawSeries.entries)
          entry.key as String: ((entry.value as List?) ?? [])
              .map((e) => SeriesPoint.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
      },
      recentActivity: ((j['recentActivity'] as List?) ?? [])
          .map((e) => ActivityItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

// ---- Exams & attempts (mirror backend ExamDto / AttemptDto) ----
class ExamDto {
  final String id;
  final String skill;
  final String title;
  final String module;
  final String status;
  final String scope;
  final int timeLimit;
  final String format; // "studio" | "runner"
  final Map<String, dynamic> content;
  const ExamDto({
    required this.id,
    required this.skill,
    required this.title,
    required this.module,
    required this.status,
    required this.scope,
    required this.timeLimit,
    required this.format,
    required this.content,
  });
  factory ExamDto.fromJson(Map<String, dynamic> j) => ExamDto(
        id: j['id'] as String,
        skill: (j['skill'] as String?) ?? '',
        title: (j['title'] as String?) ?? '',
        module: (j['module'] as String?) ?? 'both',
        status: (j['status'] as String?) ?? 'published',
        scope: (j['scope'] as String?) ?? 'global',
        timeLimit: (j['timeLimit'] as num?)?.toInt() ?? 0,
        format: (j['format'] as String?) ?? 'runner',
        content: j['content'] is Map
            ? Map<String, dynamic>.from(j['content'] as Map)
            : <String, dynamic>{},
      );
}

class AttemptRequest {
  final String examId;
  final String skill;
  final Map<String, String> answers;
  final int durationUsedSec;
  const AttemptRequest({
    required this.examId,
    required this.skill,
    required this.answers,
    required this.durationUsedSec,
  });
  Map<String, dynamic> toJson() => {
        'examId': examId,
        'skill': skill,
        'answers': answers,
        'durationUsedSec': durationUsedSec,
      };
}

class AttemptDto {
  final String id;
  final String examId;
  final String examTitle;
  final String skill;
  final Map<String, String> answers;
  final int correct;
  final int total;
  final double band;
  final int durationUsedSec;
  final String createdAt;
  const AttemptDto({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.skill,
    required this.answers,
    required this.correct,
    required this.total,
    required this.band,
    required this.durationUsedSec,
    required this.createdAt,
  });
  factory AttemptDto.fromJson(Map<String, dynamic> j) => AttemptDto(
        id: (j['id'] as String?) ?? '',
        examId: (j['examId'] as String?) ?? '',
        examTitle: (j['examTitle'] as String?) ?? '',
        skill: (j['skill'] as String?) ?? '',
        answers: ((j['answers'] as Map?) ?? {})
            .map((k, v) => MapEntry(k as String, '${v ?? ''}')),
        correct: (j['correct'] as num?)?.toInt() ?? 0,
        total: (j['total'] as num?)?.toInt() ?? 0,
        band: (j['band'] as num?)?.toDouble() ?? 0,
        durationUsedSec: (j['durationUsedSec'] as num?)?.toInt() ?? 0,
        createdAt: (j['createdAt'] as String?) ?? '',
      );
}

// ---- Achievements / Certificates / Tracks / Feedback (backend DTOs) ----
class AchievementDto {
  final String id, title, description, category, tier, icon, status;
  final int points, progress;
  final String? unlockedOn;
  const AchievementDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.tier,
    required this.icon,
    required this.status,
    required this.points,
    required this.progress,
    this.unlockedOn,
  });
  bool get unlocked => status == 'unlocked';
  factory AchievementDto.fromJson(Map<String, dynamic> j) => AchievementDto(
        id: (j['id'] as String?) ?? '',
        title: (j['title'] as String?) ?? '',
        description: (j['description'] as String?) ?? '',
        category: (j['category'] as String?) ?? 'general',
        tier: (j['tier'] as String?) ?? 'bronze',
        icon: (j['icon'] as String?) ?? '',
        status: (j['status'] as String?) ?? 'locked',
        points: (j['points'] as num?)?.toInt() ?? 0,
        progress: (j['progress'] as num?)?.toInt() ?? 0,
        unlockedOn: j['unlockedOn'] as String?,
      );
}

class CertificateDto {
  final String id, title, candidate, type, verificationNumber, module, issuedOn, cefr, status;
  final double overall;
  final Map<String, double> scores;
  const CertificateDto({
    required this.id,
    required this.title,
    required this.candidate,
    required this.type,
    required this.verificationNumber,
    required this.module,
    required this.issuedOn,
    required this.cefr,
    required this.status,
    required this.overall,
    required this.scores,
  });
  factory CertificateDto.fromJson(Map<String, dynamic> j) => CertificateDto(
        id: (j['id'] as String?) ?? '',
        title: (j['title'] as String?) ?? '',
        candidate: (j['candidate'] as String?) ?? '',
        type: (j['type'] as String?) ?? 'standard',
        verificationNumber: (j['verificationNumber'] as String?) ?? '',
        module: (j['module'] as String?) ?? 'academic',
        issuedOn: (j['issuedOn'] as String?) ?? '',
        cefr: (j['cefr'] as String?) ?? '',
        status: (j['status'] as String?) ?? 'issued',
        overall: (j['overall'] as num?)?.toDouble() ?? 0,
        scores: ((j['scores'] as Map?) ?? {})
            .map((k, v) => MapEntry(k as String, (v as num?)?.toDouble() ?? 0)),
      );
}

class Track {
  final String key, name, short, status, icon, description;
  const Track({
    required this.key,
    required this.name,
    required this.short,
    required this.status,
    required this.icon,
    required this.description,
  });
  bool get active => status == 'active';
  factory Track.fromJson(Map<String, dynamic> j) => Track(
        key: (j['key'] as String?) ?? '',
        name: (j['name'] as String?) ?? '',
        short: (j['short'] as String?) ?? '',
        status: (j['status'] as String?) ?? 'coming-soon',
        icon: (j['icon'] as String?) ?? '',
        description: (j['description'] as String?) ?? '',
      );
}

class FeedbackDto {
  final String id, category, subject, message, status, createdAt;
  final int? rating;
  final String? adminReply;
  const FeedbackDto({
    required this.id,
    required this.category,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
    this.rating,
    this.adminReply,
  });
  factory FeedbackDto.fromJson(Map<String, dynamic> j) => FeedbackDto(
        id: (j['id'] as String?) ?? '',
        category: (j['category'] as String?) ?? 'general',
        subject: (j['subject'] as String?) ?? '',
        message: (j['message'] as String?) ?? '',
        status: (j['status'] as String?) ?? 'new',
        createdAt: (j['createdAt'] as String?) ?? '',
        rating: (j['rating'] as num?)?.toInt(),
        adminReply: j['adminReply'] as String?,
      );
}

class CreateFeedback {
  final String category, subject, message;
  final int? rating;
  const CreateFeedback({
    required this.category,
    required this.subject,
    required this.message,
    this.rating,
  });
  Map<String, dynamic> toJson() => {
        'category': category,
        'subject': subject,
        'message': message,
        'rating': rating,
      };
}

class QuestionOption {
  final String key;
  final String text;
  const QuestionOption(this.key, this.text);
}

class Question {
  final String id;
  final int number;
  final String prompt;
  final String correct;
  final String? wordLimit;
  final List<QuestionOption>? options; // for multiple choice (per-question)
  const Question({
    required this.id,
    required this.number,
    required this.prompt,
    required this.correct,
    this.wordLimit,
    this.options,
  });
}

class QuestionGroup {
  final String id;
  final QuestionType type;
  final String rangeLabel;
  final String instructions;
  final List<QuestionOption>? sharedOptions;
  final List<Question> questions;
  const QuestionGroup({
    required this.id,
    required this.type,
    required this.rangeLabel,
    required this.instructions,
    this.sharedOptions,
    required this.questions,
  });
}

class Passage {
  final String id;
  final String headline;
  final String label;
  final int passageNumber;
  final int totalPassages;
  final List<String> paragraphs;
  /// IELTS paragraph letters ("A", "B", …) aligned with [paragraphs], when labelled.
  final List<String>? paragraphLabels;
  final List<QuestionGroup> groups;
  const Passage({
    required this.id,
    required this.headline,
    required this.label,
    required this.passageNumber,
    required this.totalPassages,
    required this.paragraphs,
    this.paragraphLabels,
    required this.groups,
  });
}

class ReadingExam {
  final String id;
  final String title;
  final List<Passage> passages;
  final int durationSec;
  final List<QuestionType> questionTypes;
  const ReadingExam({
    required this.id,
    required this.title,
    required this.passages,
    required this.durationSec,
    required this.questionTypes,
  });
}

// ---- Writing ----
class WritingTask {
  final String id;
  final int taskNumber;
  final String kind;
  final String prompt;
  final int minWords;
  final int durationSec;
  final String? visual;         // bar|line|pie|process|map|table (Academic T1); null otherwise
  final List<String>? bullets;  // GT letter points (samples only); null otherwise
  final String? module;         // academic|general|both (metadata; not filtered)
  const WritingTask({
    required this.id,
    required this.taskNumber,
    required this.kind,
    required this.prompt,
    required this.minWords,
    required this.durationSec,
    this.visual,
    this.bullets,
    this.module,
  });
}

enum WritingCriterionKey { task, coherence, lexical, grammar }

WritingCriterionKey writingCriterionKeyFromString(String? s) {
  switch (s) {
    case 'coherence':
      return WritingCriterionKey.coherence;
    case 'lexical':
      return WritingCriterionKey.lexical;
    case 'grammar':
      return WritingCriterionKey.grammar;
    default:
      return WritingCriterionKey.task;
  }
}

class WritingCriterion {
  final WritingCriterionKey key;
  final String label;
  final double band;
  final String summary;
  const WritingCriterion(this.key, this.label, this.band, this.summary);
}

class WritingAnnotation {
  final WritingCriterionKey criterion;
  final String quote;
  final String note;
  const WritingAnnotation(this.criterion, this.quote, this.note);
}

class WritingResult {
  final double overall;
  final int wordCount;
  final String answer;
  final List<WritingCriterion> criteria;
  final List<WritingAnnotation> annotations;
  const WritingResult({
    required this.overall,
    required this.wordCount,
    required this.answer,
    required this.criteria,
    required this.annotations,
  });

  factory WritingResult.fromJson(Map<String, dynamic> j) => WritingResult(
        overall: (j['overall'] as num?)?.toDouble() ?? 0,
        wordCount: (j['wordCount'] as num?)?.toInt() ?? 0,
        answer: (j['answer'] as String?) ?? '',
        criteria: ((j['criteria'] as List?) ?? const [])
            .map((c) => WritingCriterion(
                  writingCriterionKeyFromString(c['key'] as String?),
                  (c['label'] as String?) ?? '',
                  (c['band'] as num?)?.toDouble() ?? 0,
                  (c['summary'] as String?) ?? '',
                ))
            .toList(),
        annotations: ((j['annotations'] as List?) ?? const [])
            .map((a) => WritingAnnotation(
                  writingCriterionKeyFromString(a['criterion'] as String?),
                  (a['quote'] as String?) ?? '',
                  (a['note'] as String?) ?? '',
                ))
            .toList(),
      );
}

// ---- Listening / Speaking ----
class ListeningSection {
  final int number;
  final String context;
  final int questionCount;
  const ListeningSection({required this.number, required this.context, required this.questionCount});
}

/// Runtime listening exam (from a backend runner-format exam): 4 sections, each
/// with a single question group. Objectively scored like reading.
class ListeningRunSection {
  final int number;
  final String context;
  final int audioDurationSec;
  final String? audioUrl;
  final QuestionGroup group;
  const ListeningRunSection({
    required this.number,
    required this.context,
    required this.audioDurationSec,
    this.audioUrl,
    required this.group,
  });
}

class ListeningRunExam {
  final String id;
  final String title;
  final int durationSec;
  final List<ListeningRunSection> sections;
  const ListeningRunExam({
    required this.id,
    required this.title,
    required this.durationSec,
    required this.sections,
  });
}

class SpeakingPart {
  final int number;
  final String title;
  final String? cueCard;
  final List<String>? bullets;
  final List<String> questions;
  const SpeakingPart({
    required this.number,
    required this.title,
    this.cueCard,
    this.bullets,
    required this.questions,
  });
}

class SpeakingFeedback {
  final String label;
  final double band;
  final String note;
  const SpeakingFeedback(this.label, this.band, this.note);
}

class SpeakingCriterion {
  final String key;
  final String label;
  final double band;
  final String note;
  SpeakingCriterion({required this.key, required this.label, required this.band, required this.note});
  factory SpeakingCriterion.fromJson(Map<String, dynamic> j) => SpeakingCriterion(
        key: j['key'] as String? ?? '',
        label: j['label'] as String? ?? '',
        band: (j['band'] as num?)?.toDouble() ?? 0,
        note: j['note'] as String? ?? '',
      );
}

class SpeakingResult {
  final String id;
  final String source;
  final double overall;
  final List<SpeakingCriterion> criteria;
  SpeakingResult({required this.id, required this.source, required this.overall, required this.criteria});
  factory SpeakingResult.fromJson(Map<String, dynamic> j) => SpeakingResult(
        id: j['id'] as String? ?? '',
        source: j['source'] as String? ?? '',
        overall: (j['overall'] as num?)?.toDouble() ?? 0,
        criteria: ((j['criteria'] as List?) ?? const [])
            .map((e) => SpeakingCriterion.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class InterviewTurn {
  final String role; // "examiner" | "candidate"
  final String text;
  const InterviewTurn({required this.role, required this.text});
  Map<String, dynamic> toJson() => {'role': role, 'text': text};
}

class LiveInterviewReply {
  final String transcript;
  final String reply;
  final int part;
  final bool done;
  LiveInterviewReply({required this.transcript, required this.reply, required this.part, required this.done});
  factory LiveInterviewReply.fromJson(Map<String, dynamic> j) => LiveInterviewReply(
        transcript: j['transcript'] as String? ?? '',
        reply: j['reply'] as String? ?? '',
        part: (j['part'] as num?)?.toInt() ?? 1,
        done: j['done'] as bool? ?? false,
      );
}

// ---- Plans / coach / lessons / achievements / certificates ----
class Plan {
  final String id;
  final String name;
  final String? badge;
  final String price;
  final String cadence;
  final String detail;
  final bool highlight;
  const Plan({
    required this.id,
    required this.name,
    this.badge,
    required this.price,
    required this.cadence,
    required this.detail,
    this.highlight = false,
  });
}

class CoachMessage {
  final String role; // 'user' | 'coach'
  final String text;
  const CoachMessage(this.role, this.text);
}

class Lesson {
  final String title;
  final String skill; // reading/writing/listening/speaking/general
  final String level;
  final int minutes;
  final String kind; // Video/Article/Drill
  final String summary;
  final int progress;
  const Lesson({
    required this.title,
    required this.skill,
    required this.level,
    required this.minutes,
    required this.kind,
    required this.summary,
    required this.progress,
  });
}

class Achievement {
  final String title;
  final String description;
  final bool earned;
  final int progress;
  final String? earnedOn;
  const Achievement({
    required this.title,
    required this.description,
    required this.earned,
    this.progress = 0,
    this.earnedOn,
  });
}

class Certificate {
  final String title;
  final double band;
  final String issuedOn;
  const Certificate({required this.title, required this.band, required this.issuedOn});
}

class RecentExam {
  final String id;
  final SkillKey skill;
  final String title;
  final ExamStatus status;
  final bool isMock;
  final String date;
  final int sectionsDone;
  final int sectionsTotal;
  final double? band;
  const RecentExam({
    required this.id,
    required this.skill,
    required this.title,
    required this.status,
    required this.isMock,
    required this.date,
    required this.sectionsDone,
    required this.sectionsTotal,
    this.band,
  });
}

class MockExamCard {
  final String id;
  final String title;
  final bool isGlobal;
  final int part;
  final QuestionType primaryType;
  final int attempts;
  final bool playable;
  const MockExamCard({
    required this.id,
    required this.title,
    required this.isGlobal,
    required this.part,
    required this.primaryType,
    required this.attempts,
    this.playable = false,
  });
}
