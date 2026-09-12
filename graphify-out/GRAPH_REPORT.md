# Graph Report - D:\personal\fluenta-mobile  (2026-09-12)

## Corpus Check
- 122 files · ~53,220 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1269 nodes · 1934 edges · 77 communities (73 shown, 4 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 11 edges (avg confidence: 0.81)
- Token cost: 113,974 input · 0 output

## Community Hubs (Navigation)
- models.dart
- package:flutter_test/flutter_test.dart
- README.md (Mobile)
- router.dart
- modals.dart
- onboarding_screen.dart
- reading_runner_screen.dart
- ui.dart
- Yalla English Hub Mobile Roadmap
- app_colors.dart
- overview_screen.dart
- mock_api.dart
- listening_runner_screen.dart
- section_audio_player.dart
- app_config.dart
- api_client.dart
- writing_convert.dart
- data.dart
- AppDelegate
- app_state.dart
- server.mjs
- auth_state.dart
- AppState
- writing_editor_screen.dart
- speaking_screen.dart
- reading_hub_screen.dart
- login_screen.dart
- ../theme/app_colors.dart
- package:go_router/go_router.dart
- question_group_view.dart
- fluenta_mobile pubspec.yaml
- Yalla Mobile P0 Foundation Plan
- Yalla Mobile Parity Design Spec
- coach_screen.dart
- ../../widgets/ui.dart
- track_switcher.dart
- exam_convert.dart
- Mobile Writing Runner Implementation Pla
- Route /
- AuthState
- Mobile Writing Runner Design
- full_exam_screen.dart
- achievements_screen.dart
- package:flutter/material.dart
- mock_exams_screen.dart
- writing_hub_screen.dart
- manifest.json
- main.dart
- grading_overlay.dart
- certificates_screen.dart
- feedback_list_screen.dart
- listening_loader_screen.dart
- State
- StatelessWidget
- reading_loader_screen.dart
- ../models/models.dart
- progress_screen.dart
- Writing Runner Wired to Backend
- FluentaUser + Streak JSON Model
- build
- practice_hub_screen.dart
- visual_prompt.dart
- ../mock/data.dart
- lessons_screen.dart
- app_theme.dart
- Bootstrap Gate: Splash/Offline + Router 
- _submit
- CustomPainter
- Real Listening Audio Pipeline
- MainActivity
- build
- QuestionType
- SkillKey

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 68 edges
2. `README.md (Mobile)` - 49 edges
3. `AppState` - 38 edges
4. `Yalla English Hub Mobile Roadmap` - 34 edges
5. `Mobile Writing Runner Implementation Plan` - 20 edges
6. `Yalla Mobile P0 Foundation Plan` - 16 edges
7. `Yalla Mobile Parity Design Spec` - 16 edges
8. `Mobile Writing Runner Design` - 14 edges
9. `fluenta_mobile pubspec.yaml` - 12 edges
10. `build` - 10 edges

## Surprising Connections (you probably didn't know these)
- `AuthState + BootStatus` --implements--> `BootStatus`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/state/auth_state.dart
- `AppConfig (persisted Server URL + token)` --implements--> `AppConfig`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/config/app_config.dart
- `Yalla Mobile P0 Foundation Plan` --references--> `FluentaApp`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/main.dart
- `FluentaUser + Streak JSON Model` --implements--> `Streak`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/models/models.dart
- `Bootstrap Gate: Splash/Offline + Router Redirect` --implements--> `buildRouter`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/router.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **P0 Data + Auth + Bootstrap Flow** — docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_appconfig, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_apiclient, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_authstate, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_bootstrap_gate [EXTRACTED 1.00]
- **Two-Environment Verification Strategy (env A stub / env B real backend)** — docs_superpowers_specs_2026_09_11_yalla_mobile_parity_design_environments_risks, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_node_stub_server [INFERRED 0.75]

## Communities (77 total, 4 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (153): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+145 more)

### Community 1 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.06
Nodes (47): dart:convert, package:fluenta_mobile/config/app_config.dart, package:fluenta_mobile/features/auth/login_screen.dart, package:fluenta_mobile/features/full_exam/full_exam_store.dart, package:fluenta_mobile/features/onboarding/onboarding_screen.dart, package:fluenta_mobile/features/overview/overview_screen.dart, package:fluenta_mobile/features/writing/visual_prompt.dart, package:fluenta_mobile/features/writing/writing_editor_screen.dart (+39 more)

### Community 2 - "README.md (Mobile)"
Cohesion: 0.06
Nodes (50): Achievements, AI Features Held, Android Emulator (10.0.2.2), Physical Android Phone Demo over WiFi, ApiClient, APK Build (flutter build apk), AppState, AuthState (+42 more)

### Community 3 - "router.dart"
Cohesion: 0.06
Nodes (34): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+26 more)

