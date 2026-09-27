import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../services/mock_api.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';
import '../../utils/exam_mode.dart';
import '../../widgets/runner_timer.dart';
import '../full_exam/full_exam_store.dart';
import '../../widgets/ui.dart';
import 'visual_prompt.dart';

class WritingEditorScreen extends StatefulWidget {
  final String taskId;
  final WritingTask? task;
  final ExamMode mode;
  /// part of a full-exam session; [next] is the Task 2 id to continue to after Task 1
  final bool full;
  final String? next;
  const WritingEditorScreen(
      {super.key, required this.taskId, this.task, this.mode = ExamMode.practice, this.full = false, this.next});
  @override
  State<WritingEditorScreen> createState() => _WritingEditorScreenState();
}

class _WritingEditorScreenState extends State<WritingEditorScreen> {
  late final WritingTask task =
      widget.task ?? writingTasks.firstWhere((t) => t.id == widget.taskId, orElse: () => writingTasks.first);
  final _controller = TextEditingController();
  late final RunnerTimer _timer;
  bool _submitting = false;

  ExamMode get _mode => widget.full ? ExamMode.exam : widget.mode;

  @override
  void initState() {
    super.initState();
    // Exam: official task time (Task 1 20 min / Task 2 40 min), auto-submit at 0. Practice: optional timer.
    _timer = RunnerTimer(
      mode: _mode,
      durationSec: _mode == ExamMode.exam
          ? (task.taskNumber == 1 ? ExamTiming.writingTask1Sec : ExamTiming.writingTask2Sec)
          : task.durationSec,
      onExpire: _onTimeUp,
    )..start();
  }

  @override
  void dispose() {
    _timer.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTimeUp() {
    if (_submitting) return;
    if (_controller.text.trim().isEmpty) {
      _timer.stop();
      showToast(context, 'Time is up — no answer was written for this task.');
      if (widget.full) {
        _afterFullTask(0);
      } else {
        context.canPop() ? context.pop() : context.go('/writing');
      }
    } else {
      _submit();
    }
  }

  /// Full exam: record this task's band, then continue to Task 2 or back to the orchestrator.
  void _afterFullTask(double band) {
    FullExamStore.record(task.taskNumber == 1 ? 'writingT1' : 'writingT2', band);
    context.go(widget.next != null ? '/exam/writing/${widget.next}?full=1' : '/full-exam');
  }

  int get _words => _controller.text.trim().isEmpty ? 0 : _controller.text.trim().split(RegExp(r'\s+')).length;

  Future<void> _submit() async {
    if (_submitting) return;
    _submitting = true;
    _timer.stop();
    final api = context.read<AuthState>().api;
    final essay = _controller.text;
    final words = _words;
    AttemptStore.lastWriting = WritingAttempt(taskId: task.id, answer: essay, wordCount: words);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(children: [
          SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5)),
          SizedBox(width: 16),
          Expanded(child: Text('Reviewing your essay…')),
        ]),
      ),
    );

    WritingResult? result;
    try {
      result = await api.writingFeedback(
        taskId: task.id,
        taskNumber: task.taskNumber,
        kind: task.kind,
        module: task.module ?? 'both',
        prompt: task.prompt,
        minWords: task.minWords,
        essay: essay,
      );
    } catch (_) {
      result = null; // results screen falls back to sampleWritingResult
    }
    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss the loader
    AttemptStore.lastWriting =
        WritingAttempt(taskId: task.id, answer: essay, wordCount: words, result: result);
    if (widget.full) {
      if (result == null) {
        // don't record a sample band as the student's grade — let them retry from the orchestrator
        showToast(context, "We couldn't grade this task right now — try again from the full exam.");
        context.go('/full-exam');
      } else {
        _afterFullTask(result.overall);
      }
      return;
    }
    context.go('/results/writing/${task.id}');
  }

  @override
  Widget build(BuildContext context) {
    final enough = _words >= task.minWords;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        title: Text('Writing · Task ${task.taskNumber}'),
        actions: [
          ModeBadge(_mode),
          const SizedBox(width: 8),
          Center(child: TimerChip(timer: _timer)),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primary.withValues(alpha: 0.1),
                      AppColors.secondary.withValues(alpha: 0.1),
                    ]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const PillBadge('Prompt', color: AppColors.info, icon: Icons.auto_awesome),
                    const SizedBox(height: 8),
                    Text(task.prompt, style: const TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text('Write at least ${task.minWords} words.', style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
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
                  ]),
                ),
                if (task.visual != null) ...[
                  const SizedBox(height: 14),
                  VisualPrompt(visual: task.visual),
                ],
                const SizedBox(height: 14),
                TextField(
                  controller: _controller,
                  maxLines: null,
                  minLines: 12,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: 'Start writing your response here…'),
                  style: const TextStyle(height: 1.5),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(children: [
                Expanded(
                  child: Text('$_words words${enough ? ' · minimum reached' : ' · ${task.minWords - _words} to go'}',
                      style: TextStyle(fontWeight: FontWeight.w700, color: enough ? AppColors.success : AppColors.mutedForeground)),
                ),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.success),
                  onPressed: _words < 5 ? null : _submit,
                  icon: const Icon(Icons.flag_rounded, size: 18),
                  label: const Text('Submit'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
