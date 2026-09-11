# Yalla English Hub — Mobile Parity Design Spec

**Date:** 2026-09-11
**Status:** Approved (brainstorm) — ready for implementation plan.
**Repo:** `D:\personal\fluenta-mobile` (remote `github.com/aalqaissi/fluenta-mobile`, branch `main`).
**Goal:** Evolve the existing Flutter app so it matches the **current** web app ("Yalla English Hub", Stage 2) as a **student-facing** experience wired to the real Spring Boot backend, ready to demo to the app owner on a physical Android phone (and, secondarily, as Flutter web at phone size).

Source of truth for behaviour: the web build at `D:\personal\fluenta-web\src` and its API client [`src/lib/api.ts`](../../../../fluenta-web/src/lib/api.ts). Predecessor spec: `fluenta-web/docs/superpowers/specs/2026-09-03-fluenta-mobile-design.md`.

---

## 1. Why this work exists

The Flutter app was built 2026-09-03 and mirrors the **old** Fluenta prototype (frontend-only, brand "Fluenta", 4 skills, separate Progress tab, no onboarding, no tracks/feedback). Since then the web app went through a "Stage 2" transformation the mobile app knows nothing about. This spec closes that gap.

| Area | Mobile (now) | Web (target) |
|---|---|---|
| Brand | Fluenta | **Yalla English Hub** (short "Yalla", coach "Yalla Coach") |
| Data | Local Dart mocks | **Spring Boot API** (bearer auth) |
| Entry | Login → app | **Login-first + 4-step onboarding** |
| Home | Dashboard + separate Progress tab | **Overview** (Practice-by-Skill, Progress Report, Strengths & Weaknesses, My Feedback, Recent Activity); Progress merged in |
| Skills | 4 | **6** (adds Vocabulary + Grammar as dashboard-only "coming soon") |
| Tracks | none | **Track switcher** (IELTS active; others "coming soon") |
| Feedback | — | **Submit + status tracking** |
| Achievements / Certificates | old style | rebuilt (categories/tiers/points; list/table certs) |
| Speaking | single flow | **Standard + Live Interview** chooser |
| Mock Exam page | in nav | **hidden** |
| AI | mocked | **held** (501 / "coming soon") |

## 2. Decisions locked in brainstorming

1. **Scope:** full **student** parity with current web. **No admin Content Studio** on mobile.
2. **Data:** wire to the Spring Boot backend, with a **persisted, user-editable "Server URL"** so the owner demo can point at the laptop's LAN IP over WiFi (e.g. `http://192.168.1.50:8080/api`).
3. **Demo targets:** primary = **physical Android phone (APK)** on the same WiFi as the laptop; secondary = **Flutter web at phone size** on the laptop.
4. **Bottom nav:** **4 tabs** — Home · Practice · Coach · More (Progress dropped, merged into Home).
5. **Approach:** **evolve the existing app in place** (reuse theme/models/router/screens); do not rebuild.

## 3. Architecture

### 3.1 Data & config layer (new)
- **`lib/services/api_client.dart`** — typed HTTP client mirroring web [`src/lib/api.ts`](../../../../fluenta-web/src/lib/api.ts), using `package:http`.
  - Bearer token on every request; `Content-Type: application/json` on bodies.
  - `ApiException(status, message)`; `401` → clear token + "session expired"; network failure → `status 0` + "Can't reach the Yalla English Hub API at <url>. Is the backend running?".
  - Student endpoint groups (see §6): `auth`, `me`, `exams` (read), `attempts`, `certificates`, `content` (lessons/achievements/plans/progress/tracks), `overview`, `feedback` (create/list/summary). Admin + exam-write + duplicate/status endpoints are **out of scope** (web-only authoring).
- **`lib/config/app_config.dart` + `shared_preferences`** — persists:
  - `serverUrl` (default `http://localhost:8080/api`; editable from Settings **and** the login screen; trailing slash trimmed). Note for emulator use: `http://10.0.2.2:8080/api`.
  - `token` (bearer), replacing today's in-memory story.
