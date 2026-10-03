# Graph Report - D:\personal\fluenta-mobile\lib  (2026-10-02)

## Corpus Check
- Corpus is ~39,176 words - fits in a single context window. You may not need a graph.

## Summary
- 1247 nodes · 1864 edges · 53 communities (51 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `03011e6`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models
- services
- .
- widgets
- utils
- features/simulation
- features/speaking
- state
- features/overview
- services
- features/listening
- features/onboarding
- features/reading
- services
- features/listening
- widgets
- config
- features/writing
- features/dashboard
- services
- features/writing
- mock
- features/settings
- widgets
- features/reading
- features/auth
- utils
- theme
- features/lessons
- features/exam
- features/mock_exams
- .
- features/coach
- .
- widgets
- features/tracks
- .
- widgets
- features/achievements
- features/full_exam
- features/listening
- features/writing
- widgets
- features/certificates
- features/feedback
- features/full_exam
- features/reading
- mock
- features/writing
- features/full_exam
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
- `build` --references--> `AuthState`  [EXTRACTED]
  features/bootstrap/offline_screen.dart → state/auth_state.dart

## Import Cycles
- None detected.

## Communities (53 total, 2 thin omitted)

### Community 0 - "models"
Cohesion: 0.01
Nodes (168): double?, int points,, accepted, Achievement, AchievementDto, active, ActivityItem, adminReply (+160 more)

### Community 1 - "services"
Cohesion: 0.03
Nodes (59): answerLetters, authored, _authoredOptionTypes, _chooseCount, chunks, counter, _group, groups (+51 more)

### Community 2 - "."
Cohesion: 0.04
Nodes (48): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+40 more)

### Community 3 - "widgets"
Cohesion: 0.05
Nodes (46): DateTime get, CheckoutScreen, _CheckoutScreenState, FullExamScreen, _FullExamScreenState, MockExamsScreen, _MockExamsScreenState, ProgressScreen (+38 more)

### Community 4 - "utils"
Cohesion: 0.05
Nodes (42): Object?, accepted, after, answer, answeredSlots, AnswerKey, answerLetters, answerMarks (+34 more)

### Community 5 - "features/simulation"
Cohesion: 0.05
Nodes (37): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+29 more)

### Community 6 - "features/speaking"
Cohesion: 0.06
Nodes (36): _cap, _clips, createState, dispose, _elapsed, _examId, _finishPrep, full (+28 more)

### Community 7 - "state"
Cohesion: 0.06
Nodes (33): auth_state.dart, bool get, BootStatus get, FluentaUser? get, FluentaUser, package:flutter/foundation.dart, PlanTier get, ApiClient (+25 more)

### Community 8 - "features/overview"
Cohesion: 0.06
Nodes (33): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+25 more)

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
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 13 - "services"
Cohesion: 0.07
Nodes (29): ../mock/passages.dart, answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec (+21 more)

### Community 14 - "features/listening"
Cohesion: 0.07
Nodes (28): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+20 more)

### Community 15 - "widgets"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 16 - "config"
Cohesion: 0.07
Nodes (25): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+17 more)

### Community 17 - "features/writing"
Cohesion: 0.08
Nodes (25): ChangeNotifier, ExamMode get, _afterFullTask, build, _controller, createState, dispose, full (+17 more)

### Community 18 - "features/dashboard"
Cohesion: 0.12
Nodes (22): build, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid (+14 more)

### Community 19 - "services"
Cohesion: 0.08
Nodes (22): return, a, block, _chartVisual, _formalityKind, g, minWords, out (+14 more)

### Community 20 - "features/writing"
Cohesion: 0.14
Nodes (17): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, _annotated, _CoachingCard, createState, _crit (+9 more)

### Community 21 - "mock"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 22 - "features/settings"
Cohesion: 0.16
Nodes (18): _submit, _submit, build, _busy, _c, createState, dispose, initState (+10 more)

### Community 23 - "widgets"
Cohesion: 0.11
Nodes (18): build, dispose, elapsed, enabled, _expired, label, mode, ModeBadge (+10 more)

### Community 24 - "features/reading"
Cohesion: 0.12
Nodes (17): build, createState, _empty, _featured, _featuredCard, _future, icon, initState (+9 more)

### Community 25 - "features/auth"
Cohesion: 0.12
Nodes (16): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+8 more)

### Community 26 - "utils"
Cohesion: 0.12
Nodes (16): String get, ExamMode, ExamModeWire, ExamTiming, listeningCheckSec, modeFromQuery, readingSec, _roundHalf (+8 more)

