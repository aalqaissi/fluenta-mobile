# Graph Report - D:\personal\fluenta-mobile  (2026-09-12)

## Corpus Check
- Corpus is ~47,551 words - fits in a single context window. You may not need a graph.

## Summary
- 1133 nodes · 1741 edges · 68 communities (64 shown, 4 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.85)
- Token cost: 164,456 input · 0 output

## Community Hubs (Navigation)
- models.dart
- overview_screen_test.dart
- router.dart
- mock_api.dart
- overview_screen.dart
- modals.dart
- onboarding_screen.dart
- reading_runner_screen.dart
- ui.dart
- app_colors.dart
- section_audio_player.dart
- ../theme/app_colors.dart
- listening_runner_screen.dart
- api_client.dart
- data.dart
- AppDelegate
- listening_loader_screen.dart
- server.mjs
- app_state.dart
- auth_state.dart
- AuthState
- reading_hub_screen.dart
- app_config.dart
- speaking_screen.dart
- writing_editor_screen.dart
- fluenta_mobile pubspec.yaml
- Yalla English Hub Mobile Roadmap
- Yalla Mobile Parity Design Spec
- coach_screen.dart
- track_switcher.dart
- exam_convert.dart
- AppState
- grading_overlay.dart
- Yalla Mobile P0 Foundation Plan
- brand.dart
- login_screen.dart
- build
- full_exam_screen.dart
- achievements_screen.dart
- manifest.json
- main.dart
- Yalla English Hub Mobile README
- FluentaUser + Streak JSON Model
- certificates_screen.dart
- dashboard_screen.dart
- feedback_list_screen.dart
- State
- mock_exams_screen.dart
- StatelessWidget
- ../models/models.dart
- format.dart
- progress_screen.dart
- practice_hub_screen.dart
- package:flutter/material.dart
- ../mock/data.dart
- full_exam_results_screen.dart
- lessons_screen.dart
- package:go_router/go_router.dart
- _submit
- package:provider/provider.dart
- MainActivity
- _ReadingRunnerScreenState
- QuestionType
- SkillKey

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 65 edges
2. `AppState` - 38 edges
3. `Yalla English Hub Mobile README` - 19 edges
4. `Yalla Mobile Parity Design Spec` - 18 edges
5. `Yalla Mobile P0 Foundation Plan` - 16 edges
6. `fluenta_mobile pubspec.yaml` - 12 edges
7. `build` - 10 edges
8. `AuthState + BootStatus` - 10 edges
9. `ApiClient + ApiException` - 9 edges
10. `Yalla English Hub Mobile Roadmap` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Bootstrap Gate: Splash/Offline + Router Redirect` --implements--> `buildRouter`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/router.dart
- `AuthState + BootStatus` --implements--> `BootStatus`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/state/auth_state.dart
- `AppConfig (persisted Server URL + token)` --implements--> `AppConfig`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/config/app_config.dart
- `Login Screen Wired to API` --implements--> `LoginScreen`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/features/auth/login_screen.dart
- `Bootstrap Gate: Splash/Offline + Router Redirect` --implements--> `OfflineScreen`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/features/bootstrap/offline_screen.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **P0 Data + Auth + Bootstrap Flow** — docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_appconfig, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_apiclient, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_authstate, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_bootstrap_gate [EXTRACTED 1.00]
- **Reusable Media Upload/Playback Pipeline** — docs_roadmap_real_listening_audio, docs_roadmap_media_upload_pipeline, docs_roadmap_real_audio_for_speaking [INFERRED 0.80]
- **Two-Environment Verification Strategy (env A stub / env B real backend)** — docs_superpowers_specs_2026_09_11_yalla_mobile_parity_design_environments_risks, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_node_stub_server, readme_node_stub_api [INFERRED 0.75]

## Communities (68 total, 4 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (153): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+145 more)

### Community 1 - "overview_screen_test.dart"
Cohesion: 0.07
Nodes (40): dart:convert, package:fluenta_mobile/config/app_config.dart, package:fluenta_mobile/features/auth/login_screen.dart, package:fluenta_mobile/features/full_exam/full_exam_store.dart, package:fluenta_mobile/features/onboarding/onboarding_screen.dart, package:fluenta_mobile/features/overview/overview_screen.dart, package:fluenta_mobile/models/models.dart, package:fluenta_mobile/router.dart (+32 more)

### Community 2 - "router.dart"
Cohesion: 0.04
Nodes (47): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+39 more)

### Community 3 - "mock_api.dart"
Cohesion: 0.05
Nodes (40): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+32 more)

### Community 4 - "overview_screen.dart"
Cohesion: 0.06
Nodes (32): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+24 more)

### Community 5 - "modals.dart"
Cohesion: 0.06
Nodes (32): DateTime get, _band, build, _category, confirmLabel, context, createState, _date (+24 more)

### Community 6 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 7 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (28): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+20 more)

### Community 8 - "ui.dart"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, action, bg, border, child, color (+19 more)

### Community 9 - "app_colors.dart"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, AppColors (+18 more)

### Community 10 - "section_audio_player.dart"
Cohesion: 0.08
Nodes (25): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+17 more)

### Community 11 - "../theme/app_colors.dart"
Cohesion: 0.12
Nodes (20): config/brand.dart, ../exam/question_group_view.dart, build, SplashScreen, build, HelpScreen, ListeningResultsScreen, ReadingResultsScreen (+12 more)

### Community 12 - "listening_runner_screen.dart"
Cohesion: 0.08
Nodes (24): ../full_exam/full_exam_store.dart, _answered, _answers, _bottomBar, createState, dispose, exam, examId (+16 more)

### Community 13 - "api_client.dart"
Cohesion: 0.08
Nodes (23): Client, Exception, ApiException, config, createCertificate, createFeedback, getAchievements, getAttempt (+15 more)

### Community 14 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 15 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 16 - "listening_loader_screen.dart"
Cohesion: 0.12
Nodes (18): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, build (+10 more)

### Community 17 - "server.mjs"
Cohesion: 0.11
Nodes (12): achievements, certificates, exams, feedback, lessons, me, overview, plans (+4 more)

### Community 18 - "app_state.dart"
Cohesion: 0.12
Nodes (16): auth_state.dart, bool get, _auth, bind, clearExamDate, effectivePlan, isLocked, isPro (+8 more)

### Community 19 - "auth_state.dart"
Cohesion: 0.12
Nodes (15): BootStatus get, FluentaUser? get, ApiClient, api, BootStatus, bootstrap, config, _error (+7 more)

### Community 20 - "AuthState"
Cohesion: 0.20
Nodes (14): build, OfflineScreen, build, _busy, _c, createState, dispose, initState (+6 more)

### Community 21 - "reading_hub_screen.dart"
Cohesion: 0.14
Nodes (14): IconData?, build, createState, _featured, _future, icon, initState, _load (+6 more)

### Community 22 - "app_config.dart"
Cohesion: 0.13
Nodes (14): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+6 more)

### Community 23 - "speaking_screen.dart"
Cohesion: 0.14
Nodes (14): createState, dispose, _done, _elapsed, initState, _loadParts, _part, _parts (+6 more)

### Community 24 - "writing_editor_screen.dart"
Cohesion: 0.14
Nodes (13): int get, build, _controller, createState, dispose, initState, _submit, task (+5 more)

### Community 25 - "fluenta_mobile pubspec.yaml"
Cohesion: 0.15
Nodes (13): Analysis Options Config, flutter_lints Recommended Lint Set, Launch Screen Assets (iOS), fluenta_mobile pubspec.yaml, cupertino_icons, flutter_lints, Flutter SDK, go_router (+5 more)

### Community 26 - "Yalla English Hub Mobile Roadmap"
Cohesion: 0.17
Nodes (13): Yalla English Hub Mobile Roadmap, Gradle/Kotlin Daemon Loopback Proxy Issue, Lessons from the API (GET /api/lessons), Media Upload/Playback Pipeline (POST /api/media → /media/** → audioUrl), Mobile Polish (cards, empty/error states, accessibility, dark mode), Real Audio for Speaking Prompts, Real Listening Audio, Release / Distribution Checklist (+5 more)

### Community 27 - "Yalla Mobile Parity Design Spec"
Cohesion: 0.15
Nodes (13): graphify Standing Rule, Yalla Mobile Parity Design Spec, Acceptance Criteria (§11), Student API Surface (§6), Brand Rebrand Decision (Yalla English Hub), Build Phasing P0–P6 (§7), Warm Material 3 Design System (§4), fluenta-web src/lib/api.ts (+5 more)

### Community 28 - "coach_screen.dart"
Cohesion: 0.17
Nodes (12): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+4 more)

### Community 29 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 30 - "exam_convert.dart"
Cohesion: 0.15
Nodes (12): _group, listeningExamFromContent, _listeningSection, map, _options, _passage, passages, _question (+4 more)

### Community 31 - "AppState"
Cohesion: 0.23
Nodes (10): ChangeNotifier, MoreScreen, _tile, build, build, WritingHubScreen, AppState, ../state/app_state.dart (+2 more)

### Community 32 - "grading_overlay.dart"
Cohesion: 0.18
Nodes (11): dart:async, build, createState, dispose, _GradingDialog, _GradingDialogState, initState, _pct (+3 more)

### Community 33 - "Yalla Mobile P0 Foundation Plan"
Cohesion: 0.35
Nodes (12): Yalla Mobile P0 Foundation Plan, ApiClient + ApiException, AppConfig (persisted Server URL + token), AppState Delegates to AuthState, AuthState + BootStatus, Bootstrap Gate: Splash/Offline + Router Redirect, Login Screen Wired to API, TDD Task-by-Task Workflow (subagent-driven-development) (+4 more)

### Community 34 - "brand.dart"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 35 - "login_screen.dart"
Cohesion: 0.18
Nodes (11): build, _busy, createState, dispose, _email, initState, LoginScreen, _LoginScreenState (+3 more)

### Community 36 - "build"
Cohesion: 0.17
Nodes (12): build, _generateCertificate, build, _plan, build, Route /achievements, Route /certificates, Route /checkout (+4 more)

### Community 37 - "full_exam_screen.dart"
Cohesion: 0.20
Nodes (10): full_exam_store.dart, build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored (+2 more)

### Community 38 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 39 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 40 - "main.dart"
Cohesion: 0.20
Nodes (9): ../config/app_config.dart, app, auth, build, config, FluentaApp, main, router.dart (+1 more)

### Community 41 - "Yalla English Hub Mobile README"
Cohesion: 0.20
Nodes (10): AI Held Items (Coach/Writing/Speaking/Live Interview), Yalla English Hub Mobile README, AI Features Held (Coach/Writing/Speaking/Live Interview → 501), Connectivity/Auth Bootstrap Gate, Fluenta → Yalla English Hub Rebrand, Reading Runner (server-scored attempts), Persisted, Editable Server URL, Speaking (Standard + Live Interview coming soon) (+2 more)

### Community 42 - "FluentaUser + Streak JSON Model"
Cohesion: 0.20
Nodes (10): FluentaUser + Streak JSON Model, http.testing.MockClient Test Pattern, Node Stub API Server (env A), Environments, Prerequisites & Risks (§9), Backend DTO Models (§3.4), FluentaUser, Streak, Node Mock API Stub (tools/mock-api/server.mjs) (+2 more)

### Community 43 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): Future, build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState (+1 more)

### Community 44 - "dashboard_screen.dart"
Cohesion: 0.22
Nodes (9): createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid, _StreakCard (+1 more)

### Community 45 - "feedback_list_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 46 - "State"
Cohesion: 0.27
Nodes (10): ListeningRunnerScreen, _ListeningRunnerScreenState, SectionAudioPlayer, _SectionAudioPlayerState, WritingEditorScreen, _WritingEditorScreenState, WritingResultsScreen, _WritingResultsScreenState (+2 more)

### Community 47 - "mock_exams_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+1 more)

### Community 48 - "StatelessWidget"
Cohesion: 0.20
Nodes (10): _StepHeader, EmptyStateView, FluentaCard, GradientCard, LockPill, PillBadge, ProgressRing, SectionHeader (+2 more)

### Community 49 - "../models/models.dart"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ReadingExam (+1 more)

### Community 50 - "format.dart"
Cohesion: 0.20
Nodes (9): cefrForBand, days, formatBand, longDate, months, n, pad2, prettyDate (+1 more)

### Community 51 - "progress_screen.dart"
Cohesion: 0.25
Nodes (8): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard, List

### Community 52 - "practice_hub_screen.dart"
Cohesion: 0.25
Nodes (7): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,

### Community 53 - "package:flutter/material.dart"
Cohesion: 0.29
Nodes (6): app_colors.dart, buildAppTheme, scheme, textTheme, package:flutter/material.dart, package:google_fonts/google_fonts.dart

### Community 54 - "../mock/data.dart"
Cohesion: 0.33
Nodes (6): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, ../mock/data.dart

### Community 55 - "full_exam_results_screen.dart"
Cohesion: 0.33
Nodes (6): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, ../services/api_client.dart

### Community 56 - "lessons_screen.dart"
Cohesion: 0.33
Nodes (6): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState

### Community 57 - "package:go_router/go_router.dart"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 58 - "_submit"
Cohesion: 0.40
Nodes (5): _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 59 - "package:provider/provider.dart"
Cohesion: 0.40
Nodes (4): package:fluenta_mobile/features/dashboard/dashboard_screen.dart, package:fluenta_mobile/theme/app_theme.dart, package:provider/provider.dart, main

## Knowledge Gaps
- **693 isolated node(s):** `XCTest`, `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs` (+688 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `overview_screen.dart`, `modals.dart`, `onboarding_screen.dart`, `reading_runner_screen.dart`, `listening_runner_screen.dart`, `listening_loader_screen.dart`, `app_state.dart`, `auth_state.dart`, `reading_hub_screen.dart`, `speaking_screen.dart`, `track_switcher.dart`, `AppState`, `Yalla Mobile P0 Foundation Plan`, `login_screen.dart`, `build`, `achievements_screen.dart`, `main.dart`, `certificates_screen.dart`, `feedback_list_screen.dart`, `State`, `full_exam_results_screen.dart`, `_submit`, `_ReadingRunnerScreenState`?**
  _High betweenness centrality (0.101) - this node is a cross-community bridge._
- **Why does `Yalla Mobile P0 Foundation Plan` connect `Yalla Mobile P0 Foundation Plan` to `main.dart`, `FluentaUser + Streak JSON Model`, `Yalla Mobile Parity Design Spec`?**
  _High betweenness centrality (0.047) - this node is a cross-community bridge._
- **Why does `Yalla Mobile Parity Design Spec` connect `Yalla Mobile Parity Design Spec` to `Yalla Mobile P0 Foundation Plan`, `Yalla English Hub Mobile Roadmap`, `FluentaUser + Streak JSON Model`, `Yalla English Hub Mobile README`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **What connects `XCTest`, `serverUrlKey`, `tokenKey` to the rest of the system?**
  _693 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012987012987012988 - nodes in this community are weakly interconnected._
- **Should `overview_screen_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.07390648567119155 - nodes in this community are weakly interconnected._
- **Should `router.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.04343971631205674 - nodes in this community are weakly interconnected._