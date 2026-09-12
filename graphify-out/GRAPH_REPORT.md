# Graph Report - D:\personal\fluenta-mobile  (2026-09-12)

## Corpus Check
- Corpus is ~47,933 words - fits in a single context window. You may not need a graph.

## Summary
- 1208 nodes · 1868 edges · 66 communities (60 shown, 6 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS · INFERRED: 4 edges (avg confidence: 0.8)
- Token cost: 112,943 input · 0 output

## Community Hubs (Navigation)
- models.dart
- package:provider/provider.dart
- Yalla Mobile P0 Foundation Plan
- router.dart
- ui.dart
- api_client.dart
- overview_screen.dart
- onboarding_screen.dart
- modals.dart
- listening_runner_screen.dart
- reading_runner_screen.dart
- section_audio_player.dart
- app_colors.dart
- mock_api.dart
- ROADMAP.md (Mobile)
- package:flutter/material.dart
- README.md (Mobile)
- data.dart
- AppDelegate
- AppState
- listening_loader_screen.dart
- login_screen.dart
- server.mjs
- app_state.dart
- ../models/models.dart
- auth_state.dart
- reading_hub_screen.dart
- app_config.dart
- AuthState
- speaking_screen.dart
- writing_editor_screen.dart
- question_group_view.dart
- coach_screen.dart
- build
- track_switcher.dart
- exam_convert.dart
- grading_overlay.dart
- brand.dart
- ../mock/data.dart
- State
- Spring Boot Backend
- full_exam_screen.dart
- achievements_screen.dart
- manifest.json
- certificates_screen.dart
- dashboard_screen.dart
- feedback_list_screen.dart
- format.dart
- Held Prototype Features (password reset,
- passages.dart
- APK Build (flutter build apk)
- AI Features Held
- full_exam_results_screen.dart
- app_theme.dart
- package:go_router/go_router.dart
- Fill Demo Credentials button
- MainActivity
- Login-first + 4-step Onboarding
- Settings
- Track Switcher
- QuestionType
- SkillKey

## God Nodes (most connected - your core abstractions)
1. `AuthState` - 65 edges
2. `README.md (Mobile)` - 50 edges
3. `ROADMAP.md (Mobile)` - 43 edges
4. `AppState` - 38 edges
5. `Yalla Mobile P0 Foundation Plan` - 16 edges
6. `Yalla Mobile Parity Design Spec` - 16 edges
7. `fluenta_mobile pubspec.yaml` - 12 edges
8. `build` - 10 edges
9. `AuthState + BootStatus` - 9 edges
10. `ApiClient + ApiException` - 8 edges

## Surprising Connections (you probably didn't know these)
- `AppConfig (persisted Server URL + token)` --implements--> `AppConfig`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/config/app_config.dart
- `Yalla Mobile P0 Foundation Plan` --references--> `FluentaApp`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/main.dart
- `FluentaUser + Streak JSON Model` --implements--> `Streak`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/models/models.dart
- `Bootstrap Gate: Splash/Offline + Router Redirect` --implements--> `buildRouter`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/router.dart
- `ApiClient + ApiException` --implements--> `ApiException`  [EXTRACTED]
  docs/superpowers/plans/2026-09-11-yalla-mobile-p0-foundation.md → lib/services/api_client.dart

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **P0 Data + Auth + Bootstrap Flow** — docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_appconfig, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_apiclient, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_authstate, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_bootstrap_gate [EXTRACTED 1.00]
- **Two-Environment Verification Strategy (env A stub / env B real backend)** — docs_superpowers_specs_2026_09_11_yalla_mobile_parity_design_environments_risks, docs_superpowers_plans_2026_09_11_yalla_mobile_p0_foundation_node_stub_server [INFERRED 0.75]

## Communities (66 total, 6 thin omitted)

### Community 0 - "models.dart"
Cohesion: 0.01
Nodes (153): double?, int?, int points,, Achievement, AchievementDto, active, ActivityItem, adminReply (+145 more)

### Community 1 - "package:provider/provider.dart"
Cohesion: 0.07
Nodes (44): dart:convert, package:fluenta_mobile/config/app_config.dart, package:fluenta_mobile/features/auth/login_screen.dart, package:fluenta_mobile/features/dashboard/dashboard_screen.dart, package:fluenta_mobile/features/full_exam/full_exam_store.dart, package:fluenta_mobile/features/onboarding/onboarding_screen.dart, package:fluenta_mobile/features/overview/overview_screen.dart, package:fluenta_mobile/models/models.dart (+36 more)

### Community 2 - "Yalla Mobile P0 Foundation Plan"
Cohesion: 0.06
Nodes (50): Analysis Options Config, flutter_lints Recommended Lint Set, Yalla Mobile P0 Foundation Plan, ApiClient + ApiException, AppConfig (persisted Server URL + token), AppState Delegates to AuthState, AuthState + BootStatus, Bootstrap Gate: Splash/Offline + Router Redirect (+42 more)

### Community 3 - "router.dart"
Cohesion: 0.05
Nodes (45): features/achievements/achievements_screen.dart, features/auth/login_screen.dart, features/bootstrap/offline_screen.dart, features/bootstrap/splash_screen.dart, features/certificates/certificates_screen.dart, features/checkout/checkout_screen.dart, features/coach/coach_screen.dart, features/feedback/feedback_list_screen.dart (+37 more)

### Community 4 - "ui.dart"
Cohesion: 0.06
Nodes (37): Border?, dart:math, EdgeInsetsGeometry, _StepHeader, action, bg, border, child (+29 more)

### Community 5 - "api_client.dart"
Cohesion: 0.06
Nodes (32): Client, ../config/app_config.dart, Exception, app, auth, build, config, FluentaApp (+24 more)

### Community 6 - "overview_screen.dart"
Cohesion: 0.06
Nodes (32): CustomPainter, _activityRow, _band, build, color, createState, _future, _hero (+24 more)

### Community 7 - "onboarding_screen.dart"
Cohesion: 0.06
Nodes (31): Color?, DateTime?, _bands, build, _card, center, _choiceGrid, color (+23 more)

### Community 8 - "modals.dart"
Cohesion: 0.07
Nodes (31): DateTime get, _band, _category, confirmLabel, context, createState, _date, _days (+23 more)

### Community 9 - "listening_runner_screen.dart"
Cohesion: 0.06
Nodes (31): ../full_exam/full_exam_store.dart, _answered, _answers, _bottomBar, createState, dispose, exam, examId (+23 more)

### Community 10 - "reading_runner_screen.dart"
Cohesion: 0.07
Nodes (30): _activeColor, _answered, _answers, _bottomBar, _buildParagraphs, createState, dispose, exam (+22 more)

### Community 11 - "section_audio_player.dart"
Cohesion: 0.07
Nodes (27): AudioPlayer?, alreadyPlayed, audioUrl, build, createState, dispose, durationSec, _error (+19 more)

### Community 12 - "app_colors.dart"
Cohesion: 0.07
Nodes (26): allScoredDone, bands, FullExamStore, has, record, reset, scoredSkills, AppColors (+18 more)

### Community 13 - "mock_api.dart"
Cohesion: 0.07
Nodes (27): answer, answers, atProgress, AttemptStore, band, correct, durationUsedSec, GradingStep (+19 more)

### Community 14 - "ROADMAP.md (Mobile)"
Cohesion: 0.10
Nodes (26): Achievements, AI: Writing Feedback (held), App Icon, Certificates, ROADMAP.md (Mobile), Feedback (submit + list), Full Exam Orchestrator, iOS Build & Packaging (+18 more)

### Community 15 - "package:flutter/material.dart"
Cohesion: 0.13
Nodes (20): config/brand.dart, ../exam/question_group_view.dart, build, build, HelpScreen, ListeningResultsScreen, ReadingResultsScreen, _annotated (+12 more)

### Community 16 - "README.md (Mobile)"
Cohesion: 0.13
Nodes (22): Bootstrap Gate (splash/offline/login/onboarding), Overview Home, Vocabulary & Grammar Practice (held), Android Emulator (10.0.2.2), AppState, AuthState, Bootstrap Gate, Bottom Nav (Home/Practice/Coach/More) (+14 more)

### Community 17 - "data.dart"
Cohesion: 0.10
Nodes (20): achievements, certificates, coachReplyFor, coachSuggestions, currentUser, initialCoachMessages, lessons, listeningDemoGroup (+12 more)

### Community 18 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 19 - "AppState"
Cohesion: 0.14
Nodes (17): ChangeNotifier, MoreScreen, _tile, build, _Item, lockKey, PracticeHubScreen, route (+9 more)

### Community 20 - "listening_loader_screen.dart"
Cohesion: 0.12
Nodes (18): build, createState, examId, full, initState, ListeningLoaderScreen, _ListeningLoaderScreenState, build (+10 more)

### Community 21 - "login_screen.dart"
Cohesion: 0.12
Nodes (17): Login Screen Wired to API, build, _busy, createState, dispose, _email, _fillDemo, initState (+9 more)

### Community 22 - "server.mjs"
Cohesion: 0.11
Nodes (12): achievements, certificates, exams, feedback, lessons, me, overview, plans (+4 more)

### Community 23 - "app_state.dart"
Cohesion: 0.12
Nodes (16): auth_state.dart, bool get, _auth, bind, clearExamDate, effectivePlan, isLocked, isPro (+8 more)

### Community 24 - "../models/models.dart"
Cohesion: 0.13
Nodes (15): build, createState, _items, _part, _type, _uploadSheet, build, createState (+7 more)

### Community 25 - "auth_state.dart"
Cohesion: 0.12
Nodes (15): BootStatus get, FluentaUser? get, ApiClient, api, bootstrap, config, _error, isAuthed (+7 more)

### Community 26 - "reading_hub_screen.dart"
Cohesion: 0.14
Nodes (14): IconData?, build, createState, _featured, _future, icon, initState, _load (+6 more)

### Community 27 - "app_config.dart"
Cohesion: 0.13
Nodes (14): AppConfig, defaultServerUrl, load, mediaBase, _normalize, _prefs, serverUrl, serverUrlKey (+6 more)

### Community 28 - "AuthState"
Cohesion: 0.21
Nodes (13): build, build, _busy, _c, createState, dispose, initState, _saveAndReconnect (+5 more)

### Community 29 - "speaking_screen.dart"
Cohesion: 0.14
Nodes (14): createState, dispose, _done, _elapsed, initState, _loadParts, _part, _parts (+6 more)

### Community 30 - "writing_editor_screen.dart"
Cohesion: 0.14
Nodes (13): int get, build, _controller, createState, dispose, initState, _submit, task (+5 more)

### Community 31 - "question_group_view.dart"
Cohesion: 0.14
Nodes (13): answers, build, _choiceTypes, group, _input, _pill, _questionCard, QuestionGroupView (+5 more)

### Community 32 - "coach_screen.dart"
Cohesion: 0.17
Nodes (12): _bubble, build, CoachScreen, _CoachScreenState, _composer, _controller, createState, dispose (+4 more)

### Community 33 - "build"
Cohesion: 0.15
Nodes (13): build, _generateCertificate, build, _plan, build, Route /achievements, Route /certificates, Route /checkout (+5 more)

### Community 34 - "track_switcher.dart"
Cohesion: 0.17
Nodes (12): build, context, createState, _future, initState, _row, showModalBottomSheet, showTrackSwitcher (+4 more)

### Community 35 - "exam_convert.dart"
Cohesion: 0.15
Nodes (12): _group, listeningExamFromContent, _listeningSection, map, _options, _passage, passages, _question (+4 more)

### Community 36 - "grading_overlay.dart"
Cohesion: 0.18
Nodes (11): dart:async, build, createState, dispose, _GradingDialog, _GradingDialogState, initState, _pct (+3 more)

### Community 37 - "brand.dart"
Cohesion: 0.17
Nodes (11): Brand, coachName, currency, domain, logoInitial, name, shortName, shortPitch (+3 more)

### Community 38 - "../mock/data.dart"
Cohesion: 0.18
Nodes (10): build, CheckoutScreen, _CheckoutScreenState, createState, _selected, build, createState, _filter (+2 more)

### Community 39 - "State"
Cohesion: 0.23
Nodes (12): LessonsScreen, _LessonsScreenState, MockExamsScreen, _MockExamsScreenState, ProgressScreen, _ProgressScreenState, WritingEditorScreen, _WritingEditorScreenState (+4 more)

### Community 40 - "Spring Boot Backend"
Cohesion: 0.20
Nodes (11): Rebrand to Yalla English Hub, Backend Wiring: Server URL + Token, ApiClient, Formerly Fluenta, Node Mock API Stub, Reading Runner, Server-scored Attempts, Server URL (persisted, editable) (+3 more)

### Community 41 - "full_exam_screen.dart"
Cohesion: 0.20
Nodes (10): full_exam_store.dart, build, createState, _extra, _extraCard, FullExamScreen, _FullExamScreenState, _scored (+2 more)

### Community 42 - "achievements_screen.dart"
Cohesion: 0.20
Nodes (10): _achIcon, AchievementsScreen, _AchievementsScreenState, build, _card, createState, _filter, _future (+2 more)

### Community 43 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 44 - "certificates_screen.dart"
Cohesion: 0.22
Nodes (9): Future, build, _card, CertificatesScreen, _CertificatesScreenState, createState, _future, initState (+1 more)

### Community 45 - "dashboard_screen.dart"
Cohesion: 0.22
Nodes (9): createState, DashboardScreen, dispose, _ExamCountdownCard, _ExamCountdownCardState, initState, _QuickStartGrid, _StreakCard (+1 more)

### Community 46 - "feedback_list_screen.dart"
Cohesion: 0.22
Nodes (9): build, _card, createState, FeedbackListScreen, _FeedbackListScreenState, _future, initState, _reload (+1 more)

### Community 47 - "format.dart"
Cohesion: 0.20
Nodes (9): cefrForBand, days, formatBand, longDate, months, n, pad2, prettyDate (+1 more)

### Community 48 - "Held Prototype Features (password reset,"
Cohesion: 0.28
Nodes (9): Email Verification Flow (held), Google / OAuth Sign-in (held), Password Reset / Forgot-password (held), Real Auth (password + registration), Real Payments / Checkout (held), docs/superpowers Design Spec, Held Prototype Features (password reset, email verification, OAuth, payments/audio), Repo Layout (lib/, tools/, docs/) (+1 more)

### Community 49 - "passages.dart"
Cohesion: 0.22
Nodes (8): _endingsBox, _featuresBox, _headingsBox, _paraBox, readingExam, _tfng, _ynng, ReadingExam

### Community 50 - "APK Build (flutter build apk)"
Cohesion: 0.25
Nodes (8): Backend Firewall Requirement (:8080), Gradle/Kotlin Loopback Build Issue, Physical Android Phone Demo over WiFi, APK Build (flutter build apk), Windows Firewall Rule (port 8080), android/gradle.properties Settings, Loopback Build Issue, Manifest INTERNET + Cleartext HTTP

### Community 51 - "AI Features Held"
Cohesion: 0.33
Nodes (7): AI: Coach Chat (held), AI: Live Interview (held), AI: Speaking Feedback (held), Speaking (backend parts, AI feedback held), AI Features Held, Live Interview (coming soon), Speaking (Standard Practice)

### Community 52 - "full_exam_results_screen.dart"
Cohesion: 0.33
Nodes (6): createState, FullExamResultsScreen, _FullExamResultsScreenState, _issuing, _skillRow, ../services/api_client.dart

### Community 53 - "app_theme.dart"
Cohesion: 0.33
Nodes (5): app_colors.dart, buildAppTheme, scheme, textTheme, package:google_fonts/google_fonts.dart

### Community 54 - "package:go_router/go_router.dart"
Cohesion: 0.33
Nodes (5): AppShell, build, navigationShell, package:go_router/go_router.dart, StatefulNavigationShell

### Community 55 - "Fill Demo Credentials button"
Cohesion: 0.50
Nodes (4): Fill Demo Credentials button, Demo Account, Fill Demo Credentials button, FLUENTA_DEMO_PASSWORD env var

## Knowledge Gaps
- **705 isolated node(s):** `XCTest`, `serverUrlKey`, `tokenKey`, `defaultServerUrl`, `_prefs` (+700 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **6 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthState` connect `AuthState` to `Yalla Mobile P0 Foundation Plan`, `api_client.dart`, `overview_screen.dart`, `onboarding_screen.dart`, `modals.dart`, `listening_runner_screen.dart`, `reading_runner_screen.dart`, `AppState`, `listening_loader_screen.dart`, `login_screen.dart`, `app_state.dart`, `auth_state.dart`, `reading_hub_screen.dart`, `speaking_screen.dart`, `build`, `track_switcher.dart`, `achievements_screen.dart`, `certificates_screen.dart`, `feedback_list_screen.dart`, `full_exam_results_screen.dart`?**
  _High betweenness centrality (0.068) - this node is a cross-community bridge._
- **Why does `Yalla Mobile P0 Foundation Plan` connect `Yalla Mobile P0 Foundation Plan` to `api_client.dart`, `login_screen.dart`?**
  _High betweenness centrality (0.037) - this node is a cross-community bridge._
- **Why does `AppState` connect `AppState` to `build`, `Yalla Mobile P0 Foundation Plan`, `api_client.dart`, `overview_screen.dart`, `modals.dart`, `full_exam_screen.dart`, `dashboard_screen.dart`, `full_exam_results_screen.dart`, `app_state.dart`, `AuthState`, `speaking_screen.dart`?**
  _High betweenness centrality (0.025) - this node is a cross-community bridge._
- **What connects `XCTest`, `serverUrlKey`, `tokenKey` to the rest of the system?**
  _705 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `models.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.012987012987012988 - nodes in this community are weakly interconnected._
- **Should `package:provider/provider.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.06766917293233082 - nodes in this community are weakly interconnected._
- **Should `Yalla Mobile P0 Foundation Plan` be split into smaller, more focused modules?**
  _Cohesion score 0.05714285714285714 - nodes in this community are weakly interconnected._