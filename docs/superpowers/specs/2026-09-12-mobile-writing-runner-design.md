# Mobile Writing Runner — wired to backend — Design

_Date: 2026-09-12 · Repo: fluenta-mobile · Status: approved (brainstorming) → ready for implementation plan_

## Problem

The mobile Writing feature is entirely local/mock: `writing_hub_screen.dart` and
`writing_editor_screen.dart` both read the two built-in `writingTasks` from `lib/mock/data.dart` —
they never touch the backend. The web hub, by contrast, also lists **published** Studio-authored
writing exams (converted via `studioWritingToExam`) and renders a visual prompt for Academic Task 1.
Mobile has none of that, and the editor even pre-fills the answer box with a sample essay.

## Goal

Bring the mobile Writing runner to parity with web: fetch **published** writing exams from the
backend, convert their Studio content to runtime tasks (a Dart port of `studioWritingToExam` /
`resolveWritingTask`), list them in the hub alongside the built-in samples, run them in the editor
with the **visual prompt**, and fix the sample-essay pre-fill. **No backend change** — the exams
endpoint and Studio writing content already exist. Grading stays **AI-held** (the sample result).

## Decisions (from brainstorming)

| # | Decision |
|---|---|
| Visual prompt | **Include it** — port the web `VisualPrompt` to Flutter; Academic Task 1 shows a labeled chart placeholder per `chartType`. `WritingTask` gains a nullable `visual`. |
| Module | **No toggle — show all.** A studio writing exam yields Academic Task 1 (Report), General Task 1 (Letter), Task 2 (Essay); the hub lists all three, each labeled by `kind`. Mobile introduces no module concept. |
| Grading | **Unchanged / held.** Writing is not server-scored; submit stores the answer locally and the results screen shows the canned `sampleWritingResult`, exactly as today and as web. No `/api/attempts` call, no server persistence. |
| Backend | **No change.** `GET /api/exams?skill=writing&status=published` and the Studio writing content already exist. |

## Data caveat
The seeded writing exam (`seed-w1`) is a **draft**, and the hub (like web) lists only **published**
writing exams — so the "From your Content Studio" section is empty until a writing exam is published
in the Content Studio. The built-in samples always show, so the feature works regardless.

## Architecture (all in `fluenta-mobile`)

### Model + converter
- **`WritingTask`** (`lib/models/models.dart`) gains three nullable fields to carry the converter's
  output: `visual` (`String?` — one of `bar|line|pie|process|map|table`), `bullets`
  (`List<String>?` — GT letter points), `module` (`String?` — metadata, not filtered). Existing
  const `writingTasks` samples keep compiling (new fields default to null).
- **`lib/services/writing_convert.dart`** (new): `List<WritingTask> writingTasksFromContent(String
  examId, Map<String, dynamic> content)` — the Dart port of the web `studioWritingToExam`. From
  `content['writing']` = `{academicT1, generalT1, task2}` produce up to three tasks:
  - `${examId}~t1a` — taskNumber 1, kind "Report", module "academic", `visual` from
    `academicT1.chartType` (mapped: bar-chart→bar, line-graph→line, pie-chart→pie,
    process-diagram/diagram→process, maps→map, table→table, multiple-graph→line), `minWords`
    (default 150), `durationSec` = `timeMinutes*60` (default 20*60).
  - `${examId}~t1g` — taskNumber 1, kind from `generalT1.formality` ("Formal letter" / "Informal
    letter" / "Semi-formal letter"), module "general", `minWords` (150), `durationSec` (20*60).
  - `${examId}~t2` — taskNumber 2, kind "Opinion Essay", module "both", `minWords` (250),
    `durationSec` = `task2.timeMinutes*60` (default 40*60).
  Prompts fall back to sensible defaults when blank (mirroring the web converter). Missing sub-blocks
  are skipped gracefully. Ids match the web scheme (`~t1a`/`~t1g`/`~t2`).

### Hub
`lib/features/writing/writing_hub_screen.dart` becomes a `StatefulWidget`: it keeps the built-in
`writingTasks` samples and adds a **"From your Content Studio"** section fed by
`context.read<AuthState>().api.listExams(skill: 'writing', status: 'published')` (loaded in
`initState`), converting each returned `ExamDto` via `writingTasksFromContent(exam.id, exam.content)`.
Loading spinner while fetching; on error or empty, the section is simply omitted (samples still show).
Each card navigates to the editor **passing the resolved `WritingTask` via the go_router `extra`**
(`context.push('/exam/writing/${t.id}', extra: t)`).

### Editor
`lib/features/writing/writing_editor_screen.dart`: obtain the `WritingTask` from
`GoRouterState.of(context).extra` when present; otherwise fall back to a seed `writingTasks` lookup
by `taskId` (deep-link/back-compat). Changes:
- **Fix the pre-fill bug** — start the text controller **empty** (remove the
  `sampleWritingResult.answer` pre-fill).
- **Render the visual prompt** when `task.visual != null` (new `VisualPrompt` widget below), above the
  text field, under the prompt card.
- **Render bullets** (`task.bullets`) as a bulleted list under the prompt when present.
- Timer, word count, submit → grading dialog → `/results/writing/{id}` unchanged.

### VisualPrompt widget
`lib/features/writing/visual_prompt.dart` (new): a Flutter port of the web `VisualPrompt` — a compact
card that renders a labeled placeholder for the chart type (`bar/line/pie/process/map/table`), e.g. a
representative icon + "Bar chart" caption inside a bordered box, standing in for the uploaded exam
image. Purely presentational; no data.

### Router
The existing `/exam/writing/:id` route is extended to read `state.extra` as an optional `WritingTask`
and pass it to `WritingEditorScreen` (keep `taskId` from the path for the fallback). No new routes.

## Error handling & edge cases
- Backend unreachable / no published writing exam → hub shows only the built-in samples (authored
  section omitted); no error surfaced beyond the runner's normal offline handling.
- Malformed/partial writing content → converter skips missing tasks (null-safe reads with defaults).
- Deep link to `/exam/writing/{id}` with no `extra` → resolve from seed `writingTasks`; unknown id
  falls back to the first sample (current behavior).

## Testing
- **Unit-test `writingTasksFromContent`**: a representative studio writing content map → the three
  expected tasks with correct ids (`~t1a`/`~t1g`/`~t2`), kinds, `visual` mapping, `minWords`, and
  `durationSec`; and graceful handling when a sub-block is missing.
- `flutter analyze` clean + `flutter test`; a widget test that the editor starts with an empty text
  box and renders the visual prompt when `visual` is set. (APK/on-device playthrough is the usual
  deferred manual check.)

## Out of scope
Real AI writing feedback (held); a module toggle/preference; server-side writing attempt persistence;
publishing the seed writing exam (a separate data decision).

## Follow-ups (post-implementation)
- Update `docs/ROADMAP.md` (mobile): mark "Writing runner wired to backend" done.
- Refresh graphify graph (mobile) per the standing rule.
