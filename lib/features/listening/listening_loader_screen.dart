import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/api_client.dart';
import '../../services/exam_convert.dart';
import '../../state/auth_state.dart';
import '../../widgets/ui.dart';
import 'listening_runner_screen.dart';

/// Fetches a listening exam from the backend, converts it, then hands off to
/// the server-scored [ListeningRunnerScreen].
class ListeningLoaderScreen extends StatefulWidget {
  final String? examId;
  const ListeningLoaderScreen({super.key, this.examId});
  @override
  State<ListeningLoaderScreen> createState() => _ListeningLoaderScreenState();
}

class _ListeningLoaderScreenState extends State<ListeningLoaderScreen> {
  late Future<(ListeningRunExam, String)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(ListeningRunExam, String)> _load() async {
    final api = context.read<AuthState>().api;
    ExamDto exam;
    if (widget.examId != null && widget.examId!.isNotEmpty) {
      exam = await api.getExam(widget.examId!);
    } else {
      final list = await api.listExams(skill: 'listening', status: 'published');
      final runners = list.where((e) => e.format == 'runner').toList();
      if (runners.isEmpty) {
        throw ApiException(404, 'No listening exams are published yet.');
      }
      exam = runners.first;
    }
    return (listeningExamFromContent(exam.content), exam.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(ListeningRunExam, String)>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snap.hasError) {
          final msg = snap.error is ApiException
              ? (snap.error as ApiException).message
              : 'Could not load the listening exam.';
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyStateView(
                  icon: Icons.headphones_rounded,
                  title: 'Listening unavailable',
                  description: msg,
                  action: FilledButton(
                      onPressed: () => setState(() => _future = _load()),
                      child: const Text('Retry')),
                ),
              ),
            ),
          );
        }
        final (exam, id) = snap.data!;
        return ListeningRunnerScreen(exam: exam, examId: id);
      },
    );
  }
}
