# Mobile Writing Runner (wired to backend) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the mobile Writing runner to the backend — fetch published writing exams, convert their Studio content to runtime tasks, list them in the hub alongside the built-in samples, and run them in the editor with a visual prompt.

**Architecture:** A Dart port of the web `studioWritingToExam` converts an `ExamDto`'s `content.writing` blob into up to three `WritingTask`s (Academic Report / GT Letter / Essay) with web-matching ids. The hub fetches `skill=writing&status=published` exams and passes the chosen `WritingTask` to the editor via the go_router `extra`. Grading stays AI-held (the existing sample result). No backend change.

**Tech Stack:** Flutter/Dart, go_router, provider, `flutter test`/`analyze`. Repo: `D:\personal\fluenta-mobile`.

## Global Constraints

- **No backend change** — consume the existing `GET /api/exams?skill=writing&status=published` and Studio writing content.
- **No module toggle** — the hub lists every task the converter produces (Academic Report + GT Letter + Essay), each labeled by `kind`.
- **Grading unchanged / held** — writing is NOT server-scored; submit stores the answer locally (`AttemptStore.lastWriting`) and the results screen shows `sampleWritingResult`. No `/api/attempts` call for writing.
- **Task id scheme matches web:** `${examId}~t1a` (Academic Report), `${examId}~t1g` (GT Letter), `${examId}~t2` (Essay).
- **Chart-type → visual mapping (verbatim):** `bar-chart`→`bar`, `line-graph`→`line`, `pie-chart`→`pie`, `process-diagram`→`process`, `diagram`→`process`, `maps`→`map`, `table`→`table`, `multiple-graph`→`line`.
- **Formality → kind (verbatim):** `formal`→"Formal letter", `informal`→"Informal letter", `semi-formal`→"Semi-formal letter".
- **Defaults:** Academic T1 minWords 150 / 20 min; GT T1 minWords 150 / 20 min; Task 2 minWords 250 / 40 min.
- Verify with `flutter analyze` (clean) + `flutter test`. Do NOT run `flutter build apk` (Gradle loopback blocked on this machine).
- Branch: `feat/mobile-writing-runner`.

---

## File Structure

- Modify `lib/models/models.dart` — `WritingTask` gains `visual`, `bullets`, `module` (all nullable).
- Create `lib/services/writing_convert.dart` — `writingTasksFromContent(examId, content)`.
- Create `lib/features/writing/visual_prompt.dart` — the `VisualPrompt` widget (line-chart placeholder).
- Modify `lib/features/writing/writing_editor_screen.dart` — accept a `WritingTask? task`, render visual + bullets, fix the sample-essay pre-fill.
- Modify `lib/router.dart:102` — pass `s.extra` as the editor's `task`.
- Modify `lib/features/writing/writing_hub_screen.dart` — stateful; fetch published writing exams; "From your Content Studio" section; navigate with `extra`.
- Create `test/services/writing_convert_test.dart` — converter unit tests.
- Create `test/writing_editor_test.dart` — editor widget test (empty box + visual).

---

## Task 1: Model fields + writing converter

**Files:**
- Modify: `lib/models/models.dart:658-673` (`WritingTask`)
- Create: `lib/services/writing_convert.dart`
- Test: `test/services/writing_convert_test.dart`

**Interfaces:**
- Consumes: `ExamDto.content` (a `Map<String, dynamic>`).
- Produces: `WritingTask` with new nullable fields `String? visual`, `List<String>? bullets`, `String? module`; `List<WritingTask> writingTasksFromContent(String examId, Map<String, dynamic> content)`.

- [ ] **Step 1: Add nullable fields to WritingTask**

In `lib/models/models.dart`, replace the `WritingTask` class body with:

```dart
class WritingTask {
  final String id;
  final int taskNumber;
  final String kind;
  final String prompt;
  final int minWords;
  final int durationSec;
  final String? visual;         // bar|line|pie|process|map|table (Academic T1); null otherwise
  final List<String>? bullets;  // GT letter points (samples only); null otherwise
  final String? module;         // academic|general|both (metadata; not filtered)
  const WritingTask({
    required this.id,
    required this.taskNumber,
    required this.kind,
    required this.prompt,
    required this.minWords,
    required this.durationSec,
    this.visual,
    this.bullets,
    this.module,
  });
}
```

