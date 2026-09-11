# Yalla English Hub — Mobile (Flutter)

Native **Flutter** (Material 3) mobile app for **Yalla English Hub** (formerly Fluenta) — the
IELTS/English practice platform. It mirrors the current web app and talks to the same
**Spring Boot backend** over HTTP. Warm, encouraging design; Plus Jakarta Sans.

- **Nav:** bottom bar — Home · Practice · Coach · More. Login, onboarding, exam runner, and
  results are full-screen.
- **State/routing:** `provider` (`AuthState` owns auth + the current user; `AppState` holds
  app prefs) · `go_router` with a connectivity/auth **bootstrap gate** (splash → offline+Retry →
  login → onboarding → app).
- **Data:** the real backend via a typed `ApiClient` (bearer auth, `ApiException`). The backend
  base URL is a **persisted, editable "Server URL"** — set it on the login screen or in
  Account & privacy.

## What's implemented

Login-first + 4-step onboarding · Overview home (Practice-by-Skill ×6, Progress Report with a
band-over-time chart, Strengths & Weaknesses, Recent Activity, streak, plan) · **6 skills**
(Vocabulary & Grammar are dashboard-only "coming soon") · Reading runner wired to the backend
with **server-scored attempts** + review · Practice hub · Speaking (Standard practice +
"Live Interview" coming soon) · Achievements · Certificates · My Feedback (submit + status) ·
Learning-track switcher · Settings (Server URL, privacy, sign out).

**Held (parity with web):** all AI features — Coach chat, Writing/Speaking AI feedback, Live
Interview — show a "coming soon" state; `/api/ai/*` returns 501.

## Run

```bash
cd D:\personal\fluenta-mobile
flutter pub get
```

Point the app at your backend by editing **Server URL** in-app (default
`http://localhost:8080/api`).

**Physical Android phone (primary demo) over WiFi:**
1. Run the backend on your laptop (binds all interfaces by default; allow inbound `:8080` in
   the firewall).
2. Phone + laptop on the same WiFi.
3. Install the APK (`build/app/outputs/flutter-apk/app-debug.apk`) and set Server URL to your
   laptop's LAN IP, e.g. `http://192.168.1.50:8080/api`.

```bash
flutter build apk --debug        # or --release
flutter install                  # to a connected device
```

**Android emulator on the laptop:** Server URL = `http://10.0.2.2:8080/api`.

**Flutter web at phone size (laptop preview):** `flutter run -d chrome` — the backend must
allow the web origin in its CORS config (native APK is unaffected).

## Local verification without the Java backend

The Java server can't always bind on the dev machine. A dependency-free stub mirrors the
student API for local checks:

```bash
node tools/mock-api/server.mjs   # http://localhost:8080/api  (auth/me; grows per phase)
```

## Tests

```bash
flutter analyze
flutter test
```

Unit/widget tests cover the config, models/JSON, `ApiClient` (via `http` MockClient), auth/app
state, bootstrap gate, login, onboarding, overview, and the reading content converter.

## Layout

```
lib/
  config/          brand.dart · app_config.dart (server URL + token)
  models/models.dart
  services/        api_client.dart · exam_convert.dart · mock_api.dart
  state/           auth_state.dart · app_state.dart
  router.dart      go_router + bootstrap gate redirect
  features/<area>/ one folder per screen area
  main.dart
tools/mock-api/    Node stub API (local verification)
docs/superpowers/  design spec + phase plans
```

> Prototype: login is any-email (no password), payments/audio capture are simulated, and AI is
> held. See `docs/superpowers/specs/2026-09-11-yalla-mobile-parity-design.md`.