- **New pub deps:** `http`, `shared_preferences`.

### 3.2 State & bootstrap
- Split today's single `AppState` (`lib/state/app_state.dart`) into:
  - **`AuthState`** (ChangeNotifier): `token`, `user`, `status` (`booting|offline|unauthed|onboarding|ready`), `login(email)`, `logout()`, `loadMe()`, `updateMe(patch)`. Mirrors web's AuthProvider/AppProvider split.
  - **`AppState`** keeps app-level prefs: `previewFree` toggle, active `track`.
- **Bootstrap gate** (mirrors web app-context): launch → branded splash → if token, `GET /me` → route by `onboarded`; if no token → `/login`; if API unreachable → **offline + Retry** screen. Per-screen data (overview, lists) fetched with `FutureBuilder` + loading/empty/error states.
- `go_router` `redirect` enforces: unauthed → `/login`; authed & `!onboarded` → `/onboarding`; authed & onboarded hitting `/login|/onboarding` → `/`.

### 3.3 Navigation (4-tab shell)
`StatefulShellRoute.indexedStack` branches → **Home** (`/`), **Practice** (`/practice`), **Coach** (`/coach`), **More** (`/more`). Remove the `/progress` branch (merged into Home).

Full-screen routes (root navigator): `/login`, **`/onboarding`** (new), exam runners (`/exam/reading|listening|writing/:id|speaking`), results (`/results/...`), `/speaking` chooser + `/speaking/standard` + `/speaking/live`, `/full-exam`, `/writing`, `/reading`, `/listening`, `/lessons`, `/achievements`, `/certificates`, `/checkout`, `/settings`, `/help`, `/feedback`. Keep `/mock-exams` route+files but **remove from all nav** (parity with web "hidden, not deleted").

`More` contents: Achievements · Certificates · Lessons & Library · **Give / My Feedback** · Plan/Upgrade · **Track switcher** · Account & Settings (incl. Server URL, privacy, sign out) · **Preview free tier** toggle.

### 3.4 Models
Extend `lib/models/models.dart` to mirror backend DTOs with manual `fromJson`/`toJson` (no codegen, matching current style):
`FluentaUser` (+ `onboarded`, `track`, `examType`, `purpose`, `level`, `targetBand`, `examDate`, `saveHistory`, `streak{current,best,last30}`), `OverviewDto` (`targetBand`, `currentAverage`, `gapToTarget`, `testsCompleted`, `skills[]`, `strongest`, `weakest`, `series{}`, `recentActivity[]`), `SkillStat`, `SkillPoint`, `SeriesPoint`, `ActivityItem`, `ExamDto` (`content` = dynamic JSON), `AttemptDto`/`AttemptRequest`, `CertificateDto`, `Track`, `FeedbackDto`/`FeedbackSummary`/`CreateFeedback`, `Lesson`, `Achievement`, `Plan`. `SkillKey` = reading|writing|listening|speaking|**vocabulary|grammar**; `ScoredSkillKey` = first four.

## 4. Design system

Unchanged and already approved on web — **do not re-derive it**. Faithfully keep the warm Material 3 language already in `lib/theme/`: coral `#EF6C57`, amber `#F5A524`, teal `#0EA5A4`, cream bg `#FDF8F3`, Plus Jakarta Sans, rounded cards (20–24) / buttons (16), band-score colour scale, coral→amber hero gradient. The UI skills below are used to **build and refine** screens to this system, not to invent a new one.

## 5. Screen-by-screen delta