(The existing `const writingTasks` samples in `lib/mock/data.dart` keep compiling — the new fields default to null.)

- [ ] **Step 2: Write the failing converter test**

Create `test/services/writing_convert_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/services/writing_convert.dart';

void main() {
  const content = {
    'writing': {
      'academicT1': {'chartType': 'bar-chart', 'prompt': 'Describe the chart.', 'minWords': 150, 'timeMinutes': 20},
      'generalT1': {'formality': 'formal', 'prompt': 'Write a complaint letter.', 'minWords': 150, 'timeMinutes': 20},
      'task2': {'prompt': 'Discuss both views.', 'minWords': 250, 'timeMinutes': 40},
    },
  };

  test('produces three tasks with web-matching ids, kinds, visual and durations', () {
    final tasks = writingTasksFromContent('exam9', Map<String, dynamic>.from(content));
    expect(tasks.map((t) => t.id), ['exam9~t1a', 'exam9~t1g', 'exam9~t2']);

    final a = tasks[0];
    expect(a.taskNumber, 1);
    expect(a.kind, 'Report');
    expect(a.module, 'academic');
    expect(a.visual, 'bar');            // bar-chart -> bar
    expect(a.minWords, 150);
    expect(a.durationSec, 20 * 60);
    expect(a.prompt, 'Describe the chart.');

    final g = tasks[1];
    expect(g.kind, 'Formal letter');    // formal -> Formal letter
    expect(g.module, 'general');
    expect(g.visual, isNull);

    final t2 = tasks[2];
    expect(t2.taskNumber, 2);
    expect(t2.kind, 'Opinion Essay');
    expect(t2.module, 'both');
    expect(t2.minWords, 250);
    expect(t2.durationSec, 40 * 60);
  });

  test('no writing block yields no tasks', () {
    expect(writingTasksFromContent('x', const {}), isEmpty);
  });

  test('missing sub-blocks are skipped and defaults apply', () {
    final tasks = writingTasksFromContent('e', {'writing': {'task2': {}}});
    expect(tasks.map((t) => t.id), ['e~t2']);
    expect(tasks[0].minWords, 250);          // default
    expect(tasks[0].durationSec, 40 * 60);   // default
  });
}
```

- [ ] **Step 3: Run the test to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/services/writing_convert_test.dart`
Expected: FAIL — `writing_convert.dart` does not exist.

- [ ] **Step 4: Implement the converter**

Create `lib/services/writing_convert.dart`:

```dart
import '../models/models.dart';

const _chartVisual = {
  'bar-chart': 'bar',
  'line-graph': 'line',
  'pie-chart': 'pie',
  'process-diagram': 'process',
  'diagram': 'process',
  'maps': 'map',
  'table': 'table',
  'multiple-graph': 'line',
};

const _formalityKind = {
  'formal': 'Formal letter',
  'informal': 'Informal letter',
  'semi-formal': 'Semi-formal letter',
};

