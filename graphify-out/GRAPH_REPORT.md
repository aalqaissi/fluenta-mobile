# Graph Report - lib  (2026-09-27)

## Corpus Check
- 58 files · ~36,336 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1150 nodes · 1718 edges · 60 communities (58 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `acca9344`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models.dart
- exam_convert.dart
- api_client.dart
- router.dart
- answer_match.dart
- modals.dart
- live_interview_screen.dart
- onboarding_screen.dart
- reading_runner_screen.dart
- overview_screen.dart
- mock_api.dart
- ui.dart
- app_colors.dart
- listening_runner_screen.dart
- section_audio_player.dart
- speaking_screen.dart
- writing_convert.dart
- data.dart
- ../../widgets/ui.dart
- reading_hub_screen.dart
- app_state.dart
- auth_state.dart
- app_config.dart
- State
- AuthState
- login_screen.dart
- coach_screen.dart
- question_group_view.dart
- writing_editor_screen.dart
- AppState
- track_switcher.dart
- brand.dart
- StatelessWidget
- Route /
- achievements_screen.dart
- feedback_list_screen.dart
- mock_exams_screen.dart
- writing_hub_screen.dart
- grading_overlay.dart
- certificates_screen.dart
- full_exam_screen.dart
- listening_loader_screen.dart
- ../services/api_client.dart
- ../models/models.dart
- full_exam_results_screen.dart
- build
- lessons_screen.dart
- practice_hub_screen.dart
- progress_screen.dart
- visual_prompt.dart
- package:flutter/material.dart
- app_theme.dart
- checkout_screen.dart
- package:provider/provider.dart
- package:go_router/go_router.dart
- _submit
- CustomPainter
- QuestionType
- build
- SkillKey

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 76 edges
2. `AppState` - 37 edges
3. `build` - 10 edges
4. `build` - 6 edges
5. `_FullExamResultsScreenState` - 5 edges
6. `_OverviewScreenState` - 5 edges
7. `_SpeakingScreenState` - 5 edges
8. `_WritingHubScreenState` - 5 edges
9. `_AchievementsScreenState` - 4 edges
10. `_LoginScreenState` - 4 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `AuthState`  [EXTRACTED]
  lib/features/achievements/achievements_screen.dart → lib/state/auth_state.dart
- `build` --references--> `AuthState`  [EXTRACTED]
  lib/features/achievements/achievements_screen.dart → lib/state/auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  lib/features/auth/login_screen.dart → lib/state/auth_state.dart
- `_signIn` --references--> `AuthState`  [EXTRACTED]
  lib/features/auth/login_screen.dart → lib/state/auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  lib/features/certificates/certificates_screen.dart → lib/state/auth_state.dart

## Import Cycles
- None detected.

## Communities (60 total, 2 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (168): double?, int?, int points,, accepted, Achievement, AchievementDto, active, ActivityItem (+160 more)

### Community 1 - "exam_convert.dart"
Cohesion: 0.04
Nodes (52): authored, _authoredOptionTypes, chunks, counter, _group, groups, highest, _instructions (+44 more)

### Community 2 - "api_client.dart"
Cohesion: 0.05
Nodes (41): Client, ../config/app_config.dart, dart:convert, dart:io, Exception, app, auth, build (+33 more)

### Community 3 - "router.dart"
Cohesion: 0.06
Nodes (36): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+28 more)

### Community 4 - "answer_match.dart"
Cohesion: 0.06
Nodes (33): Object?, accepted, after, answer, AnswerKey, answerMatches, any, before (+25 more)

### Community 5 - "modals.dart"
Cohesion: 0.06
Nodes (32): DateTime get, required String message,
  String, return res ??, ui.dart, _band, build, _category, confirmLabel (+24 more)

### Community 6 - "live_interview_screen.dart"
Cohesion: 0.06
Nodes (31): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+23 more)

