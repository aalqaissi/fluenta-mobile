# Graph Report - D:/personal/fluenta-mobile/lib  (2026-09-11)

## Corpus Check
- Corpus is ~29,090 words - fits in a single context window. You may not need a graph.

## Summary
- 929 nodes · 1422 edges · 47 communities (45 shown, 2 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30
- Community 31
- Community 32
- Community 33
- Community 34
- Community 35
- Community 36
- Community 37
- Community 38
- Community 39
- Community 40
- Community 41
- Community 42
- Community 43
- Community 44
- Community 45
- Community 46

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 63 edges
2. `AppState` - 37 edges
3. `build` - 10 edges
4. `build` - 6 edges
5. `_FullExamResultsScreenState` - 5 edges
6. `_OverviewScreenState` - 5 edges
7. `_SpeakingScreenState` - 5 edges
8. `_AchievementsScreenState` - 4 edges
9. `_LoginScreenState` - 4 edges
10. `_CertificatesScreenState` - 4 edges

## Surprising Connections (you probably didn't know these)
- `initState` --references--> `AuthState`  [EXTRACTED]
  achievements_screen.dart → auth_state.dart
- `build` --references--> `AuthState`  [EXTRACTED]
  achievements_screen.dart → auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  login_screen.dart → auth_state.dart
- `_signIn` --references--> `AuthState`  [EXTRACTED]
  login_screen.dart → auth_state.dart
- `initState` --references--> `AuthState`  [EXTRACTED]
  certificates_screen.dart → auth_state.dart

## Import Cycles
- None detected.

## Communities (47 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.01
Nodes (153): Achievement, AchievementDto, active, ActivityItem, adminReply, annotations, answer, answers (+145 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (47): build, build, build, _answered, _answers, _audioCard, _audioT, _audioTimer (+39 more)

### Community 2 - "Community 2"
Cohesion: 0.05
Nodes (42): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+34 more)

### Community 3 - "Community 3"
Cohesion: 0.06
Nodes (39): Border?, HelpScreen, _StepHeader, action, bg, border, child, color (+31 more)

### Community 4 - "Community 4"
Cohesion: 0.06
Nodes (34): Client, ../config/app_config.dart, app, auth, build, config, FluentaApp, main (+26 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (35): build, buildRouter, createState, _NotFoundRedirect, _NotFoundRedirectState, _rootKey, features/achievements/achievements_screen.dart, features/auth/login_screen.dart (+27 more)

### Community 6 - "Community 6"
Cohesion: 0.06
Nodes (32): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+24 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (31): Color?, _bands, build, _card, center, _choiceGrid, color, _complete (+23 more)

### Community 8 - "Community 8"
Cohesion: 0.07
Nodes (31): _band, _category, confirmLabel, context, createState, _date, _days, destructive (+23 more)

### Community 9 - "Community 9"
Cohesion: 0.07
Nodes (28): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+20 more)

### Community 10 - "Community 10"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, AppColors (+18 more)

### Community 11 - "Community 11"
Cohesion: 0.07
Nodes (27): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+19 more)

### Community 12 - "Community 12"
Cohesion: 0.16
Nodes (18): build, OfflineScreen, MoreScreen, _tile, build, _busy, _c, createState (+10 more)

### Community 13 - "Community 13"
Cohesion: 0.16
Nodes (16): ChangeNotifier, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid (+8 more)

### Community 14 - "Community 14"
Cohesion: 0.12
Nodes (16): auth_state.dart, _auth, bind, clearExamDate, effectivePlan, isLocked, isPro, _previewFree (+8 more)

### Community 15 - "Community 15"
Cohesion: 0.12
Nodes (16): bool get, BootStatus get, FluentaUser, ApiClient, api, BootStatus, bootstrap, config (+8 more)

### Community 16 - "Community 16"
Cohesion: 0.13
Nodes (14): AppConfig, defaultServerUrl, load, _normalize, _prefs, serverUrl, serverUrlKey, setServerUrl (+6 more)

### Community 17 - "Community 17"
Cohesion: 0.14
Nodes (14): build, createState, _featured, _future, icon, initState, _load, _Meta (+6 more)

### Community 18 - "Community 18"
Cohesion: 0.14
Nodes (14): createState, dispose, _done, _elapsed, initState, _loadParts, _part, _parts (+6 more)

### Community 19 - "Community 19"
Cohesion: 0.14
Nodes (13): build, _controller, createState, dispose, initState, _submit, task, taskId (+5 more)