/// Converts a Studio-authored writing exam's `content` into up to three runtime
/// [WritingTask]s (Academic Task 1, General Task 1, Task 2) — the Dart port of the
/// web's `studioWritingToExam`. Ids match the web scheme so results/routing align.
List<WritingTask> writingTasksFromContent(String examId, Map<String, dynamic> content) {
  final w = content['writing'];
  if (w is! Map) return const [];
  final writing = Map<String, dynamic>.from(w);
  final out = <WritingTask>[];

  Map<String, dynamic>? block(String key) {
    final v = writing[key];
    return v is Map ? Map<String, dynamic>.from(v) : null;
  }

  int minWords(Map<String, dynamic>? m, int def) => (m?['minWords'] as num?)?.toInt() ?? def;
  int seconds(Map<String, dynamic>? m, int defMin) => ((m?['timeMinutes'] as num?)?.toInt() ?? defMin) * 60;
  String prompt(Map<String, dynamic>? m, String def) {
    final p = (m?['prompt'] as String?)?.trim();
    return (p == null || p.isEmpty) ? def : p;
  }

  final a = block('academicT1');
  if (a != null) {
    out.add(WritingTask(
      id: '$examId~t1a',
      taskNumber: 1,
      kind: 'Report',
      module: 'academic',
      prompt: prompt(a, 'Summarise the information shown in the chart.'),
      minWords: minWords(a, 150),
      durationSec: seconds(a, 20),
      visual: _chartVisual[a['chartType'] as String?],
    ));
  }

  final g = block('generalT1');
  if (g != null) {
    out.add(WritingTask(
      id: '$examId~t1g',
      taskNumber: 1,
      kind: _formalityKind[g['formality'] as String?] ?? 'Formal letter',
      module: 'general',
      prompt: prompt(g, 'Write a letter as described.'),
      minWords: minWords(g, 150),
      durationSec: seconds(g, 20),
    ));
  }

  final t2 = block('task2');
  if (t2 != null) {
    out.add(WritingTask(
      id: '$examId~t2',
      taskNumber: 2,
      kind: 'Opinion Essay',
      module: 'both',
      prompt: prompt(t2, 'Discuss the topic and give your own opinion.'),
      minWords: minWords(t2, 250),
      durationSec: seconds(t2, 40),
    ));
  }

  return out;
}
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `cd /d/personal/fluenta-mobile && flutter test test/services/writing_convert_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Analyze + commit**

Run: `cd /d/personal/fluenta-mobile && flutter analyze`
Expected: clean.

```bash
cd D:/personal/fluenta-mobile
git add lib/models/models.dart lib/services/writing_convert.dart test/services/writing_convert_test.dart
git commit -m "feat(mobile): WritingTask visual/bullets/module + writingTasksFromContent converter"
```

---

## Task 2: VisualPrompt widget

**Files:**
- Create: `lib/features/writing/visual_prompt.dart`
- Test: `test/writing_editor_test.dart` (created here; the editor test in Task 3 appends to it — for THIS task, add a `VisualPrompt` render test)

**Interfaces:**
- Produces: `VisualPrompt({required String? visual})` — renders `SizedBox.shrink()` when `visual == null`; otherwise a bordered card containing a small line-chart placeholder + a legend (parity with the web's canned chart).

- [ ] **Step 1: Write the failing widget test**

Create `test/writing_editor_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluenta_mobile/features/writing/visual_prompt.dart';