### Community 7 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 8 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 9 - "overview_screen.dart"
Cohesion: 0.07
Nodes (29): _activityRow, _band, build, color, createState, _future, _hero, _heroDivider (+21 more)

### Community 10 - "mock_api.dart"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 11 - "ui.dart"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 12 - "app_colors.dart"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, static bool get (+18 more)

### Community 13 - "listening_runner_screen.dart"
Cohesion: 0.07
Nodes (27): _answered, _answers, _bottomBar, createState, dispose, exam, examId, full (+19 more)

### Community 14 - "section_audio_player.dart"
Cohesion: 0.07
Nodes (26): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+18 more)

### Community 15 - "speaking_screen.dart"
Cohesion: 0.08
Nodes (25): _clips, createState, dispose, _elapsed, _examId, initState, _loadError, _loading (+17 more)

### Community 16 - "writing_convert.dart"
Cohesion: 0.08
Nodes (22): return, a, block, _chartVisual, _formalityKind, g, minWords, out (+14 more)

### Community 17 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 18 - "../../widgets/ui.dart"
Cohesion: 0.14
Nodes (17): config/brand.dart, ../exam/question_group_view.dart, ListeningResultsScreen, ReadingResultsScreen, _annotated, _CoachingCard, createState, _crit (+9 more)

### Community 19 - "reading_hub_screen.dart"
Cohesion: 0.11
Nodes (18): build, createState, _empty, _featured, _featuredCard, _future, icon, initState (+10 more)

### Community 20 - "app_state.dart"
Cohesion: 0.11
Nodes (17): auth_state.dart, bool get, FluentaUser? get, package:flutter/foundation.dart, PlanTier get, _auth, bind, clearExamDate (+9 more)

### Community 21 - "auth_state.dart"
Cohesion: 0.12
Nodes (16): BootStatus get, FluentaUser, ApiClient, api, BootStatus, bootstrap, config, _error (+8 more)

### Community 22 - "app_config.dart"
Cohesion: 0.12
Nodes (15): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+7 more)

### Community 23 - "State"
Cohesion: 0.17
Nodes (16): LoginScreen, _LoginScreenState, SectionAudioPlayer, _SectionAudioPlayerState, LiveInterviewScreen, _LiveInterviewScreenState, SpeakingScreen, _SpeakingScreenState (+8 more)

### Community 24 - "AuthState"
Cohesion: 0.20
Nodes (14): build, OfflineScreen, build, _busy, _c, createState, dispose, initState (+6 more)

### Community 25 - "login_screen.dart"
Cohesion: 0.13
Nodes (14): build, _busy, createState, dispose, _email, _fillDemo, initState, _name (+6 more)

### Community 26 - "coach_screen.dart"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 27 - "question_group_view.dart"
Cohesion: 0.13
Nodes (14): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+6 more)

### Community 28 - "writing_editor_screen.dart"
Cohesion: 0.13
Nodes (14): build, _controller, createState, dispose, initState, _submit, task, taskId (+6 more)

### Community 29 - "AppState"
Cohesion: 0.23
Nodes (12): ChangeNotifier, build, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState (+4 more)

### Community 30 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 31 - "brand.dart"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 32 - "StatelessWidget"
Cohesion: 0.17
Nodes (12): SplashScreen, _StepHeader, _TypingBubble, StatelessWidget, EmptyStateView, FluentaCard, GradientCard, LockPill (+4 more)

### Community 33 - "Route /"
Cohesion: 0.18
Nodes (12): build, build, build, build, build, build, Route /, Route /coach (+4 more)

### Community 34 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 35 - "feedback_list_screen.dart"
Cohesion: 0.20
Nodes (10): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+2 more)

### Community 36 - "mock_exams_screen.dart"
Cohesion: 0.20
Nodes (10): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+2 more)

### Community 37 - "writing_hub_screen.dart"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 38 - "grading_overlay.dart"
Cohesion: 0.20
Nodes (9): dart:async, Timer?, build, createState, dispose, initState, _pct, showGradingDialog (+1 more)

