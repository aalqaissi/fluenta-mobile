# Graph Report - lib  (2026-09-27)

## Corpus Check
- 61 files · ~38,252 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1226 nodes · 1838 edges · 60 communities (57 shown, 3 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `438100c5`
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
- writing_results_screen.dart
- reading_hub_screen.dart
- app_state.dart
- auth_state.dart
- app_config.dart
- State
- settings_screen.dart
- login_screen.dart
- coach_screen.dart
- question_group_view.dart
- writing_editor_screen.dart
- dashboard_screen.dart
- track_switcher.dart
- runner_timer.dart
- StatelessWidget
- build
- achievements_screen.dart
- feedback_list_screen.dart
- mock_exams_screen.dart
- package:provider/provider.dart
- grading_overlay.dart
- certificates_screen.dart
- full_exam_screen.dart
- listening_loader_screen.dart
- reading_loader_screen.dart
- ../models/models.dart
- AuthState
- exam_mode.dart
- ../theme/app_colors.dart
- full_exam_store.dart
- progress_screen.dart
- String?
- mode_picker.dart
- app_theme.dart
- ../mock/data.dart
- ../services/api_client.dart
- package:flutter/material.dart
- Route /full-exam
- ApiException
- QuestionType
- build
- SkillKey

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 76 edges
2. `AppState` - 37 edges
3. `build` - 10 edges
4. `ExamMode` - 10 edges
5. `build` - 6 edges
6. `_FullExamResultsScreenState` - 5 edges
7. `_OverviewScreenState` - 5 edges
8. `_SpeakingScreenState` - 5 edges
9. `_WritingHubScreenState` - 5 edges
10. `RunnerTimer` - 5 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `AuthState`  [EXTRACTED]
  lib/features/achievements/achievements_screen.dart → lib/state/auth_state.dart
- `build` --references--> `AuthState`  [EXTRACTED]
  lib/features/achievements/achievements_screen.dart → lib/state/auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  lib/features/auth/login_screen.dart → lib/state/auth_state.dart
- `_signIn` --references--> `AuthState`  [EXTRACTED]
  lib/features/auth/login_screen.dart → lib/state/auth_state.dart
- `build` --references--> `AuthState`  [EXTRACTED]
  lib/features/bootstrap/offline_screen.dart → lib/state/auth_state.dart

## Import Cycles
- None detected.

## Communities (60 total, 3 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (167): double?, int points,, accepted, Achievement, AchievementDto, active, ActivityItem, adminReply (+159 more)

### Community 1 - "exam_convert.dart"
Cohesion: 0.04
Nodes (52): authored, _authoredOptionTypes, chunks, counter, _group, groups, highest, _instructions (+44 more)

### Community 2 - "api_client.dart"
Cohesion: 0.06
Nodes (30): Client, dart:convert, dart:io, package:http/http.dart, coach, config, createCertificate, createFeedback (+22 more)

### Community 3 - "router.dart"
Cohesion: 0.06
Nodes (36): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+28 more)

### Community 4 - "answer_match.dart"
Cohesion: 0.06
Nodes (33): Object?, accepted, after, answer, AnswerKey, answerMatches, any, before (+25 more)

### Community 5 - "modals.dart"
Cohesion: 0.07
Nodes (28): DateTime get, required String message,
  String, return res ??, ui.dart, _band, build, _category, confirmLabel (+20 more)

### Community 6 - "live_interview_screen.dart"
Cohesion: 0.06
Nodes (35): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+27 more)

### Community 7 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (30): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+22 more)

### Community 8 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (28): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+20 more)

### Community 9 - "overview_screen.dart"
Cohesion: 0.06
Nodes (31): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+23 more)

### Community 10 - "mock_api.dart"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 11 - "ui.dart"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 12 - "app_colors.dart"
Cohesion: 0.12
Nodes (16): AppColors, background, bandTone, border, destructive, foreground, info, muted (+8 more)

### Community 13 - "listening_runner_screen.dart"
Cohesion: 0.07
Nodes (29): _answered, _answers, _bottomBar, createState, dispose, exam, examId, full (+21 more)