### Community 4 - "modals.dart"
Cohesion: 0.06
Nodes (32): DateTime get, _band, build, _category, confirmLabel, context, createState, _date (+24 more)

### Community 5 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 6 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (28): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+20 more)

### Community 7 - "ui.dart"
Cohesion: 0.07
Nodes (27): Border?, dart:math, EdgeInsetsGeometry, action, bg, border, child, color (+19 more)

### Community 8 - "Yalla English Hub Mobile Roadmap"
Cohesion: 0.07
Nodes (28): Achievements, Certificates, Feedback, Track Switcher, AI Coach Chat, AI Live Interview, AI Speaking Feedback, App Icon, Backend Firewall / Cleartext HTTP Requirement, Backend Wiring (Server URL, ApiClient, Bootstrap Gate), Yalla English Hub Mobile Roadmap (+20 more)

### Community 9 - "app_colors.dart"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, AppColors (+18 more)

### Community 10 - "overview_screen.dart"
Cohesion: 0.07
Nodes (27): _activityRow, _band, color, createState, _future, _hero, _heroDivider, _heroTile (+19 more)

### Community 11 - "mock_api.dart"
Cohesion: 0.07
Nodes (27): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+19 more)

### Community 12 - "listening_runner_screen.dart"
Cohesion: 0.08
Nodes (26): ../full_exam/full_exam_store.dart, _answered, _answers, _bottomBar, createState, dispose, exam, examId (+18 more)

### Community 13 - "section_audio_player.dart"
Cohesion: 0.08
Nodes (25): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+17 more)

### Community 14 - "app_config.dart"
Cohesion: 0.08
Nodes (24): defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey, setServerUrl (+16 more)

### Community 15 - "api_client.dart"
Cohesion: 0.08
Nodes (23): Client, Exception, ApiException, config, createCertificate, createFeedback, getAchievements, getAttempt (+15 more)

### Community 16 - "writing_convert.dart"
Cohesion: 0.08
Nodes (22): a, block, _chartVisual, _formalityKind, g, minWords, out, prompt (+14 more)

### Community 17 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 18 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 19 - "app_state.dart"
Cohesion: 0.11
Nodes (17): auth_state.dart, bool get, FluentaUser? get, _auth, bind, clearExamDate, effectivePlan, isLocked (+9 more)

### Community 20 - "server.mjs"
Cohesion: 0.11
Nodes (12): achievements, certificates, exams, feedback, lessons, me, overview, plans (+4 more)

### Community 21 - "auth_state.dart"
Cohesion: 0.12
Nodes (16): BootStatus get, AppConfig, ApiClient, api, BootStatus, bootstrap, config, _error (+8 more)

### Community 22 - "AppState"
Cohesion: 0.18
Nodes (15): ChangeNotifier, build, createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState (+7 more)

### Community 23 - "writing_editor_screen.dart"
Cohesion: 0.12
Nodes (15): int get, build, _controller, createState, dispose, initState, _submit, task (+7 more)

### Community 24 - "speaking_screen.dart"
Cohesion: 0.13
Nodes (15): build, createState, dispose, _done, _elapsed, initState, _loadParts, _part (+7 more)

### Community 25 - "reading_hub_screen.dart"
Cohesion: 0.14
Nodes (14): IconData?, build, createState, _featured, _future, icon, initState, _load (+6 more)

### Community 26 - "login_screen.dart"
Cohesion: 0.13
Nodes (14): build, _busy, createState, dispose, _email, _fillDemo, initState, _name (+6 more)

### Community 27 - "../theme/app_colors.dart"
Cohesion: 0.16
Nodes (12): config/brand.dart, build, _annotated, createState, _crit, _critColor, _feedback, result (+4 more)

### Community 28 - "package:go_router/go_router.dart"
Cohesion: 0.18
Nodes (11): ../exam/question_group_view.dart, ListeningResultsScreen, ReadingResultsScreen, AppShell, build, navigationShell, ../mock/passages.dart, package:go_router/go_router.dart (+3 more)

### Community 29 - "question_group_view.dart"
Cohesion: 0.14
Nodes (13): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+5 more)

### Community 30 - "fluenta_mobile pubspec.yaml"
Cohesion: 0.15
Nodes (13): Analysis Options Config, flutter_lints Recommended Lint Set, Launch Screen Assets (iOS), fluenta_mobile pubspec.yaml, cupertino_icons, flutter_lints, Flutter SDK, go_router (+5 more)

