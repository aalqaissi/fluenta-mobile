# Graph Report - D:\personal\fluenta-mobile\lib  (2026-09-26)

## Corpus Check
- Corpus is ~34,152 words - fits in a single context window. You may not need a graph.

## Summary
- 1078 nodes · 1640 edges · 55 communities (53 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `02298e1`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models
- .
- features/writing
- features/listening
- widgets
- features/simulation
- services
- services
- features/onboarding
- features/reading
- features/overview
- services
- widgets
- theme
- features/listening
- features/speaking
- features/settings
- mock
- state
- features/dashboard
- state
- features/auth
- features/reading
- config
- features/coach
- features/writing
- features/exam
- features/writing
- services
- features/tracks
- config
- features/achievements
- features/full_exam
- widgets
- .
- features/certificates
- features/feedback
- features/listening
- features/reading
- utils
- .
- features/bootstrap
- .
- features/lessons
- features/practice
- features/writing
- features/checkout
- features/full_exam
- features/writing
- theme
- features/shell
- .
- .
- models
- models

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

## Communities (55 total, 2 thin omitted)

### Community 0 - "models"
Cohesion: 0.01
Nodes (161): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+153 more)

### Community 1 - "."
Cohesion: 0.04
Nodes (48): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+40 more)

### Community 2 - "features/writing"
Cohesion: 0.06
Nodes (35): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+27 more)

### Community 3 - "features/listening"
Cohesion: 0.06
Nodes (36): AudioPlayer?, dart:async, alreadyPlayed, audioUrl, build, createState, dispose, durationSec (+28 more)

### Community 4 - "widgets"
Cohesion: 0.06
Nodes (32): DateTime get, required String message,
  String, return res ??, ui.dart, _band, build, _category, confirmLabel (+24 more)

### Community 5 - "features/simulation"
Cohesion: 0.06
Nodes (31): ApiClient get, _answers, _api, _Bubble, _bubbles, _bubbleTile, build, _busy (+23 more)

### Community 6 - "services"
Cohesion: 0.06
Nodes (31): Client, dart:convert, dart:io, Exception, package:http/http.dart, ApiException, coach, config (+23 more)

### Community 7 - "services"
Cohesion: 0.06
Nodes (31): dart:math, counter, _group, groups, _instructions, _letters, listeningExamFromContent, _listeningSection (+23 more)

### Community 8 - "features/onboarding"
Cohesion: 0.07
Nodes (30): DateTime?, _bands, build, _card, center, _choiceGrid, color, _complete (+22 more)

### Community 9 - "features/reading"
Cohesion: 0.07
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 10 - "features/overview"
Cohesion: 0.07
Nodes (29): _activityRow, _band, build, color, createState, _future, _hero, _heroDivider (+21 more)

### Community 11 - "services"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 12 - "widgets"
Cohesion: 0.07
Nodes (27): Border?, Color?, EdgeInsetsGeometry, Widget, action, bg, border, child (+19 more)

### Community 13 - "theme"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, static bool get (+18 more)

### Community 14 - "features/listening"
Cohesion: 0.07
Nodes (27): _answered, _answers, _bottomBar, createState, dispose, exam, examId, full (+19 more)

### Community 15 - "features/speaking"
Cohesion: 0.08
Nodes (25): _clips, createState, dispose, _elapsed, _examId, initState, _loadError, _loading (+17 more)

### Community 16 - "features/settings"
Cohesion: 0.16
Nodes (18): build, OfflineScreen, MoreScreen, _tile, build, _busy, _c, createState (+10 more)

### Community 17 - "mock"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 18 - "state"
Cohesion: 0.11
Nodes (17): auth_state.dart, bool get, FluentaUser? get, package:flutter/foundation.dart, PlanTier get, _auth, bind, clearExamDate (+9 more)

### Community 19 - "features/dashboard"
Cohesion: 0.16
Nodes (17): ChangeNotifier, build, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState (+9 more)

### Community 20 - "state"
Cohesion: 0.12
Nodes (16): BootStatus get, FluentaUser, ApiClient, api, BootStatus, bootstrap, config, _error (+8 more)

### Community 21 - "features/auth"
Cohesion: 0.12
Nodes (16): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+8 more)

### Community 22 - "features/reading"
Cohesion: 0.12
Nodes (16): build, createState, _featured, _featuredCard, _future, icon, initState, _load (+8 more)

### Community 23 - "config"
Cohesion: 0.12
Nodes (15): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+7 more)

### Community 24 - "features/coach"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 25 - "features/writing"
Cohesion: 0.13
Nodes (14): build, _controller, createState, dispose, initState, _submit, task, taskId (+6 more)

