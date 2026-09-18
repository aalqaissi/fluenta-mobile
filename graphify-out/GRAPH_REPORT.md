# Graph Report - fluenta-mobile  (2026-09-18)

## Corpus Check
- 92 files · ~54,476 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1213 nodes · 1800 edges · 71 communities (67 shown, 4 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3078def8`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- models.dart
- package:provider/provider.dart
- Yalla English Hub — Mobile Parity Design Spec
- Yalla English Hub — Mobile (Flutter)
- router.dart
- modals.dart
- onboarding_screen.dart
- reading_runner_screen.dart
- overview_screen.dart
- mock_api.dart
- ui.dart
- listening_runner_screen.dart
- app_colors.dart
- api_client.dart
- Global Constraints
- section_audio_player.dart
- app_config.dart
- AppState
- writing_hub_screen.dart
- writing_convert.dart
- package:flutter/material.dart
- Mobile Writing Runner — wired to backend — Design
- data.dart
- AppDelegate
- mock_exams_screen.dart
- server.mjs
- coach_screen.dart
- brand.dart
- login_screen.dart
- app_state.dart
- auth_state.dart
- writing_editor_screen.dart
- speaking_screen.dart
- reading_hub_screen.dart
- question_group_view.dart
- full_exam_results_screen.dart
- Route /
- track_switcher.dart
- exam_convert.dart
- grading_overlay.dart
- AuthState
- achievements_screen.dart
- build
- manifest.json
- certificates_screen.dart
- feedback_list_screen.dart
- full_exam_screen.dart
- listening_loader_screen.dart
- StatelessWidget
- reading_loader_screen.dart
- ../models/models.dart
- Mobile Writing Runner (wired to backend) Implementation Plan
- visual_prompt.dart
- app_theme.dart
- ../../widgets/ui.dart
- build
- CustomPainter
- State
- MainActivity
- QuestionType
- SkillKey
- dashboard_screen.dart
- Yalla English Hub — Mobile Roadmap
- package:go_router/go_router.dart
- more_screen.dart
- Yalla mock API (env A)
- LaunchImage.imageset/README.md

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 74 edges
2. `AppState` - 37 edges
3. `Yalla English Hub — Mobile Parity Design Spec` - 12 edges
4. `Global Constraints` - 11 edges
5. `build` - 10 edges
6. `Mobile Writing Runner — wired to backend — Design` - 10 edges
7. `Mobile Writing Runner (wired to backend) Implementation Plan` - 9 edges
8. `build` - 6 edges
9. `Yalla English Hub — Mobile (Flutter)` - 6 edges
10. `Yalla English Hub — Mobile Roadmap` - 6 edges

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

## Communities (71 total, 4 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (157): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+149 more)

### Community 1 - "package:provider/provider.dart"
Cohesion: 0.05
Nodes (52): dart:convert, package:fluenta_mobile/config/app_config.dart, package:fluenta_mobile/features/auth/login_screen.dart, package:fluenta_mobile/features/dashboard/dashboard_screen.dart, package:fluenta_mobile/features/full_exam/full_exam_store.dart, package:fluenta_mobile/features/onboarding/onboarding_screen.dart, package:fluenta_mobile/features/overview/overview_screen.dart, package:fluenta_mobile/features/writing/visual_prompt.dart (+44 more)

### Community 2 - "Yalla English Hub — Mobile Parity Design Spec"
Cohesion: 0.12
Nodes (16): 10. Out of scope (this round), 11. Acceptance, 1. Why this work exists, 2. Decisions locked in brainstorming, 3.1 Data & config layer (new), 3.2 State & bootstrap, 3.3 Navigation (4-tab shell), 3.4 Models (+8 more)

### Community 3 - "Yalla English Hub — Mobile (Flutter)"
Cohesion: 0.20
Nodes (9): Android emulator on the laptop, Flutter web at phone size (laptop preview / quick test), Layout, Local verification without the Java backend, Physical Android phone (primary demo) over WiFi, Run, Tests, What's implemented (+1 more)

### Community 4 - "router.dart"
Cohesion: 0.06
Nodes (35): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+27 more)

### Community 5 - "modals.dart"
Cohesion: 0.07
Nodes (31): DateTime get, _band, _category, confirmLabel, context, createState, _date, _days (+23 more)

### Community 6 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 7 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 8 - "overview_screen.dart"
Cohesion: 0.07
Nodes (27): _activityRow, _band, color, createState, _future, _hero, _heroDivider, _heroTile (+19 more)

### Community 9 - "mock_api.dart"
Cohesion: 0.07
Nodes (28): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+20 more)

### Community 10 - "ui.dart"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, action, bg, border, child, color (+19 more)

### Community 11 - "listening_runner_screen.dart"
Cohesion: 0.07
Nodes (27): ../full_exam/full_exam_store.dart, _answered, _answers, _bottomBar, createState, dispose, exam, examId (+19 more)

### Community 12 - "app_colors.dart"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, AppColors (+18 more)

### Community 13 - "api_client.dart"
Cohesion: 0.05
Nodes (37): Client, ../config/app_config.dart, dart:io, Exception, app, auth, build, config (+29 more)

### Community 14 - "Global Constraints"
Cohesion: 0.14
Nodes (13): Global Constraints, Self-Review, Task 10: Phase wrap — end-to-end verification against the stub + graphify refresh, Task 1: Add dependencies + graphify baseline, Task 2: AppConfig — persisted Server URL + token, Task 3: FluentaUser + Streak JSON (de)serialization, Task 4: ApiException + ApiClient (core request + auth/me), Task 5: AuthState (bootstrap / login / logout) (+5 more)

### Community 15 - "section_audio_player.dart"
Cohesion: 0.08
Nodes (25): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+17 more)

### Community 16 - "app_config.dart"
Cohesion: 0.13
Nodes (14): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+6 more)

### Community 17 - "AppState"
Cohesion: 0.16
Nodes (13): ChangeNotifier, build, build, _Item, lockKey, PracticeHubScreen, route, soon (+5 more)

### Community 18 - "writing_hub_screen.dart"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 19 - "writing_convert.dart"
Cohesion: 0.08
Nodes (22): a, block, _chartVisual, _formalityKind, g, minWords, out, prompt (+14 more)

### Community 20 - "package:flutter/material.dart"
Cohesion: 0.12
Nodes (21): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, build, HelpScreen, ListeningResultsScreen, ReadingResultsScreen (+13 more)

### Community 21 - "Mobile Writing Runner — wired to backend — Design"
Cohesion: 0.12
Nodes (15): Architecture (all in `fluenta-mobile`), Data caveat, Decisions (from brainstorming), Editor, Error handling & edge cases, Follow-ups (post-implementation), Goal, Hub (+7 more)

### Community 22 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 23 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 24 - "mock_exams_screen.dart"
Cohesion: 0.12
Nodes (18): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+10 more)

### Community 25 - "server.mjs"
Cohesion: 0.11
Nodes (12): achievements, certificates, exams, feedback, lessons, me, overview, plans (+4 more)

### Community 26 - "coach_screen.dart"
Cohesion: 0.14
Nodes (14): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+6 more)

### Community 27 - "brand.dart"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 28 - "login_screen.dart"
Cohesion: 0.12
Nodes (16): build, _busy, createState, dispose, _email, _fillDemo, initState, LoginScreen (+8 more)

### Community 29 - "app_state.dart"
Cohesion: 0.11
Nodes (17): auth_state.dart, bool get, FluentaUser? get, _auth, bind, clearExamDate, effectivePlan, isLocked (+9 more)

### Community 30 - "auth_state.dart"
Cohesion: 0.12
Nodes (16): BootStatus get, FluentaUser, ApiClient, api, BootStatus, bootstrap, config, _error (+8 more)

### Community 31 - "writing_editor_screen.dart"
Cohesion: 0.13
Nodes (14): int get, build, _controller, createState, dispose, initState, _submit, task (+6 more)

### Community 32 - "speaking_screen.dart"
Cohesion: 0.08
Nodes (24): _clips, createState, dispose, _elapsed, initState, _loadParts, _part, _parts (+16 more)

### Community 33 - "reading_hub_screen.dart"
Cohesion: 0.14
Nodes (14): IconData?, build, createState, _featured, _future, icon, initState, _load (+6 more)

### Community 34 - "question_group_view.dart"
Cohesion: 0.14
Nodes (13): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+5 more)

### Community 35 - "full_exam_results_screen.dart"
Cohesion: 0.33
Nodes (6): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, ../services/api_client.dart

### Community 36 - "Route /"
Cohesion: 0.29
Nodes (7): build, build, build, build, initState, Route /, Route /listening

### Community 37 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 38 - "exam_convert.dart"
Cohesion: 0.15
Nodes (12): _group, listeningExamFromContent, _listeningSection, map, _options, _passage, passages, _question (+4 more)

### Community 39 - "grading_overlay.dart"
Cohesion: 0.18
Nodes (11): dart:async, build, createState, dispose, _GradingDialog, _GradingDialogState, initState, _pct (+3 more)

### Community 40 - "AuthState"
Cohesion: 0.20
Nodes (14): build, OfflineScreen, build, _busy, _c, createState, dispose, initState (+6 more)

### Community 41 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 42 - "build"
Cohesion: 0.18
Nodes (11): _generateCertificate, build, _plan, build, Route /achievements, Route /certificates, Route /checkout, Route /feedback (+3 more)

### Community 43 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 44 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): Future, build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState (+1 more)

### Community 45 - "feedback_list_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 46 - "full_exam_screen.dart"
Cohesion: 0.20
Nodes (10): full_exam_store.dart, build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored (+2 more)

### Community 47 - "listening_loader_screen.dart"
Cohesion: 0.25
Nodes (8): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, listening_runner_screen.dart

### Community 48 - "StatelessWidget"
Cohesion: 0.20
Nodes (10): _StepHeader, EmptyStateView, FluentaCard, GradientCard, LockPill, PillBadge, ProgressRing, SectionHeader (+2 more)

### Community 49 - "reading_loader_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart (+1 more)

### Community 50 - "../models/models.dart"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ReadingExam (+1 more)

### Community 51 - "Mobile Writing Runner (wired to backend) Implementation Plan"
Cohesion: 0.20
Nodes (9): File Structure, Global Constraints, Mobile Writing Runner (wired to backend) Implementation Plan, Self-Review, Task 1: Model fields + writing converter, Task 2: VisualPrompt widget, Task 3: Editor — consume task, render visual + bullets, fix pre-fill, Task 4: Hub — fetch published writing exams (+1 more)

### Community 52 - "visual_prompt.dart"
Cohesion: 0.25
Nodes (7): build, paint, _series, shouldRepaint, visual, VisualPrompt, String?

### Community 53 - "app_theme.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, buildAppTheme, scheme, textTheme, package:google_fonts/google_fonts.dart

### Community 54 - "../../widgets/ui.dart"
Cohesion: 0.20
Nodes (9): build, createState, _selected, build, createState, _filter, _kindIcon, ../mock/data.dart (+1 more)

### Community 55 - "build"
Cohesion: 0.20
Nodes (11): build, _submit, build, _submit, build, Route /coach, Route /full-exam, Route /progress (+3 more)

### Community 56 - "CustomPainter"
Cohesion: 0.50
Nodes (4): CustomPainter, _SeriesChartPainter, _LineChartPainter, _RingPainter

### Community 57 - "State"
Cohesion: 0.27
Nodes (10): CheckoutScreen, _CheckoutScreenState, LessonsScreen, _LessonsScreenState, SectionAudioPlayer, _SectionAudioPlayerState, WritingEditorScreen, _WritingEditorScreenState (+2 more)

### Community 65 - "dashboard_screen.dart"
Cohesion: 0.22
Nodes (9): createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid, _StreakCard (+1 more)

### Community 66 - "Yalla English Hub — Mobile Roadmap"
Cohesion: 0.29
Nodes (6): Done (parity build + runners), Held product-wide (blocked on backend / product — same as web), Mobile-specific — next up, Notes / known environment issues, Release / distribution (before a public launch), Yalla English Hub — Mobile Roadmap

### Community 67 - "package:go_router/go_router.dart"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 68 - "more_screen.dart"
Cohesion: 0.40
Nodes (4): MoreScreen, _tile, ../state/app_state.dart, ../tracks/track_switcher.dart

### Community 69 - "Yalla mock API (env A)"
Cohesion: 0.50
Nodes (3): Routes, Run, Yalla mock API (env A)

## Knowledge Gaps
- **776 isolated node(s):** `XCTest`, `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs` (+771 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `modals.dart`, `onboarding_screen.dart`, `reading_runner_screen.dart`, `overview_screen.dart`, `listening_runner_screen.dart`, `api_client.dart`, `AppState`, `writing_hub_screen.dart`, `coach_screen.dart`, `login_screen.dart`, `app_state.dart`, `auth_state.dart`, `writing_editor_screen.dart`, `speaking_screen.dart`, `reading_hub_screen.dart`, `full_exam_results_screen.dart`, `track_switcher.dart`, `achievements_screen.dart`, `build`, `certificates_screen.dart`, `feedback_list_screen.dart`, `listening_loader_screen.dart`, `reading_loader_screen.dart`, `build`, `State`, `more_screen.dart`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `AppState` connect `AppState` to `speaking_screen.dart`, `dashboard_screen.dart`, `full_exam_results_screen.dart`, `more_screen.dart`, `modals.dart`, `overview_screen.dart`, `AuthState`, `build`, `api_client.dart`, `full_exam_screen.dart`, `writing_hub_screen.dart`, `build`, `app_state.dart`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Why does `ReadingExam` connect `../models/models.dart` to `models.dart`, `reading_runner_screen.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **What connects `XCTest`, `serverUrlKey`, `tokenKey` to the rest of the system?**
  _776 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012658227848101266 - nodes in this community are weakly interconnected._
- **Should `package:provider/provider.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05311676909569798 - nodes in this community are weakly interconnected._
- **Should `Yalla English Hub — Mobile Parity Design Spec` be split into smaller, more focused modules?**
  _Cohesion score 0.11764705882352941 - nodes in this community are weakly interconnected._