### Community 39 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 40 - "full_exam_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored, _scoredCard (+1 more)

### Community 41 - "listening_loader_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, listening_runner_screen.dart (+1 more)

### Community 42 - "../services/api_client.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart (+1 more)

### Community 43 - "../models/models.dart"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ../models/models.dart (+1 more)

### Community 44 - "full_exam_results_screen.dart"
Cohesion: 0.25
Nodes (8): createState, FullExamResultsScreen, _FullExamResultsScreenState, _generateCertificate, _issuing, _skillRow, full_exam_store.dart, Route /certificates

### Community 45 - "build"
Cohesion: 0.22
Nodes (9): build, _plan, Route /achievements, Route /checkout, Route /feedback, Route /help, Route /lessons, Route /settings (+1 more)

### Community 46 - "lessons_screen.dart"
Cohesion: 0.29
Nodes (7): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState, ../mock/data.dart

### Community 47 - "practice_hub_screen.dart"
Cohesion: 0.25
Nodes (7): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,

### Community 48 - "progress_screen.dart"
Cohesion: 0.29
Nodes (7): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard

### Community 49 - "visual_prompt.dart"
Cohesion: 0.25
Nodes (7): build, paint, _series, shouldRepaint, visual, VisualPrompt, String?

### Community 50 - "package:flutter/material.dart"
Cohesion: 0.33
Nodes (5): build, build, HelpScreen, package:flutter/material.dart, ../theme/app_colors.dart

### Community 51 - "app_theme.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 52 - "checkout_screen.dart"
Cohesion: 0.40
Nodes (5): build, CheckoutScreen, _CheckoutScreenState, createState, _selected

### Community 53 - "package:provider/provider.dart"
Cohesion: 0.33
Nodes (5): MoreScreen, _tile, package:provider/provider.dart, ../state/app_state.dart, ../tracks/track_switcher.dart

### Community 54 - "package:go_router/go_router.dart"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 55 - "_submit"
Cohesion: 0.40
Nodes (5): _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 56 - "CustomPainter"
Cohesion: 0.50
Nodes (4): CustomPainter, _SeriesChartPainter, _LineChartPainter, _RingPainter

### Community 57 - "QuestionType"
Cohesion: 0.67
Nodes (3): QuestionType, QuestionTypeLabel, QuestionTypeWire

## Knowledge Gaps
- **787 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+782 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `api_client.dart`, `modals.dart`, `live_interview_screen.dart`, `onboarding_screen.dart`, `reading_runner_screen.dart`, `overview_screen.dart`, `listening_runner_screen.dart`, `speaking_screen.dart`, `reading_hub_screen.dart`, `app_state.dart`, `auth_state.dart`, `State`, `login_screen.dart`, `coach_screen.dart`, `writing_editor_screen.dart`, `AppState`, `track_switcher.dart`, `achievements_screen.dart`, `feedback_list_screen.dart`, `writing_hub_screen.dart`, `certificates_screen.dart`, `listening_loader_screen.dart`, `../services/api_client.dart`, `full_exam_results_screen.dart`, `build`, `package:provider/provider.dart`, `_submit`?**
  _High betweenness centrality (0.109) - this node is a cross-community bridge._
- **Why does `AppState` connect `AppState` to `api_client.dart`, `writing_hub_screen.dart`, `modals.dart`, `full_exam_screen.dart`, `overview_screen.dart`, `full_exam_results_screen.dart`, `build`, `practice_hub_screen.dart`, `speaking_screen.dart`, `app_state.dart`, `package:provider/provider.dart`, `State`, `AuthState`, `build`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Why does `build` connect `build` to `AuthState`, `AppState`, `full_exam_results_screen.dart`, `package:provider/provider.dart`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _787 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.011834319526627219 - nodes in this community are weakly interconnected._
- **Should `exam_convert.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03773584905660377 - nodes in this community are weakly interconnected._
- **Should `api_client.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._