void main() {
  testWidgets('VisualPrompt renders a caption when visual is set', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: 'bar'))));
    expect(find.textContaining('internet access'), findsOneWidget);
  });

  testWidgets('VisualPrompt renders nothing when visual is null', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VisualPrompt(visual: null))));
    expect(find.byType(CustomPaint), findsNothing);
  });
}
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd /d/personal/fluenta-mobile && flutter test test/writing_editor_test.dart`
Expected: FAIL — `visual_prompt.dart` does not exist.

- [ ] **Step 3: Implement the widget**

Create `lib/features/writing/visual_prompt.dart`:

```dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A stand-in Academic Task 1 visual prompt — a small canned line chart (parity
/// with the web VisualPrompt, which renders the same chart for any type). Renders
/// nothing when [visual] is null.
class VisualPrompt extends StatelessWidget {
  final String? visual;
  const VisualPrompt({super.key, required this.visual});

  static const _series = [
    (name: 'Country A', color: Color(0xFFEF6C57), points: [30.0, 45, 62, 78, 88]),
    (name: 'Country B', color: Color(0xFF0EA5A4), points: [12.0, 28, 40, 66, 82]),
    (name: 'Country C', color: Color(0xFFF5A524), points: [8.0, 15, 24, 38, 55]),
  ];

  @override
  Widget build(BuildContext context) {
    if (visual == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('HOUSEHOLDS WITH INTERNET ACCESS (%)',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppColors.mutedForeground)),
        const SizedBox(height: 10),
        AspectRatio(aspectRatio: 16 / 9, child: CustomPaint(painter: _LineChartPainter())),
        const SizedBox(height: 10),
        Wrap(spacing: 14, runSpacing: 6, children: [
          for (final s in _series)
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text(s.name, style: const TextStyle(fontSize: 11.5, color: AppColors.mutedForeground)),
            ]),
        ]),
      ]),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const padL = 26.0, padB = 18.0, padT = 6.0, padR = 6.0;
    final iw = size.width - padL - padR;
    final ih = size.height - padT - padB;
    final grid = Paint()..color = const Color(0xFFEBE1D6)..strokeWidth = 1;
    for (final v in [0, 25, 50, 75, 100]) {
      final y = padT + ih - (v / 100) * ih;
      canvas.drawLine(Offset(padL, y), Offset(size.width - padR, y), grid);
    }
    for (final s in VisualPrompt._series) {
      final paint = Paint()
        ..color = s.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeJoin = StrokeJoin.round;
      final path = Path();
      for (var i = 0; i < s.points.length; i++) {
        final x = padL + (i / (s.points.length - 1)) * iw;
        final y = padT + ih - (s.points[i] / 100) * ih;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
        canvas.drawCircle(Offset(x, y), 2.6, Paint()..color = s.color);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

- [ ] **Step 4: Run to verify it passes**

Run: `cd /d/personal/fluenta-mobile && flutter test test/writing_editor_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Analyze + commit**

Run: `cd /d/personal/fluenta-mobile && flutter analyze` → clean.

```bash
cd D:/personal/fluenta-mobile
git add lib/features/writing/visual_prompt.dart test/writing_editor_test.dart
git commit -m "feat(mobile): VisualPrompt widget (Academic Task 1 chart placeholder)"
```

---

## Task 3: Editor — consume task, render visual + bullets, fix pre-fill

**Files:**
- Modify: `lib/features/writing/writing_editor_screen.dart`
- Modify: `lib/router.dart:102`
- Test: `test/writing_editor_test.dart` (append an editor test)

**Interfaces:**
- Consumes: `WritingTask` (with `visual`/`bullets` from Task 1), `VisualPrompt` (Task 2), seed `writingTasks` (fallback).
- Produces: `WritingEditorScreen({required String taskId, WritingTask? task})`; router passes `task: s.extra as WritingTask?`.

- [ ] **Step 1: Accept an optional task + fix pre-fill + render visual/bullets**

In `lib/features/writing/writing_editor_screen.dart`:

Add the import:
```dart
import '../../models/models.dart';
import 'visual_prompt.dart';
```

Change the widget to accept an optional `task`:
```dart
class WritingEditorScreen extends StatefulWidget {
  final String taskId;
  final WritingTask? task;
  const WritingEditorScreen({super.key, required this.taskId, this.task});
  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}
```

Replace the `task`/`_controller` fields (lines ~19-20) with — resolve from the passed task, else seed by id; start the text box EMPTY:
```dart
  late final WritingTask task =
      widget.task ?? writingTasks.firstWhere((t) => t.id == widget.taskId, orElse: () => writingTasks.first);
  final _controller = TextEditingController();
```

In `build`, inside the prompt `Container`'s `Column` children (after the "Write at least … words." Text), add the bullets and visual:
```dart
                    if (task.bullets != null && task.bullets!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...task.bullets!.map((b) => Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('•  ', style: TextStyle(fontSize: 14)),
                              Expanded(child: Text(b, style: const TextStyle(fontSize: 14, height: 1.4))),
                            ]),
                          )),
                    ],
```
Then, right AFTER the prompt `Container` (before `const SizedBox(height: 14)` and the `TextField`), add:
```dart
                if (task.visual != null) ...[
                  const SizedBox(height: 14),
                  VisualPrompt(visual: task.visual),
                ],
