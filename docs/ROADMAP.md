# Yalla English Hub — Mobile Roadmap

A living checklist of remaining mobile work. **Pick items top-down and we'll build them.**
Status: ☐ pending · ◐ in progress · ☑ done. Set the Pri column (P0/P1/P2) to reorder.

_Last updated 2026-09-11._

## Done (parity build + runners)

- ☑ Backend wiring: editable **Server URL** + token, typed `ApiClient`, bootstrap gate (splash/offline/login/onboarding).
- ☑ Rebrand → **Yalla English Hub**; login-first + 4-step onboarding.
- ☑ **Overview** home (band-over-time chart, Practice-by-Skill ×6, Strengths & Weaknesses, Recent Activity, streak, plan); 4-tab nav.
- ☑ **Reading** runner — server-scored attempts + review.
- ☑ **Listening** runner — server-scored attempts + review (4 sections, play-once audio).
- ☑ **Speaking** — parts loaded from the backend (AI feedback held).
- ☑ **Full Exam** — orchestrator (Listening + Reading scored back-to-back) → combined band + CEFR + generated certificate.
- ☑ Achievements, Certificates, Feedback (submit + list), Track switcher.
- ☑ Settings (Server URL, privacy, sign out); Android APK builds + connects over WiFi.

## Mobile-specific — next up

| Pri | Status | Item | Notes |
|----|----|----|----|
|  | ☐ | **Real audio** for Listening (and Speaking prompts) | Playback is simulated. Needs audio assets served by the backend (`audioUrl`) + a player (`just_audio`). Highest-value realism gap. |
| | ☐ | **Writing runner** wired to backend | Backend serves no runner-format writing exam yet (only a `seed-w1` studio draft). Needs a studio→runtime converter (like the web's `studioWritingToExam`) + hook into the editor. Grading stays AI-held. |
| | ☐ | **Lessons** from the API | Currently local seed; wire to `GET /api/lessons`. |
| | ☐ | **Mobile polish** | Practice-by-Skill card proportions, empty/error states, larger-text/accessibility pass, optional dark mode. |

## Held product-wide (blocked on backend / product — same as web)

| Pri | Status | Item | Notes |
|----|----|----|----|
| | ☐ | **AI: Coach chat** | Held; input disabled, `/api/ai/coach` → 501. Needs LLM integration. |
| | ☐ | **AI: Writing feedback** (band + criteria + annotations) | Held; enables a scored Writing runner. |
| | ☐ | **AI: Speaking feedback** (band + 4 criteria) | Held; enables scored Speaking + full-exam Speaking band. |
| | ☐ | **AI: Live Interview** (real-time examiner) | Held; shows "coming soon". |
| | ☐ | **Vocabulary & Grammar practice** | Dashboard-tracked only; runners "coming soon" (parity with web). |
| | ☐ | **Other tracks** (General / Business English, TOEFL, PTE, Kids) | Switcher shows them; content not built. |
| | ☐ | **Real payments / checkout** | Checkout is a demo. |
| | ☐ | **Real auth** (password + registration) | Login is prototype: any email → user. |

## Release / distribution (before a public launch)

| Pri | Status | Item | Notes |
|----|----|----|----|
| | ☐ | **App icon** | Still the default Flutter icon (launcher label is "Yalla English Hub"). Add branded `ic_launcher` + adaptive icon. |
| | ☐ | **Release signing** | Uses the debug key; add a keystore + `signingConfigs` for Play Store. |
| | ☐ | **Splash screen** | Native splash with the brand. |
| | ☐ | **iOS build & packaging** | Needs a Mac + Xcode. |
| | ☐ | **Play Store listing** | Screenshots, description, privacy policy. |

## Notes / known environment issues

- On this dev machine a local loopback proxy blocks fresh **Gradle/Kotlin daemons**; `android/gradle.properties` disables them + Kotlin incremental caches so the APK builds. Remove those flags on a normal machine.
- Backend must run on a reachable host with the firewall open on `:8080`; the app's release manifest allows cleartext HTTP for the LAN backend. See `README.md`.