### Community 14 - "section_audio_player.dart"
Cohesion: 0.07
Nodes (28): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+20 more)

### Community 15 - "speaking_screen.dart"
Cohesion: 0.06
Nodes (34): _cap, _clips, createState, dispose, _elapsed, _examId, _finishPrep, full (+26 more)

### Community 16 - "writing_convert.dart"
Cohesion: 0.08
Nodes (22): return, a, block, _chartVisual, _formalityKind, g, minWords, out (+14 more)

### Community 17 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 18 - "writing_results_screen.dart"
Cohesion: 0.18
Nodes (11): _annotated, _CoachingCard, createState, _crit, _critColor, _essayTypeLabel, _feedback, notes (+3 more)

### Community 19 - "reading_hub_screen.dart"
Cohesion: 0.08
Nodes (25): build, _Item, lockKey, PracticeHubScreen, route, soon, build, createState (+17 more)

### Community 20 - "app_state.dart"
Cohesion: 0.11
Nodes (17): auth_state.dart, bool get, FluentaUser? get, package:flutter/foundation.dart, PlanTier get, _auth, bind, clearExamDate (+9 more)

### Community 21 - "auth_state.dart"
Cohesion: 0.11
Nodes (17): BootStatus get, ../config/app_config.dart, FluentaUser, ApiClient, api, BootStatus, bootstrap, config (+9 more)

### Community 22 - "app_config.dart"
Cohesion: 0.07
Nodes (25): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+17 more)

### Community 23 - "State"
Cohesion: 0.13
Nodes (21): _ExamCountdownCard, _ExamCountdownCardState, ListeningRunnerScreen, _ListeningRunnerScreenState, OnboardingScreen, _OnboardingScreenState, OverviewScreen, ReadingRunnerScreen (+13 more)

### Community 24 - "settings_screen.dart"
Cohesion: 0.22
Nodes (9): _busy, _c, createState, dispose, initState, _saveAndReconnect, _ServerUrlCard, _ServerUrlCardState (+1 more)

### Community 25 - "login_screen.dart"
Cohesion: 0.13
Nodes (15): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+7 more)

### Community 26 - "coach_screen.dart"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 27 - "question_group_view.dart"
Cohesion: 0.13
Nodes (14): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+6 more)

### Community 28 - "writing_editor_screen.dart"
Cohesion: 0.09
Nodes (21): ExamMode get, _afterFullTask, build, _controller, createState, dispose, full, initState (+13 more)

### Community 29 - "dashboard_screen.dart"
Cohesion: 0.22
Nodes (8): dart:async, createState, DashboardScreen, dispose, initState, _QuickStartGrid, _StreakCard, _t

### Community 30 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 31 - "runner_timer.dart"
Cohesion: 0.11
Nodes (17): build, dispose, elapsed, enabled, _expired, label, mode, onExpire (+9 more)

### Community 32 - "StatelessWidget"
Cohesion: 0.17
Nodes (12): _TypingBubble, StatelessWidget, ModeBadge, TimerChip, EmptyStateView, FluentaCard, GradientCard, LockPill (+4 more)

### Community 33 - "build"
Cohesion: 0.09
Nodes (23): build, build, build, build, build, _plan, build, build (+15 more)

### Community 34 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 35 - "feedback_list_screen.dart"
Cohesion: 0.20
Nodes (10): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+2 more)

### Community 36 - "mock_exams_screen.dart"
Cohesion: 0.20
Nodes (10): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+2 more)

### Community 37 - "package:provider/provider.dart"
Cohesion: 0.13
Nodes (15): build, OfflineScreen, _tile, _authored, build, _card, createState, initState (+7 more)

### Community 38 - "grading_overlay.dart"
Cohesion: 0.20
Nodes (10): Timer?, build, createState, dispose, _GradingDialog, _GradingDialogState, initState, _pct (+2 more)

### Community 39 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 40 - "full_exam_screen.dart"
Cohesion: 0.18
Nodes (11): build, _card, createState, FullExamScreen, _FullExamScreenState, _sections, _startRoute, _writingT1 (+3 more)

### Community 41 - "listening_loader_screen.dart"
Cohesion: 0.20
Nodes (10): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, mode (+2 more)