### Community 20 - "Community 20"
Cohesion: 0.17
Nodes (12): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+4 more)

### Community 21 - "Community 21"
Cohesion: 0.18
Nodes (10): ListeningResultsScreen, ReadingResultsScreen, AppShell, build, navigationShell, ../exam/question_group_view.dart, ../mock/passages.dart, package:go_router/go_router.dart (+2 more)

### Community 22 - "Community 22"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 23 - "Community 23"
Cohesion: 0.15
Nodes (12): _group, listeningExamFromContent, _listeningSection, map, _options, _passage, passages, _question (+4 more)

### Community 24 - "Community 24"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 25 - "Community 25"
Cohesion: 0.18
Nodes (11): build, _busy, createState, dispose, _email, initState, LoginScreen, _LoginScreenState (+3 more)

### Community 26 - "Community 26"
Cohesion: 0.23
Nodes (12): CheckoutScreen, _CheckoutScreenState, ReadingRunnerScreen, _ReadingRunnerScreenState, WritingEditorScreen, _WritingEditorScreenState, WritingResultsScreen, _WritingResultsScreenState (+4 more)

### Community 27 - "Community 27"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 28 - "Community 28"
Cohesion: 0.18
Nodes (11): _generateCertificate, build, _plan, build, Route /achievements, Route /certificates, Route /checkout, Route /feedback (+3 more)

### Community 29 - "Community 29"
Cohesion: 0.20
Nodes (10): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+2 more)

### Community 30 - "Community 30"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 31 - "Community 31"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 32 - "Community 32"
Cohesion: 0.22
Nodes (9): build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored, _scoredCard (+1 more)

### Community 33 - "Community 33"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, listening_runner_screen.dart (+1 more)

### Community 34 - "Community 34"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart (+1 more)

### Community 35 - "Community 35"
Cohesion: 0.20
Nodes (9): cefrForBand, days, formatBand, longDate, months, n, pad2, prettyDate (+1 more)

### Community 36 - "Community 36"
Cohesion: 0.20
Nodes (9): build, createState, dispose, initState, _pct, showGradingDialog, _timer, dart:async (+1 more)

### Community 37 - "Community 37"
Cohesion: 0.22
Nodes (8): build, _Item, lockKey, PracticeHubScreen, route, soon, String?, String key, title, sub,

### Community 38 - "Community 38"
Cohesion: 0.25
Nodes (8): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard, ../../widgets/modals.dart

### Community 39 - "Community 39"
Cohesion: 0.29
Nodes (6): build, createState, _selected, build, ../theme/app_colors.dart, ../../widgets/ui.dart

### Community 40 - "Community 40"
Cohesion: 0.29
Nodes (7): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, full_exam_store.dart, ../utils/format.dart

### Community 41 - "Community 41"
Cohesion: 0.29
Nodes (7): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState, ../mock/data.dart

### Community 42 - "Community 42"
Cohesion: 0.25
Nodes (7): _annotated, createState, _crit, _critColor, _feedback, result, WritingCriterionKey

### Community 43 - "Community 43"
Cohesion: 0.29
Nodes (6): app_colors.dart, buildAppTheme, scheme, textTheme, package:flutter/material.dart, package:google_fonts/google_fonts.dart

### Community 44 - "Community 44"
Cohesion: 0.50
Nodes (3): config/brand.dart, build, SplashScreen

## Knowledge Gaps
- **604 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+599 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `Community 12` to `Community 1`, `Community 4`, `Community 6`, `Community 7`, `Community 8`, `Community 9`, `Community 13`, `Community 14`, `Community 15`, `Community 17`, `Community 18`, `Community 22`, `Community 25`, `Community 26`, `Community 27`, `Community 28`, `Community 30`, `Community 31`, `Community 33`, `Community 34`, `Community 40`?**
  _High betweenness centrality (0.100) - this node is a cross-community bridge._
- **Why does `AppState` connect `Community 13` to `Community 32`, `Community 1`, `Community 4`, `Community 37`, `Community 6`, `Community 40`, `Community 8`, `Community 12`, `Community 14`, `Community 18`, `Community 28`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Why does `AppConfig` connect `Community 16` to `Community 4`, `Community 15`?**
  _High betweenness centrality (0.022) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _604 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.012987012987012988 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.04521276595744681 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.045454545454545456 - nodes in this community are weakly interconnected._