```

(Leave the timer, word count, submit → grading → results logic unchanged.)

- [ ] **Step 2: Pass the router extra to the editor**

In `lib/router.dart`, change the writing editor route (line 102) to:
```dart
      GoRoute(
          path: '/exam/writing/:id',
          builder: (c, s) => WritingEditorScreen(
              taskId: s.pathParameters['id']!, task: s.extra as WritingTask?)),
```
Add the model import at the top of `router.dart` if not present:
```dart
import 'models/models.dart';
```

- [ ] **Step 3: Append the editor widget test**

Add to `test/writing_editor_test.dart` (new imports + test):
```dart
import 'package:go_router/go_router.dart';
import 'package:fluenta_mobile/features/writing/writing_editor_screen.dart';
import 'package:fluenta_mobile/models/models.dart';
```
```dart
  testWidgets('editor starts empty and shows the visual for an Academic task', (tester) async {
    const task = WritingTask(
      id: 'e~t1a', taskNumber: 1, kind: 'Report', prompt: 'Describe the chart.',
      minWords: 150, durationSec: 1200, visual: 'bar', module: 'academic');
    final router = GoRouter(routes: [
      GoRoute(path: '/', builder: (c, s) => const WritingEditorScreen(taskId: 'e~t1a', task: task)),
    ]);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
    // text box is empty
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller?.text ?? '', '');
    // visual prompt rendered
    expect(find.textContaining('internet access'), findsOneWidget);
  });
```

- [ ] **Step 4: Analyze + test**

Run: `cd /d/personal/fluenta-mobile && flutter analyze && flutter test test/writing_editor_test.dart`
Expected: analyze clean; 3 tests pass.

- [ ] **Step 5: Commit**

```bash
cd D:/personal/fluenta-mobile
git add lib/features/writing/writing_editor_screen.dart lib/router.dart test/writing_editor_test.dart
git commit -m "feat(mobile): writing editor renders visual + bullets, starts empty, accepts task extra"
```

---

## Task 4: Hub — fetch published writing exams

**Files:**
- Modify: `lib/features/writing/writing_hub_screen.dart`

**Interfaces:**
- Consumes: `context.read<AuthState>().api.listExams(skill: 'writing', status: 'published')` → `List<ExamDto>`; `writingTasksFromContent` (Task 1); `WritingTask`.
- Produces: hub renders built-in samples + an authored section; cards navigate with `context.push('/exam/writing/${t.id}', extra: t)`.

- [ ] **Step 1: Make the hub stateful and fetch authored writing exams**

Replace `lib/features/writing/writing_hub_screen.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../services/writing_convert.dart';
import '../../state/app_state.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/ui.dart';

class WritingHubScreen extends StatefulWidget {
  const WritingHubScreen({super.key});
  @override
  State<WritingHubScreen> createState() => _WritingHubScreenState();
}