### Community 42 - "reading_loader_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, mode, ReadingLoaderScreen, _ReadingLoaderScreenState (+1 more)

### Community 43 - "../models/models.dart"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ../models/models.dart (+1 more)

### Community 44 - "AuthState"
Cohesion: 0.23
Nodes (15): ChangeNotifier, createState, FullExamResultsScreen, _FullExamResultsScreenState, _generateCertificate, _issuing, _skillRow, MoreScreen (+7 more)

### Community 45 - "exam_mode.dart"
Cohesion: 0.12
Nodes (16): String get, ExamMode, ExamModeWire, ExamTiming, listeningCheckSec, modeFromQuery, readingSec, _roundHalf (+8 more)

### Community 46 - "../theme/app_colors.dart"
Cohesion: 0.20
Nodes (10): build, HelpScreen, build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState (+2 more)

### Community 47 - "full_exam_store.dart"
Cohesion: 0.18
Nodes (10): allDone, bands, FullExamStore, has, order, record, reset, static bool get (+2 more)

### Community 48 - "progress_screen.dart"
Cohesion: 0.25
Nodes (8): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard, ../utils/format.dart

### Community 49 - "String?"
Cohesion: 0.22
Nodes (8): build, paint, _series, shouldRepaint, visual, VisualPrompt, static const, String?

### Community 50 - "mode_picker.dart"
Cohesion: 0.18
Nodes (10): IconData?, VoidCallback?, build, icon, mode, _ModeTile, onTap, pushWithMode (+2 more)

### Community 51 - "app_theme.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 52 - "../mock/data.dart"
Cohesion: 0.33
Nodes (6): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, ../mock/data.dart

### Community 53 - "../services/api_client.dart"
Cohesion: 0.20
Nodes (9): app, auth, build, config, FluentaApp, main, router.dart, ../services/api_client.dart (+1 more)

### Community 54 - "package:flutter/material.dart"
Cohesion: 0.15
Nodes (14): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, ListeningResultsScreen, ReadingResultsScreen, AppShell, build (+6 more)

### Community 55 - "Route /full-exam"
Cohesion: 0.29
Nodes (7): _submit, _submit, _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 57 - "QuestionType"
Cohesion: 0.67
Nodes (3): QuestionType, QuestionTypeLabel, QuestionTypeWire

## Knowledge Gaps
- **848 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+843 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `modals.dart`, `live_interview_screen.dart`, `onboarding_screen.dart`, `reading_runner_screen.dart`, `overview_screen.dart`, `listening_runner_screen.dart`, `speaking_screen.dart`, `reading_hub_screen.dart`, `app_state.dart`, `auth_state.dart`, `State`, `settings_screen.dart`, `login_screen.dart`, `coach_screen.dart`, `writing_editor_screen.dart`, `track_switcher.dart`, `build`, `achievements_screen.dart`, `feedback_list_screen.dart`, `package:provider/provider.dart`, `certificates_screen.dart`, `listening_loader_screen.dart`, `reading_loader_screen.dart`, `../services/api_client.dart`, `Route /full-exam`?**
  _High betweenness centrality (0.117) - this node is a cross-community bridge._
- **Why does `ExamMode` connect `exam_mode.dart` to `reading_runner_screen.dart`, `listening_loader_screen.dart`, `reading_loader_screen.dart`, `listening_runner_screen.dart`, `speaking_screen.dart`, `mode_picker.dart`, `writing_editor_screen.dart`, `runner_timer.dart`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **Why does `AppState` connect `AuthState` to `build`, `package:provider/provider.dart`, `modals.dart`, `full_exam_screen.dart`, `overview_screen.dart`, `speaking_screen.dart`, `reading_hub_screen.dart`, `app_state.dart`, `../services/api_client.dart`, `State`, `settings_screen.dart`, `build`, `dashboard_screen.dart`?**
  _High betweenness centrality (0.017) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _848 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.011904761904761904 - nodes in this community are weakly interconnected._
- **Should `exam_convert.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03773584905660377 - nodes in this community are weakly interconnected._
- **Should `api_client.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06451612903225806 - nodes in this community are weakly interconnected._