### Community 31 - "Yalla Mobile P0 Foundation Plan"
Cohesion: 0.29
Nodes (13): Yalla Mobile P0 Foundation Plan, ApiClient + ApiException, AppConfig (persisted Server URL + token), AppState Delegates to AuthState, AuthState + BootStatus, Login Screen Wired to API, http.testing.MockClient Test Pattern, TDD Task-by-Task Workflow (subagent-driven-development) (+5 more)

### Community 32 - "Yalla Mobile Parity Design Spec"
Cohesion: 0.15
Nodes (13): graphify Standing Rule, Yalla Mobile Parity Design Spec, Acceptance Criteria (§11), Student API Surface (§6), Brand Rebrand Decision (Yalla English Hub), Build Phasing P0–P6 (§7), Warm Material 3 Design System (§4), fluenta-web src/lib/api.ts (+5 more)

### Community 33 - "coach_screen.dart"
Cohesion: 0.17
Nodes (12): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+4 more)

### Community 34 - "../../widgets/ui.dart"
Cohesion: 0.19
Nodes (11): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, MoreScreen, _tile, ../state/app_state.dart (+3 more)

### Community 35 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 36 - "exam_convert.dart"
Cohesion: 0.15
Nodes (12): _group, listeningExamFromContent, _listeningSection, map, _options, _passage, passages, _question (+4 more)

### Community 37 - "Mobile Writing Runner Implementation Pla"
Cohesion: 0.24
Nodes (12): Gradle/Kotlin Daemon Loopback Issue, Branch feat/mobile-writing-runner, Chart-Type to Visual Mapping, Writing Task Defaults (minWords/duration), Mobile Writing Runner Implementation Plan, superpowers:executing-plans Skill, Formality to Kind Mapping, superpowers:subagent-driven-development Skill (+4 more)

### Community 38 - "Route /"
Cohesion: 0.18
Nodes (12): build, build, build, build, build, build, initState, Route / (+4 more)

### Community 39 - "AuthState"
Cohesion: 0.26
Nodes (11): build, _busy, _c, createState, dispose, initState, _saveAndReconnect, _ServerUrlCard (+3 more)

### Community 40 - "Mobile Writing Runner Design"
Cohesion: 0.20
Nodes (11): Router extra Passing (writing task), WritingEditorScreen Changes, WritingHubScreen Fetch Published Exams, Architecture: Editor, Architecture: Hub, Architecture: Router, Mobile Writing Runner Design, Error Handling & Edge Cases (+3 more)

### Community 41 - "full_exam_screen.dart"
Cohesion: 0.20
Nodes (10): full_exam_store.dart, build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored (+2 more)

### Community 42 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 43 - "package:flutter/material.dart"
Cohesion: 0.20
Nodes (8): build, build, HelpScreen, package:fluenta_mobile/features/dashboard/dashboard_screen.dart, package:fluenta_mobile/theme/app_theme.dart, package:flutter/material.dart, package:provider/provider.dart, main

### Community 44 - "mock_exams_screen.dart"
Cohesion: 0.20
Nodes (10): build, createState, _items, MockExamsScreen, _MockExamsScreenState, _part, _type, _uploadSheet (+2 more)

### Community 45 - "writing_hub_screen.dart"
Cohesion: 0.20
Nodes (10): _authored, build, _card, createState, initState, _load, _loading, WritingHubScreen (+2 more)

### Community 46 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 47 - "main.dart"
Cohesion: 0.20
Nodes (9): ../config/app_config.dart, app, auth, build, config, FluentaApp, main, router.dart (+1 more)

### Community 48 - "grading_overlay.dart"
Cohesion: 0.20
Nodes (9): dart:async, build, createState, dispose, initState, _pct, showGradingDialog, _timer (+1 more)

### Community 49 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): Future, build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState (+1 more)

### Community 50 - "feedback_list_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 51 - "listening_loader_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, listening_runner_screen.dart (+1 more)

### Community 52 - "State"
Cohesion: 0.27
Nodes (10): SectionAudioPlayer, _SectionAudioPlayerState, ReadingRunnerScreen, _ReadingRunnerScreenState, WritingEditorScreen, _WritingEditorScreenState, _GradingDialog, _GradingDialogState (+2 more)

### Community 53 - "StatelessWidget"
Cohesion: 0.20
Nodes (10): _StepHeader, EmptyStateView, FluentaCard, GradientCard, LockPill, PillBadge, ProgressRing, SectionHeader (+2 more)

### Community 54 - "reading_loader_screen.dart"
Cohesion: 0.22
Nodes (9): build, createState, examId, full, initState, ReadingLoaderScreen, _ReadingLoaderScreenState, reading_runner_screen.dart (+1 more)

### Community 55 - "../models/models.dart"
Cohesion: 0.20
Nodes (9): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ReadingExam (+1 more)

