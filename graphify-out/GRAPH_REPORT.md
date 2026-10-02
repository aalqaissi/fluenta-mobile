# Graph Report - D:\personal\fluenta-mobile\lib  (2026-10-02)

## Corpus Check
- Corpus is ~39,037 words - fits in a single context window. You may not need a graph.

## Summary
- 1242 nodes · 1859 edges · 59 communities (57 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f5a056e`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models
- services
- config
- utils
- features/listening
- features/simulation
- .
- features/speaking
- state
- services
- widgets
- features/listening
- features/onboarding
- features/reading
- features/overview
- services
- widgets
- features/writing
- services
- features/settings
- mock
- .
- features/mock_exams
- features/reading
- features/auth
- theme
- widgets
- features/exam
- features/coach
- features/writing
- .
- features/writing
- features/dashboard
- widgets
- features/tracks
- features/achievements
- features/full_exam
- features/listening
- features/writing
- widgets
- features/certificates
- features/feedback
- features/reading
- features/writing
- mock
- .
- features/practice
- .
- features/full_exam
- theme
- features/checkout
- .
- features/lessons
- .
- features/shell
- features/help
- models
- features/speaking
- models

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
  features/achievements/achievements_screen.dart → state/auth_state.dart
- `build` --references--> `AuthState`  [EXTRACTED]
  features/achievements/achievements_screen.dart → state/auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  features/auth/login_screen.dart → state/auth_state.dart
- `_signIn` --references--> `AuthState`  [EXTRACTED]
  features/auth/login_screen.dart → state/auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  features/certificates/certificates_screen.dart → state/auth_state.dart

## Import Cycles
- None detected.

## Communities (59 total, 2 thin omitted)

### Community 0 - "models"
Cohesion: 0.01
Nodes (168): double?, int points,, accepted, Achievement, AchievementDto, active, ActivityItem, adminReply (+160 more)

### Community 1 - "services"
Cohesion: 0.04
Nodes (54): answerLetters, authored, _authoredOptionTypes, _chooseCount, chunks, counter, _group, groups (+46 more)

### Community 2 - "config"
Cohesion: 0.05
Nodes (41): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+33 more)

### Community 3 - "utils"
Cohesion: 0.05
Nodes (42): Object?, accepted, after, answer, answeredSlots, AnswerKey, answerLetters, answerMarks (+34 more)

### Community 4 - "features/listening"
Cohesion: 0.05
Nodes (37): AudioPlayer?, dart:async, alreadyPlayed, audioUrl, build, createState, dispose, durationSec (+29 more)

### Community 5 - "features/simulation"
Cohesion: 0.05
Nodes (37): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+29 more)

### Community 6 - "."
Cohesion: 0.06
Nodes (36): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+28 more)

### Community 7 - "features/speaking"
Cohesion: 0.06
Nodes (36): _cap, _clips, createState, dispose, _elapsed, _examId, _finishPrep, full (+28 more)

### Community 8 - "state"
Cohesion: 0.06
Nodes (33): auth_state.dart, bool get, BootStatus get, FluentaUser? get, FluentaUser, package:flutter/foundation.dart, PlanTier get, ApiClient (+25 more)

### Community 9 - "services"
Cohesion: 0.06
Nodes (32): Client, dart:convert, dart:io, Exception, package:http/http.dart, ApiException, coach, config (+24 more)

### Community 10 - "widgets"
Cohesion: 0.06
Nodes (32): DateTime get, required String message,
  String, return res ??, ui.dart, _band, build, _category, confirmLabel (+24 more)

### Community 11 - "features/listening"
Cohesion: 0.06
Nodes (32): _answered, _answers, _bottomBar, createState, dispose, exam, examId, full (+24 more)

### Community 12 - "features/onboarding"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 13 - "features/reading"
Cohesion: 0.06
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 14 - "features/overview"
Cohesion: 0.07
Nodes (29): _activityRow, _band, build, color, createState, _future, _hero, _heroDivider (+21 more)

### Community 15 - "services"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 16 - "widgets"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 17 - "features/writing"
Cohesion: 0.08
Nodes (23): ChangeNotifier, ExamMode get, _afterFullTask, build, _controller, createState, dispose, full (+15 more)

### Community 18 - "services"
Cohesion: 0.08
Nodes (22): return, a, block, _chartVisual, _formalityKind, g, minWords, out (+14 more)

### Community 19 - "features/settings"
Cohesion: 0.16
Nodes (18): build, OfflineScreen, MoreScreen, _tile, build, _busy, _c, createState (+10 more)

### Community 20 - "mock"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 21 - "."
Cohesion: 0.12
Nodes (16): ../config/app_config.dart, createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, app, auth (+8 more)

### Community 22 - "features/mock_exams"
Cohesion: 0.12
Nodes (16): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+8 more)

### Community 23 - "features/reading"
Cohesion: 0.12
Nodes (17): build, createState, _empty, _featured, _featuredCard, _future, icon, initState (+9 more)

### Community 24 - "features/auth"
Cohesion: 0.12
Nodes (16): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+8 more)

### Community 25 - "theme"
Cohesion: 0.12
Nodes (16): AppColors, background, bandTone, border, destructive, foreground, info, muted (+8 more)

### Community 26 - "widgets"
Cohesion: 0.12
Nodes (16): build, dispose, elapsed, enabled, _expired, label, mode, onExpire (+8 more)

### Community 27 - "features/exam"
Cohesion: 0.12
Nodes (15): answers, build, _choiceTypes, group, _input, _multiChoice, _pill, _questionCard (+7 more)

### Community 28 - "features/coach"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 29 - "features/writing"
Cohesion: 0.20
Nodes (14): FullExamScreen, _FullExamScreenState, SectionAudioPlayer, _SectionAudioPlayerState, ProgressScreen, _ProgressScreenState, ReadingRunnerScreen, _ReadingRunnerScreenState (+6 more)

### Community 30 - "."
Cohesion: 0.22
Nodes (10): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, ListeningResultsScreen, ReadingResultsScreen, ../mock/passages.dart, ../services/mock_api.dart (+2 more)

### Community 31 - "features/writing"
Cohesion: 0.15
Nodes (12): CustomPainter, _SeriesChartPainter, build, _LineChartPainter, paint, _series, shouldRepaint, visual (+4 more)

### Community 32 - "features/dashboard"
Cohesion: 0.22
Nodes (12): createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid, _StreakCard (+4 more)

### Community 33 - "widgets"
Cohesion: 0.15
Nodes (13): _StepHeader, _TypingBubble, StatelessWidget, ModeBadge, TimerChip, EmptyStateView, FluentaCard, GradientCard (+5 more)

### Community 34 - "features/tracks"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 35 - "features/achievements"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 36 - "features/full_exam"
Cohesion: 0.18
Nodes (10): allDone, bands, FullExamStore, has, order, record, reset, static bool get (+2 more)

### Community 37 - "features/listening"
Cohesion: 0.20
Nodes (10): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, mode (+2 more)

### Community 38 - "features/writing"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 39 - "widgets"
Cohesion: 0.18
Nodes (10): IconData?, VoidCallback?, build, icon, mode, _ModeTile, onTap, pushWithMode (+2 more)

### Community 40 - "features/certificates"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 41 - "features/feedback"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 42 - "features/reading"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, mode, ReadingLoaderScreen, _ReadingLoaderScreenState (+1 more)

### Community 43 - "features/writing"
Cohesion: 0.20
Nodes (9): _annotated, _CoachingCard, createState, _crit, _critColor, _essayTypeLabel, _feedback, notes (+1 more)

### Community 44 - "mock"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ../models/models.dart (+1 more)

### Community 45 - "."
Cohesion: 0.25
Nodes (9): build, _plan, build, build, Route /checkout, Route /coach, Route /progress, Route /reading (+1 more)

### Community 46 - "features/practice"
Cohesion: 0.22
Nodes (8): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,, ../../widgets/mode_picker.dart

### Community 47 - "."
Cohesion: 0.25
Nodes (8): _generateCertificate, build, Route /achievements, Route /certificates, Route /feedback, Route /help, Route /lessons, Route /settings

### Community 48 - "features/full_exam"
Cohesion: 0.25
Nodes (7): _card, createState, _sections, _startRoute, _writingT1, _writingT2, full_exam_store.dart

### Community 49 - "theme"
Cohesion: 0.29
Nodes (6): app_colors.dart, package:flutter/material.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 50 - "features/checkout"
Cohesion: 0.33
Nodes (6): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, ../mock/data.dart

### Community 51 - "."
Cohesion: 0.29
Nodes (7): build, build, build, build, Route /, Route /listening, initState

### Community 52 - "features/lessons"
Cohesion: 0.33
Nodes (6): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState

### Community 53 - "."
Cohesion: 0.29
Nodes (7): _submit, _submit, _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 54 - "features/shell"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 55 - "features/help"
Cohesion: 0.50
Nodes (3): build, HelpScreen, ../../widgets/ui.dart

### Community 56 - "models"
Cohesion: 0.67
Nodes (3): QuestionType, QuestionTypeLabel, QuestionTypeWire

## Knowledge Gaps
- **863 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+858 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `features/settings` to `features/simulation`, `features/speaking`, `state`, `widgets`, `features/listening`, `features/onboarding`, `features/reading`, `features/overview`, `features/writing`, `.`, `features/reading`, `features/auth`, `features/coach`, `features/writing`, `features/tracks`, `features/achievements`, `features/listening`, `features/writing`, `features/certificates`, `features/feedback`, `features/reading`, `.`, `.`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Why does `ExamMode` connect `config` to `features/listening`, `features/speaking`, `widgets`, `features/reading`, `features/listening`, `features/reading`, `features/writing`, `widgets`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `AppState` connect `features/dashboard` to `features/writing`, `features/speaking`, `state`, `widgets`, `.`, `features/overview`, `.`, `features/full_exam`, `features/practice`, `features/writing`, `features/settings`, `.`, `features/speaking`, `features/writing`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _863 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models` be split into smaller, more focused modules?**
  _Cohesion score 0.011834319526627219 - nodes in this community are weakly interconnected._
- **Should `services` be split into smaller, more focused modules?**
  _Cohesion score 0.03636363636363636 - nodes in this community are weakly interconnected._
- **Should `config` be split into smaller, more focused modules?**
  _Cohesion score 0.046511627906976744 - nodes in this community are weakly interconnected._