### Community 26 - "features/exam"
Cohesion: 0.14
Nodes (13): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+5 more)

### Community 27 - "features/writing"
Cohesion: 0.20
Nodes (14): SectionAudioPlayer, _SectionAudioPlayerState, ProgressScreen, _ProgressScreenState, LiveInterviewScreen, _LiveInterviewScreenState, SpeakingScreen, _SpeakingScreenState (+6 more)

### Community 28 - "services"
Cohesion: 0.14
Nodes (13): a, block, _chartVisual, _formalityKind, g, minWords, out, prompt (+5 more)

### Community 29 - "features/tracks"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 30 - "config"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 31 - "features/achievements"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 32 - "features/full_exam"
Cohesion: 0.20
Nodes (10): build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored, _scoredCard (+2 more)

### Community 33 - "widgets"
Cohesion: 0.18
Nodes (11): _StepHeader, _TypingBubble, StatelessWidget, EmptyStateView, FluentaCard, GradientCard, LockPill, PillBadge (+3 more)

### Community 34 - "."
Cohesion: 0.20
Nodes (9): ../config/app_config.dart, app, auth, build, config, FluentaApp, main, router.dart (+1 more)

### Community 35 - "features/certificates"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 36 - "features/feedback"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 37 - "features/listening"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, listening_runner_screen.dart (+1 more)

### Community 38 - "features/reading"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart (+1 more)

### Community 39 - "utils"
Cohesion: 0.20
Nodes (9): return, cefrForBand, days, formatBand, longDate, months, n, pad2 (+1 more)

### Community 40 - "."
Cohesion: 0.31
Nodes (7): config/brand.dart, ../exam/question_group_view.dart, ListeningResultsScreen, ReadingResultsScreen, ../mock/passages.dart, ../services/mock_api.dart, ../utils/format.dart

### Community 41 - "features/bootstrap"
Cohesion: 0.29
Nodes (6): build, SplashScreen, build, HelpScreen, package:flutter/material.dart, ../theme/app_colors.dart

### Community 42 - "."
Cohesion: 0.25
Nodes (8): _generateCertificate, build, Route /achievements, Route /certificates, Route /feedback, Route /help, Route /lessons, Route /settings

### Community 43 - "features/lessons"
Cohesion: 0.29
Nodes (7): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState, ../mock/data.dart

### Community 44 - "features/practice"
Cohesion: 0.25
Nodes (7): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,

### Community 45 - "features/writing"
Cohesion: 0.25
Nodes (7): build, paint, _series, shouldRepaint, visual, VisualPrompt, String?

### Community 46 - "features/checkout"
Cohesion: 0.33
Nodes (6): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, ../../widgets/ui.dart

### Community 47 - "features/full_exam"
Cohesion: 0.33
Nodes (6): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, full_exam_store.dart

### Community 48 - "features/writing"
Cohesion: 0.29
Nodes (6): _annotated, createState, _crit, _critColor, _feedback, WritingCriterionKey

### Community 49 - "theme"
Cohesion: 0.33
Nodes (5): app_colors.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 50 - "features/shell"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 51 - "."
Cohesion: 0.40
Nodes (5): _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 52 - "."
Cohesion: 0.50
Nodes (4): CustomPainter, _SeriesChartPainter, _LineChartPainter, _RingPainter

## Knowledge Gaps
- **720 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+715 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `features/settings` to `features/writing`, `widgets`, `features/simulation`, `features/onboarding`, `features/reading`, `features/overview`, `features/listening`, `features/speaking`, `state`, `features/dashboard`, `state`, `features/auth`, `features/reading`, `features/coach`, `features/writing`, `features/writing`, `features/tracks`, `features/achievements`, `.`, `features/certificates`, `features/feedback`, `features/listening`, `features/reading`, `.`, `features/full_exam`, `.`?**
  _High betweenness centrality (0.132) - this node is a cross-community bridge._
- **Why does `AppState` connect `features/dashboard` to `features/full_exam`, `features/writing`, `.`, `widgets`, `.`, `features/overview`, `features/practice`, `features/full_exam`, `features/settings`, `features/speaking`, `state`, `features/writing`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Why does `build` connect `.` to `features/settings`, `features/dashboard`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _720 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models` be split into smaller, more focused modules?**
  _Cohesion score 0.012345679012345678 - nodes in this community are weakly interconnected._
- **Should `.` be split into smaller, more focused modules?**
  _Cohesion score 0.04251700680272109 - nodes in this community are weakly interconnected._
- **Should `features/writing` be split into smaller, more focused modules?**
  _Cohesion score 0.058029689608636977 - nodes in this community are weakly interconnected._