### Community 56 - "progress_screen.dart"
Cohesion: 0.25
Nodes (8): build, createState, _exams, ProgressScreen, _ProgressScreenState, _statusChip, _summaryCard, ../../widgets/modals.dart

### Community 57 - "Writing Runner Wired to Backend"
Cohesion: 0.25
Nodes (8): AI Writing Feedback, Roles / Admin Gating, Writing Runner Wired to Backend, Task 5: Docs + Graphify Update, Data Caveat: seed-w1 Draft, Design Decisions (Visual, Module, Grading, Backend), Follow-Ups (Roadmap + Graphify), Out of Scope

### Community 58 - "FluentaUser + Streak JSON Model"
Cohesion: 0.25
Nodes (8): FluentaUser + Streak JSON Model, Node Stub API Server (env A), Environments, Prerequisites & Risks (§9), Backend DTO Models (§3.4), FluentaUser, Streak, Yalla Mock API (env A) README, Phase 0 Stub Routes

### Community 59 - "build"
Cohesion: 0.25
Nodes (8): _generateCertificate, build, Route /achievements, Route /certificates, Route /feedback, Route /help, Route /lessons, Route /settings

### Community 60 - "practice_hub_screen.dart"
Cohesion: 0.25
Nodes (7): build, _Item, lockKey, PracticeHubScreen, route, soon, String key, title, sub,

### Community 61 - "visual_prompt.dart"
Cohesion: 0.25
Nodes (7): build, paint, _series, shouldRepaint, visual, VisualPrompt, String?

### Community 62 - "../mock/data.dart"
Cohesion: 0.33
Nodes (6): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, ../mock/data.dart

### Community 63 - "lessons_screen.dart"
Cohesion: 0.33
Nodes (6): build, createState, _filter, _kindIcon, LessonsScreen, _LessonsScreenState

### Community 64 - "app_theme.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, buildAppTheme, scheme, textTheme, package:google_fonts/google_fonts.dart

### Community 65 - "Bootstrap Gate: Splash/Offline + Router "
Cohesion: 0.40
Nodes (5): Bootstrap Gate: Splash/Offline + Router Redirect, State & Bootstrap (§3.2), OfflineScreen, SplashScreen, buildRouter

### Community 66 - "_submit"
Cohesion: 0.40
Nodes (5): _submit, _submit, Route /full-exam, Route /results/listening, Route /results/reading

### Community 67 - "CustomPainter"
Cohesion: 0.50
Nodes (4): CustomPainter, _SeriesChartPainter, _LineChartPainter, _RingPainter

### Community 68 - "Real Listening Audio Pipeline"
Cohesion: 0.50
Nodes (4): Real Audio for Speaking Prompts, Real Listening Audio Pipeline, VisualPrompt Widget (Plan), Architecture: VisualPrompt Widget

## Knowledge Gaps
- **758 isolated node(s):** `XCTest`, `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs` (+753 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **4 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `modals.dart`, `onboarding_screen.dart`, `reading_runner_screen.dart`, `overview_screen.dart`, `listening_runner_screen.dart`, `app_state.dart`, `auth_state.dart`, `AppState`, `speaking_screen.dart`, `reading_hub_screen.dart`, `login_screen.dart`, `Yalla Mobile P0 Foundation Plan`, `../../widgets/ui.dart`, `track_switcher.dart`, `achievements_screen.dart`, `package:flutter/material.dart`, `writing_hub_screen.dart`, `main.dart`, `certificates_screen.dart`, `feedback_list_screen.dart`, `listening_loader_screen.dart`, `State`, `reading_loader_screen.dart`, `build`, `Bootstrap Gate: Splash/Offline + Router `, `_submit`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Why does `Yalla Mobile P0 Foundation Plan` connect `Yalla Mobile P0 Foundation Plan` to `Yalla Mobile Parity Design Spec`, `Bootstrap Gate: Splash/Offline + Router `, `FluentaUser + Streak JSON Model`, `main.dart`?**
  _High betweenness centrality (0.038) - this node is a cross-community bridge._
- **Why does `fluenta_mobile pubspec.yaml` connect `fluenta_mobile pubspec.yaml` to `Yalla Mobile P0 Foundation Plan`?**
  _High betweenness centrality (0.034) - this node is a cross-community bridge._
- **What connects `XCTest`, `serverUrlKey`, `tokenKey` to the rest of the system?**
  _758 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012987012987012988 - nodes in this community are weakly interconnected._
- **Should `package:flutter_test/flutter_test.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.05901639344262295 - nodes in this community are weakly interconnected._
- **Should `README.md (Mobile)` be split into smaller, more focused modules?**
  _Cohesion score 0.06285714285714286 - nodes in this community are weakly interconnected._