### Community 27 - "theme"
Cohesion: 0.12
Nodes (16): AppColors, background, bandTone, border, destructive, foreground, info, muted (+8 more)

### Community 28 - "features/lessons"
Cohesion: 0.14
Nodes (13): build, createState, _selected, build, HelpScreen, build, createState, _filter (+5 more)

### Community 29 - "features/exam"
Cohesion: 0.12
Nodes (15): answers, build, _choiceTypes, group, _input, _multiChoice, _pill, _questionCard (+7 more)

### Community 30 - "features/mock_exams"
Cohesion: 0.13
Nodes (14): build, createState, _items, _part, _type, _uploadSheet, build, createState (+6 more)

### Community 31 - "."
Cohesion: 0.14
Nodes (13): ../config/app_config.dart, build, OfflineScreen, app, auth, build, config, FluentaApp (+5 more)

### Community 32 - "features/coach"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 33 - "."
Cohesion: 0.15
Nodes (12): _generateCertificate, build, MoreScreen, _tile, Route /achievements, Route /certificates, Route /feedback, Route /help (+4 more)

### Community 34 - "widgets"
Cohesion: 0.15
Nodes (13): ListeningResultsScreen, _StepHeader, ReadingResultsScreen, _TypingBubble, StatelessWidget, EmptyStateView, FluentaCard, GradientCard (+5 more)

### Community 35 - "features/tracks"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 36 - "."
Cohesion: 0.17
Nodes (10): app_colors.dart, AppShell, build, navigationShell, package:flutter/material.dart, package:google_fonts/google_fonts.dart, StatefulNavigationShell, buildAppTheme (+2 more)

### Community 37 - "widgets"
Cohesion: 0.18
Nodes (11): dart:async, Timer?, build, createState, dispose, _GradingDialog, _GradingDialogState, initState (+3 more)

### Community 38 - "features/achievements"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 39 - "features/full_exam"
Cohesion: 0.18
Nodes (10): allDone, bands, FullExamStore, has, order, record, reset, static bool get (+2 more)

### Community 40 - "features/listening"
Cohesion: 0.20
Nodes (10): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, mode (+2 more)

### Community 41 - "features/writing"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 42 - "widgets"
Cohesion: 0.18
Nodes (10): IconData?, VoidCallback?, build, icon, mode, _ModeTile, onTap, pushWithMode (+2 more)

### Community 43 - "features/certificates"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 44 - "features/feedback"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 45 - "features/full_exam"
Cohesion: 0.20
Nodes (9): build, _card, createState, _sections, _startRoute, _writingT1, _writingT2, full_exam_store.dart (+1 more)

### Community 46 - "features/reading"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, mode, ReadingLoaderScreen, _ReadingLoaderScreenState (+1 more)

### Community 47 - "mock"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ../models/models.dart (+1 more)

### Community 48 - "features/writing"
Cohesion: 0.22
Nodes (8): build, paint, _series, shouldRepaint, visual, VisualPrompt, static const, String?

### Community 49 - "features/full_exam"
Cohesion: 0.33
Nodes (6): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, ../services/api_client.dart

### Community 50 - "models"
Cohesion: 0.67
Nodes (3): QuestionType, QuestionTypeLabel, QuestionTypeWire

## Knowledge Gaps
- **868 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+863 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `features/settings` to `widgets`, `features/simulation`, `features/speaking`, `state`, `features/overview`, `features/listening`, `features/onboarding`, `features/reading`, `features/writing`, `features/reading`, `features/auth`, `.`, `features/coach`, `.`, `features/tracks`, `features/achievements`, `features/listening`, `features/writing`, `features/certificates`, `features/feedback`, `features/reading`, `features/full_exam`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._
- **Why does `ExamMode` connect `utils` to `features/speaking`, `features/listening`, `features/listening`, `widgets`, `features/reading`, `features/reading`, `features/writing`, `widgets`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **Why does `AppState` connect `features/dashboard` to `.`, `widgets`, `features/speaking`, `state`, `features/overview`, `features/writing`, `features/full_exam`, `features/full_exam`, `features/writing`, `features/speaking`, `features/settings`, `.`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _868 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models` be split into smaller, more focused modules?**
  _Cohesion score 0.011834319526627219 - nodes in this community are weakly interconnected._
- **Should `services` be split into smaller, more focused modules?**
  _Cohesion score 0.03333333333333333 - nodes in this community are weakly interconnected._
- **Should `.` be split into smaller, more focused modules?**
  _Cohesion score 0.04251700680272109 - nodes in this community are weakly interconnected._