| # | Change | Endpoint(s) |
|---|---|---|
| 1 | **Rebrand** `lib/config/brand.dart` → name "Yalla English Hub", `shortName` "Yalla", `coachName` "Yalla Coach", tagline/pitch, logo initial "Y", `MaterialApp.title` | — |
| 2 | **Login → onboarding**: login wired to API; new 4-step onboarding (Welcome → exam type/purpose → level → target band + exam date) → `PATCH /me {onboarded:true, ...}` | `auth/login`, `me` |
| 3 | **Home = Overview** rebuild (replaces Dashboard): Practice-by-Skill (6), Progress Report (target, per-skill tabs, band-over-time chart, tests/avg/gap tiles), Strengths & Weaknesses (bars + strongest/weakest), My Feedback card, Recent Activity, Exam Countdown, Study Streak, Plan | `overview`, `me`, `feedback/summary` |
| 4 | **6 skills** — add Vocabulary + Grammar, rendered "coming soon" (no runner) | — |
| 5 | **Exam runners wired to API** — Reading/Listening/Writing/Speaking fetch exam (`exams`), **submit server-scored attempts** (`attempts`), results fetch the attempt; delete local `scoreReading` mock | `exams`, `attempts` |
| 6 | **Speaking modes** chooser: Standard (intro → "generating" → 3-part recorder → results) + Live Interview "coming soon" | `exams`, `attempts` |
| 7 | **Achievements** rebuild — categories, tiers, points, status filters | `achievements` |
| 8 | **Certificates** rebuild — list/table, Standard/IELTS Report types, verification # | `certificates` |
| 9 | **Feedback** — submit modal + My Feedback list with statuses (new/under_review/completed) | `feedback` |
| 10 | **Track switcher** — IELTS active, others "coming soon" | `tracks` |
| 11 | **Hide Mock Exam & Self-Improvement** from nav (keep files) | — |
| 12 | **AI held** — Coach input, Writing/Speaking "submit for AI feedback", Live Interview → disabled/"coming soon"; handle `/api/ai/*` → 501 gracefully | `ai/*` (501) |
| 13 | **Settings** — Server URL field (persisted), privacy (`saveHistory`), sign out | `me` |
| 14 | **Offline/loading gate** — branded splash + offline+Retry when API unreachable | (bootstrap) |

## 6. API surface consumed (student subset of `api.ts`)

- `POST /auth/login {email}` → `{token, user}`; `POST /auth/logout`
- `GET /me`, `PATCH /me`
- `GET /exams?skill=&status=published&scope=`, `GET /exams/:id`
- `POST /attempts`, `GET /attempts/:id`, `GET /attempts?examId=`, `GET /attempts`
- `GET /certificates`, `GET /certificates/:id`
- `GET /lessons`, `GET /achievements`, `GET /plans`, `GET /progress`, `GET /tracks`
- `GET /overview`
- `POST /feedback`, `GET /feedback`, `GET /feedback/summary`
- `/ai/*` → **501** (all AI held; render "coming soon")

## 7. Build phasing

Each phase ends with: `flutter analyze` clean, the phase's screens verified, and a **graphify update** (see §8).

- **P0 — foundation:** add `http` + `shared_preferences`; `app_config` + persisted Server URL; `api_client` with auth/exams/attempts/content/overview/feedback groups + error model; split `AuthState`/`AppState`; bootstrap gate (splash / offline+Retry); token persistence.
- **P1 — identity:** rebrand (`brand.dart`, logo "Y", app title); login wired to API + Server-URL field on login; 4-step onboarding → `PATCH /me`.
- **P2 — home & nav:** Overview rebuild (all sections) from `/overview` + `/me`; drop Progress tab → 4-tab shell; 6-skill grid with coming-soon.
- **P3 — practice & runners:** Practice hub (6 skills, Mock Exam hidden); wire Reading runner to API + server-scored attempt + results; then Listening, Writing, Speaking runners the same way.
- **P4 — engagement:** Speaking modes chooser; Achievements rebuild; Certificates rebuild; Feedback (submit + list); Track switcher.
- **P5 — rest & AI-held:** Coach (input disabled/"coming soon"), Lessons, Checkout/Plan, Settings (Server URL, privacy, sign out); AI-held states everywhere.
- **P6 — polish & ship:** spacing/motion/empty/error passes (impeccable/improve-ui); **build APK**; verify on a physical device over WiFi **and** Flutter web at phone size.

