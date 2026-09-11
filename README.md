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

### Physical Android phone (primary demo) over WiFi

**1. Build the APK** (always use the full clean sequence — it avoids stale-cache build
failures and picks up dependency/manifest changes):

```bash
cd D:\personal\fluenta-mobile
flutter clean
flutter pub get
flutter build apk
```

Release APK: `build/app/outputs/flutter-apk/app-release.apk` (~52 MB). Install to a connected
device with `flutter install`, or copy the APK to the phone. Use `flutter build apk --debug`
for a faster debug build. The manifest already grants `INTERNET` + cleartext HTTP so the release
app can reach a plain-http LAN backend (Flutter only adds these to debug builds by default).

**2. Let the phone reach the backend:**

- Run the backend on your laptop — it binds all interfaces (`0.0.0.0:8080`) by default.
- **Open the firewall for port 8080** (Windows blocks inbound on a "Public" Wi-Fi by default).
  In an **Administrator** terminal:
  ```bash
  netsh advfirewall firewall add rule name="Yalla backend 8080" dir=in action=allow protocol=TCP localport=8080
  ```
- Phone + laptop on the **same Wi-Fi**. Find the laptop's Wi-Fi IPv4 with `ipconfig` (the
  `192.168.x.x` under "Wireless LAN adapter Wi-Fi" — **not** a `172.x`/vEthernet virtual adapter).
- Sanity check from the phone browser: open `http://<laptop-ip>:8080/api/tracks` — a small JSON
  response (even a `401`) means it's reachable.

**3. In the app:** set **Server URL** to `http://<laptop-ip>:8080/api` (e.g.
`http://192.168.100.9:8080/api`) on the login screen, then sign in.

> **If the build fails with `Unable to establish loopback connection` or a Kotlin
> `Could not close incremental caches / already registered` error:** a local loopback proxy is
> blocking fresh Gradle/Kotlin **daemons**, and interrupted builds can corrupt the Kotlin
> incremental cache. `android/gradle.properties` already sets `org.gradle.daemon=false`,
> `kotlin.compiler.execution.strategy=in-process`, and `kotlin.incremental=false` to avoid both.
> If it still fails, stop any daemon and rebuild clean:
> ```bash
> cd D:\personal\fluenta-mobile\android && .\gradlew --stop && cd ..
> flutter clean && flutter pub get && flutter build apk
> ```
> (Those `gradle.properties` flags are only needed where the loopback proxy runs — remove them
> on a normal machine, where the daemons are faster.)

### Android emulator on the laptop

Server URL = `http://10.0.2.2:8080/api` (the emulator's alias for the host).

### Flutter web at phone size (laptop preview / quick test)

The browser enforces CORS, and the backend allows the origin `http://localhost:5173` — so serve
the web build on **port 5173** (any other port gets its API calls blocked):

```bash
cd D:\personal\fluenta-mobile
flutter build web
python -m http.server 5173 --directory build/web    # then open http://localhost:5173
```

For live reload while developing: `flutter run -d chrome --web-port=5173`.

## Local verification without the Java backend

When the backend is down or can't bind, a dependency-free Node stub mirrors the student API
(login/me, overview, exams with scoring, attempts, achievements, certificates, tracks,
feedback, lessons/plans/progress):

```bash
node tools/mock-api/server.mjs                 # http://localhost:8080/api
PORT=9090 node tools/mock-api/server.mjs       # then set Server URL to http://localhost:9090/api
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
