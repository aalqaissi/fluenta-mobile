# Graph Report - lib  (2026-09-11)

## Corpus Check
- Corpus is ~26,739 words - fits in a single context window. You may not need a graph.

## Summary
- 853 nodes · 1286 edges · 39 communities (37 shown, 2 thin omitted)
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

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 52 edges
2. `AppState` - 37 edges
3. `build` - 10 edges
4. `build` - 6 edges
5. `_OverviewScreenState` - 5 edges
6. `_AchievementsScreenState` - 4 edges
7. `_LoginScreenState` - 4 edges
8. `_CertificatesScreenState` - 4 edges
9. `_ExamCountdownCardState` - 4 edges
10. `_FeedbackListScreenState` - 4 edges

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

## Communities (39 total, 2 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.01
Nodes (150): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+142 more)

### Community 1 - "Community 1"
Cohesion: 0.04
Nodes (46): auth_state.dart, bool get, BootStatus get, AppConfig, defaultServerUrl, load, _normalize, _prefs (+38 more)

### Community 2 - "Community 2"
Cohesion: 0.05
Nodes (39): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+31 more)

### Community 3 - "Community 3"
Cohesion: 0.06
Nodes (39): Border?, dart:math, EdgeInsetsGeometry, FullExamScreen, _StepHeader, StatelessWidget, VoidCallback?, Widget (+31 more)

### Community 4 - "Community 4"
Cohesion: 0.06
Nodes (33): Client, ../config/app_config.dart, dart:convert, Exception, app, auth, build, config (+25 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (33): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+25 more)

### Community 6 - "Community 6"
Cohesion: 0.06
Nodes (33): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+25 more)

### Community 7 - "Community 7"
Cohesion: 0.06
Nodes (32): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+24 more)

### Community 8 - "Community 8"
Cohesion: 0.07
Nodes (31): DateTime get, required String message,
  String, return res ??, ui.dart, _band, _category, confirmLabel, context (+23 more)

### Community 9 - "Community 9"
Cohesion: 0.07
Nodes (29): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+21 more)

### Community 10 - "Community 10"
Cohesion: 0.07
Nodes (29): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+21 more)

### Community 11 - "Community 11"
Cohesion: 0.08
Nodes (24): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+16 more)

### Community 12 - "Community 12"
Cohesion: 0.13
Nodes (20): ChangeNotifier, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid (+12 more)

### Community 13 - "Community 13"
Cohesion: 0.10
Nodes (21): build, _submit, build, _plan, build, build, build, Route / (+13 more)

### Community 14 - "Community 14"
Cohesion: 0.13
Nodes (16): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, ReadingResultsScreen, _annotated, createState, _crit (+8 more)

### Community 15 - "Community 15"
Cohesion: 0.16
Nodes (18): LessonsScreen, _LessonsScreenState, ListeningScreen, _ListeningScreenState, MockExamsScreen, _MockExamsScreenState, OnboardingScreen, _OnboardingScreenState (+10 more)

### Community 16 - "Community 16"
Cohesion: 0.11
Nodes (17): static const, AppColors, background, bandTone, border, destructive, foreground, info (+9 more)

### Community 17 - "Community 17"
Cohesion: 0.13
Nodes (14): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, build, HelpScreen, build (+6 more)

### Community 18 - "Community 18"
Cohesion: 0.21
Nodes (13): build, OfflineScreen, build, _busy, _c, createState, dispose, initState (+5 more)

### Community 19 - "Community 19"
Cohesion: 0.14
Nodes (14): build, createState, _featured, _future, icon, initState, _load, _Meta (+6 more)

### Community 20 - "Community 20"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 21 - "Community 21"
Cohesion: 0.15
Nodes (12): build, _controller, createState, dispose, initState, _submit, task, taskId (+4 more)

### Community 22 - "Community 22"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 23 - "Community 23"
Cohesion: 0.18
Nodes (11): build, _busy, createState, dispose, _email, initState, LoginScreen, _LoginScreenState (+3 more)

### Community 24 - "Community 24"
Cohesion: 0.18
Nodes (11): createState, dispose, _done, _elapsed, _part, _recording, _reset, SpeakingScreen (+3 more)

### Community 25 - "Community 25"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 26 - "Community 26"
Cohesion: 0.20
Nodes (10): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+2 more)

### Community 27 - "Community 27"
Cohesion: 0.18
Nodes (10): _answers, createState, dispose, _playing, _section, _t, _timer, _togglePlay (+2 more)

### Community 28 - "Community 28"
Cohesion: 0.20
Nodes (10): build, createState, examId, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart, ../services/api_client.dart (+2 more)

### Community 29 - "Community 29"
Cohesion: 0.20
Nodes (9): dart:async, Timer?, build, createState, dispose, initState, _pct, showGradingDialog (+1 more)

### Community 30 - "Community 30"
Cohesion: 0.22
Nodes (9): build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState, _score (+1 more)

### Community 31 - "Community 31"
Cohesion: 0.22
Nodes (8): return, days, formatBand, longDate, months, n, pad2, prettyDate

### Community 32 - "Community 32"
Cohesion: 0.25
Nodes (7): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,

### Community 33 - "Community 33"
Cohesion: 0.33
Nodes (5): app_colors.dart, package:google_fonts/google_fonts.dart, buildAppTheme, scheme, textTheme

### Community 34 - "Community 34"
Cohesion: 0.33
Nodes (5): MoreScreen, _tile, package:provider/provider.dart, ../tracks/track_switcher.dart, ../../widgets/modals.dart

### Community 35 - "Community 35"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:flutter/material.dart, StatefulNavigationShell

### Community 36 - "Community 36"
Cohesion: 0.40
Nodes (4): build, createState, _filter, _kindIcon

## Knowledge Gaps
- **555 isolated node(s):** `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs`, `serverUrl` (+550 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **2 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `Community 18` to `Community 1`, `Community 34`, `Community 2`, `Community 4`, `Community 7`, `Community 8`, `Community 10`, `Community 12`, `Community 13`, `Community 15`, `Community 19`, `Community 20`, `Community 23`, `Community 25`, `Community 26`, `Community 28`, `Community 30`?**
  _High betweenness centrality (0.089) - this node is a cross-community bridge._
- **Why does `AppState` connect `Community 12` to `Community 32`, `Community 1`, `Community 34`, `Community 3`, `Community 4`, `Community 7`, `Community 8`, `Community 13`, `Community 15`, `Community 18`, `Community 24`, `Community 27`?**
  _High betweenness centrality (0.037) - this node is a cross-community bridge._
- **Why does `AppConfig` connect `Community 1` to `Community 4`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `serverUrlKey`, `tokenKey`, `defaultServerUrl` to the rest of the system?**
  _555 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.013245033112582781 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.04336734693877551 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._