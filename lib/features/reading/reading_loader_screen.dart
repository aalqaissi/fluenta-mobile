import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../services/exam_convert.dart';
import '../../state/auth_state.dart';
import '../../widgets/ui.dart';
import 'reading_runner_screen.dart';

/// Fetches a reading exam from the backend, converts its runner-format content
/// to the runtime model, then hands off to [ReadingRunnerScreen].
class ReadingLoaderScreen extends StatefulWidget {
  final String? examId;
  final bool full;
  const ReadingLoaderScreen({super.key, this.examId, this.full = false});
  @override
  State<ReadingLoaderScreen> createState() => _ReadingLoaderScreenState();
}

class _ReadingLoaderScreenState extends State<ReadingLoaderScreen> {
  late Future<(ReadingExam, String)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(ReadingExam, String)> _load() async {
    final api = context.read<AuthState>().api;
    ExamDto exam;
    if (widget.examId != null && widget.examId!.isNotEmpty) {
      exam = await api.getExam(widget.examId!);
    } else {
      final list = await api.listExams(skill: 'reading', status: 'published');
      // A random published exam — built-in or Content Studio.
      final pick = pickRandom(list);
      if (pick == null) {
        throw ApiException(404, 'No reading exams are published yet.');
      }
      exam = pick;
    }
    return (readingExamFromContent(runnerContent(exam)), exam.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(ReadingExam, String)>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          final msg = snap.error is ApiException
              ? (snap.error as ApiException).message
              : 'Could not load the reading exam.';
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.cloud_off_rounded,
                  title: 'Exam unavailable',
                  description: msg,
                  action: FilledButton(
                    onPressed: () => setState(() => _future = _load()),
                    child: const Text('Retry'),
                  ),
                ),
              ),
            ),
          );
        }
        final (exam, id) = snap.data!;
        return ReadingRunnerScreen(exam: exam, examId: id, full: widget.full);
      },
    );
  }
}