class _WritingHubScreenState extends State<WritingHubScreen> {
  List<WritingTask> _authored = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final exams = await context.read<AuthState>().api.listExams(skill: 'writing', status: 'published');
      final tasks = <WritingTask>[];
      for (final e in exams) {
        tasks.addAll(writingTasksFromContent(e.id, e.content));
      }
      if (mounted) setState(() { _authored = tasks; _loading = false; });
    } on ApiException {
      if (mounted) setState(() { _authored = const []; _loading = false; }); // samples still show
    }
  }

  Widget _card(WritingTask t, {bool authored = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: FluentaCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                    color: (authored ? AppColors.success : AppColors.info).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.edit_rounded, color: authored ? AppColors.success : AppColors.info),
              ),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                PillBadge('Task ${t.taskNumber}', color: authored ? AppColors.success : AppColors.info),
                const SizedBox(height: 2),
                Text(t.kind, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              ]),
            ]),
            const SizedBox(height: 12),
            Text(t.prompt, style: const TextStyle(fontSize: 14, height: 1.45)),
            const SizedBox(height: 12),
            Row(children: [
              const Icon(Icons.schedule_rounded, size: 15, color: AppColors.mutedForeground),
              const SizedBox(width: 4),
              Text('${t.durationSec ~/ 60} min', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
              const SizedBox(width: 14),
              const Icon(Icons.notes_rounded, size: 15, color: AppColors.mutedForeground),
              const SizedBox(width: 4),
              Text('min ${t.minWords} words', style: const TextStyle(fontSize: 12.5, color: AppColors.mutedForeground)),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: authored ? FilledButton.styleFrom(backgroundColor: AppColors.success) : null,
                onPressed: () => context.push('/exam/writing/${t.id}', extra: t),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(authored ? 'Take exam' : 'Start writing'),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final locked = context.watch<AppState>().isLocked('writing');
    return Scaffold(
      appBar: AppBar(title: const Text('Writing practice')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          if (locked) const UpgradeBanner('Writing practice'),
          ...writingTasks.map((t) => _card(t)),
          if (_loading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Center(child: CircularProgressIndicator()))
          else if (_authored.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 6, 4, 12),
              child: Text('From your Content Studio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ),
            ..._authored.map((t) => _card(t, authored: true)),
          ],
        ],
      ),
    );
  }
}
```

(Confirm `UpgradeBanner`'s constructor matches the existing usage — the original file used `UpgradeBanner('Writing practice')`; keep that exact form.)

- [ ] **Step 2: Analyze + full test suite**

Run: `cd /d/personal/fluenta-mobile && flutter analyze && flutter test`
Expected: analyze clean; all tests pass (existing suite + the new writing tests).

- [ ] **Step 3: Commit**

```bash
cd D:/personal/fluenta-mobile
git add lib/features/writing/writing_hub_screen.dart
git commit -m "feat(mobile): writing hub lists published Studio writing exams from the backend"
```

---

## Task 5: Docs + graphify

**Files:**
- Modify: `docs/ROADMAP.md` (mobile)
- Regenerate: graphify graph (mobile)

- [ ] **Step 1: Update the roadmap**

In `docs/ROADMAP.md`, move "Writing runner wired to backend" from "Mobile-specific — next up" to a done state (or annotate it done), noting it fetches published writing exams, converts Studio content, and renders the visual prompt; grading stays AI-held.

- [ ] **Step 2: Commit the roadmap**

```bash
cd D:/personal/fluenta-mobile
git add docs/ROADMAP.md
git commit -m "docs: mark the mobile Writing runner (backend-wired) done"
```

- [ ] **Step 3: Refresh graphify (mobile)**

Refresh the mobile graphify graph per the standing rule (code-only AST + changed docs; images excluded). Commit the refreshed graph (tracked).

---

## Self-Review

**Spec coverage:**
- WritingTask gains visual/bullets/module → Task 1 Step 1. ✓
- `writingTasksFromContent` (ids/kinds/visual mapping/formality/defaults, missing-block skip) → Task 1 Steps 4 + tests. ✓
- VisualPrompt Flutter port → Task 2. ✓
- Editor: consume task via extra + seed fallback, render visual + bullets, fix sample-essay pre-fill → Task 3. ✓
- Router passes extra → Task 3 Step 2. ✓
- Hub: fetch published writing exams + authored section + navigate with extra + samples-still-show on error → Task 4. ✓
- Grading unchanged (no /api/attempts; sample result) → untouched (editor submit path preserved). ✓
- No module toggle (hub lists all) → Task 4. ✓
- Roadmap + graphify → Task 5. ✓

**Placeholder scan:** No TBD/TODO; every code step has concrete code.

**Type consistency:** `WritingTask(...visual, bullets, module)` (Task 1) consumed by the editor (Task 3), hub (Task 4), and `writingTasksFromContent` (Task 1). `writingTasksFromContent(String, Map<String,dynamic>)` (Task 1) consumed by the hub (Task 4). `VisualPrompt({required String? visual})` (Task 2) consumed by the editor (Task 3). `WritingEditorScreen({required String taskId, WritingTask? task})` (Task 3) consumed by the router (Task 3 Step 2). Task-id scheme `~t1a/~t1g/~t2` identical between the converter (Task 1) and the results/route flow.