## 8. Skills & workflow

How the requested skills map to this project (used where they genuinely help; noted honestly where they don't fit native Flutter):

| Skill | Where it's used |
|---|---|
| **Superpowers** | Process spine: brainstorming (done) → writing-plans (next) → test-driven-development for the api_client/models/scoring, systematic-debugging for failures, requesting-code-review before merges, verification-before-completion before any "done" claim. |
| **Engineering** | `architecture` for the api_client/state boundary if a decision needs an ADR; `testing-strategy` for the model/serialization + runner tests; `code-review` on each phase's diff. |
| **graphify** | **Standing rule: update graphify whenever code changes.** Build the baseline graph of `fluenta-mobile` at start of P0, then re-run on changed files at the end of every phase (and after any code edit). See rule below. |
| **ui-ux-pro-max** | Consulted when building/refining screens (Flutter/Material 3 guidance: layout, spacing, a11y, data-viz for the Progress chart & strengths bars) — **applied to the existing warm design system, not to replace it**. |
| **impeccable** / **improve-ui** | P2–P6 screen build + the P6 polish pass: visual hierarchy, states (loading/empty/error), micro-interactions, consistency, accessibility. `improve-ui` for read-only audits of a surface before refining it. |
| **find-skills** | If a capability gap appears mid-build, discover an installable skill rather than hand-rolling. |
| **theme-factory** | Not for the Flutter app theme (that's fixed in `lib/theme/`). Reserved for an optional themed **owner-facing HTML walkthrough/one-pager** if we decide to produce one. |
| **web-artifacts-builder** | Not applicable to native Flutter code. Only relevant if we build a claude.ai HTML artifact (e.g. a clickable "what's new on mobile" demo for the owner) — optional, not core scope. |
| **caveman** | Tone overlay only; use only when explicitly requested. |

**graphify rule (standing):** after any code change to `fluenta-mobile`, update the graphify knowledge graph so `graphify-out/` stays current. Baseline is built in P0; each phase re-indexes what changed. A cross-session hard guarantee would be a `settings.json` hook — offered separately.

## 9. Prerequisites & risks (demo-blocking)

- ⚠️ **Backend must run on a reachable host.** On *this* machine the Java server can't bind (local proxy intercepts the NIO loopback selector — see `fluenta-web/backend/README.md`). If the demo laptop is this machine, resolve first (allow `java.exe` loopback, or run via Docker/WSL/another host).
- **LAN reachability:** run the backend so it binds all interfaces (Spring Boot default); phone + laptop on the same WiFi; the laptop firewall must allow inbound **:8080**.
- **Flutter-web path only:** the browser enforces CORS → add the Flutter-web origin to the backend CORS allowlist (small change in `fluenta-web/backend`). The native APK is unaffected.
- **Flutter web + CanvasKit** is laggy/opaque to automate — verify the web path manually; the phone APK is the real demo.
- **Server-scored attempts:** mobile's `AttemptRequest` mirrors web's shape, so the existing `/attempts` scorer applies unchanged.

## 10. Out of scope (this round)

Admin Content Studio; real AI (coach/writing/speaking/live/generate); real payments & audio capture; real password auth/registration (login stays prototype: any email → seeded user); iOS packaging (needs a Mac); push notifications.

## 11. Acceptance

- App launches to splash → login → onboarding (new account) or Home (returning), against a live backend at the configured Server URL.
- Home Overview renders all sections from `/overview` + `/me`; 6-skill grid shows Vocabulary/Grammar as coming-soon.
- A Reading (then Listening/Writing/Speaking) attempt submits to `/attempts` and shows server-scored results.
- Achievements, Certificates, Feedback (submit + list), Track switcher all render from their endpoints.
- AI actions show "coming soon" and never crash on a 501.
- Server URL is editable and persists across restarts.
- Builds and runs as an Android APK on a device over WiFi, and as Flutter web at phone size.
- `flutter analyze` clean; graphify graph current.
