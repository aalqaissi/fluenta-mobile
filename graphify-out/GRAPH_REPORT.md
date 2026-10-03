# Graph Report - D:\personal\fluenta-mobile\lib  (2026-10-03)

## Corpus Check
- Corpus is ~39,274 words - fits in a single context window. You may not need a graph.

## Summary
- 1249 nodes · 1866 edges · 52 communities (50 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `db19157`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models
- services
- .
- utils
- features/listening
- features/simulation
- utils
- features/speaking
- state
- services
- features/listening
- features/onboarding
- features/reading
- features/overview
- widgets
- services
- widgets
- config
- features/writing
- features/writing
- services
- features/settings
- features/dashboard
- mock
- features/reading
- features/auth
- theme
- widgets
- .
- features/exam
- features/lessons
- features/coach
- widgets
- features/writing
- features/tracks
- features/full_exam
- widgets
- features/achievements
- features/feedback
- features/full_exam
- features/full_exam
- features/mock_exams
- features/writing
- widgets
- features/certificates
- mock
- features/practice
- features/progress
- theme
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

## Communities (52 total, 2 thin omitted)

### Community 0 - "models"
Cohesion: 0.01
Nodes (169): double?, int points,, accepted, Achievement, AchievementDto, active, ActivityItem, adminReply (+161 more)

### Community 1 - "services"
Cohesion: 0.03
Nodes (59): answerLetters, authored, _authoredOptionTypes, _chooseCount, chunks, counter, _group, groups (+51 more)

### Community 2 - "."
Cohesion: 0.04
Nodes (48): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+40 more)

### Community 3 - "utils"
Cohesion: 0.05
Nodes (42): Object?, accepted, after, answer, answeredSlots, AnswerKey, answerLetters, answerMarks (+34 more)

### Community 4 - "features/listening"
Cohesion: 0.05
Nodes (37): AudioPlayer?, dart:async, alreadyPlayed, audioUrl, build, createState, dispose, durationSec (+29 more)

### Community 5 - "features/simulation"
Cohesion: 0.05
Nodes (37): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+29 more)

### Community 6 - "utils"
Cohesion: 0.06
Nodes (35): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, mode (+27 more)

### Community 7 - "features/speaking"
Cohesion: 0.06
Nodes (36): _cap, _clips, createState, dispose, _elapsed, _examId, _finishPrep, full (+28 more)

### Community 8 - "state"
Cohesion: 0.06
Nodes (33): auth_state.dart, bool get, BootStatus get, FluentaUser? get, FluentaUser, package:flutter/foundation.dart, PlanTier get, ApiClient (+25 more)

### Community 9 - "services"
Cohesion: 0.06
Nodes (32): Client, dart:convert, dart:io, Exception, package:http/http.dart, ApiException, coach, config (+24 more)

### Community 10 - "features/listening"
Cohesion: 0.06
Nodes (32): _answered, _answers, _bottomBar, createState, dispose, exam, examId, full (+24 more)

### Community 11 - "features/onboarding"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 12 - "features/reading"
Cohesion: 0.06
Nodes (31): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+23 more)

### Community 13 - "features/overview"
Cohesion: 0.07
Nodes (29): _activityRow, _band, build, color, createState, _future, _hero, _heroDivider (+21 more)

### Community 14 - "widgets"
Cohesion: 0.07
Nodes (28): DateTime get, required String message,
  String, return res ??, ui.dart, _band, build, _category, confirmLabel (+20 more)

### Community 15 - "services"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 16 - "widgets"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 17 - "config"
Cohesion: 0.07
Nodes (25): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+17 more)

### Community 18 - "features/writing"
Cohesion: 0.11
Nodes (22): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, build, HelpScreen, ListeningResultsScreen, ReadingResultsScreen (+14 more)

### Community 19 - "features/writing"
Cohesion: 0.08
Nodes (25): ChangeNotifier, ExamMode get, _afterFullTask, build, _controller, createState, dispose, full (+17 more)

### Community 20 - "services"
Cohesion: 0.08
Nodes (22): return, a, block, _chartVisual, _formalityKind, g, minWords, out (+14 more)

### Community 21 - "features/settings"
Cohesion: 0.13
Nodes (21): build, OfflineScreen, _submit, _submit, build, _busy, _c, createState (+13 more)

### Community 22 - "features/dashboard"
Cohesion: 0.12
Nodes (22): build, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid (+14 more)

### Community 23 - "mock"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 24 - "features/reading"
Cohesion: 0.12
Nodes (17): build, createState, _empty, _featured, _featuredCard, _future, icon, initState (+9 more)

### Community 25 - "features/auth"
Cohesion: 0.12
Nodes (16): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+8 more)

### Community 26 - "theme"
Cohesion: 0.12
Nodes (16): AppColors, background, bandTone, border, destructive, foreground, info, muted (+8 more)

### Community 27 - "widgets"
Cohesion: 0.12
Nodes (16): build, dispose, elapsed, enabled, _expired, label, mode, onExpire (+8 more)

### Community 28 - "."
Cohesion: 0.13
Nodes (14): ../config/app_config.dart, MoreScreen, _tile, app, auth, build, config, FluentaApp (+6 more)

### Community 29 - "features/exam"
Cohesion: 0.12
Nodes (15): answers, build, _choiceTypes, group, _input, _multiChoice, _pill, _questionCard (+7 more)

### Community 30 - "features/lessons"
Cohesion: 0.16
Nodes (13): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, build, createState, _filter (+5 more)

### Community 31 - "features/coach"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 32 - "widgets"
Cohesion: 0.14
Nodes (14): _StepHeader, AppShell, _TypingBubble, StatelessWidget, ModeBadge, TimerChip, EmptyStateView, FluentaCard (+6 more)

### Community 33 - "features/writing"
Cohesion: 0.15
Nodes (12): CustomPainter, _SeriesChartPainter, build, _LineChartPainter, paint, _series, shouldRepaint, visual (+4 more)

### Community 34 - "features/tracks"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 35 - "features/full_exam"
Cohesion: 0.18
Nodes (10): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, build, navigationShell, full_exam_store.dart (+2 more)

### Community 36 - "widgets"
Cohesion: 0.23
Nodes (12): SectionAudioPlayer, _SectionAudioPlayerState, ReadingRunnerScreen, _ReadingRunnerScreenState, WritingResultsScreen, _WritingResultsScreenState, State, StatefulWidget (+4 more)

### Community 37 - "features/achievements"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 38 - "features/feedback"
Cohesion: 0.20
Nodes (10): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+2 more)

### Community 39 - "features/full_exam"
Cohesion: 0.20
Nodes (10): build, _card, createState, FullExamScreen, _FullExamScreenState, _sections, _startRoute, _writingT1 (+2 more)

### Community 40 - "features/full_exam"
Cohesion: 0.18
Nodes (10): allDone, bands, FullExamStore, has, order, record, reset, static bool get (+2 more)

### Community 41 - "features/mock_exams"
Cohesion: 0.20
Nodes (10): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+2 more)

### Community 42 - "features/writing"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 43 - "widgets"
Cohesion: 0.18
Nodes (10): IconData?, VoidCallback?, build, icon, mode, _ModeTile, onTap, pushWithMode (+2 more)

### Community 44 - "features/certificates"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 45 - "mock"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ../models/models.dart (+1 more)

### Community 46 - "features/practice"
Cohesion: 0.22
Nodes (8): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,, ../../widgets/mode_picker.dart

### Community 47 - "features/progress"
Cohesion: 0.25
Nodes (8): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard, List

### Community 48 - "theme"
Cohesion: 0.33
Nodes (5): app_colors.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 49 - "models"
Cohesion: 0.67
Nodes (3): QuestionType, QuestionTypeLabel, QuestionTypeWire

## Knowledge Gaps
- **870 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+865 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `features/settings` to `features/simulation`, `utils`, `features/speaking`, `state`, `features/listening`, `features/onboarding`, `features/reading`, `features/overview`, `widgets`, `features/writing`, `features/dashboard`, `features/reading`, `features/auth`, `.`, `features/coach`, `features/tracks`, `features/full_exam`, `widgets`, `features/achievements`, `features/feedback`, `features/writing`, `features/certificates`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `ExamMode` connect `utils` to `features/speaking`, `features/listening`, `widgets`, `features/reading`, `features/writing`, `widgets`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `AppState` connect `features/dashboard` to `features/full_exam`, `widgets`, `features/full_exam`, `features/speaking`, `state`, `features/writing`, `features/overview`, `features/practice`, `widgets`, `features/speaking`, `features/writing`, `features/settings`, `.`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _870 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models` be split into smaller, more focused modules?**
  _Cohesion score 0.011764705882352941 - nodes in this community are weakly interconnected._
- **Should `services` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `.` be split into smaller, more focused modules?**
  _Cohesion score 0.04251700680272109 - nodes in this community are weakly interconnected._