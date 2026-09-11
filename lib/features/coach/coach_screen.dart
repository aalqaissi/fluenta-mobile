import 'package:flutter/material.dart';
import '../../config/brand.dart';
import '../../mock/data.dart';
import '../../models/models.dart';
import '../../theme/app_colors.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});
  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final List<CoachMessage> _messages = List.of(initialCoachMessages);
  final _controller = TextEditingController();
  final _scroll = ScrollController();
  final bool _typing = false;

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Brand.coachName)),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
            ),
            child: const Row(children: [
              Icon(Icons.auto_awesome, color: AppColors.onSecondary, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                    '${Brand.coachName} is coming soon — real-time AI coaching on your results is on the way.',
                    style: TextStyle(fontSize: 12.5)),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (i >= _messages.length) return _typingBubble();
                return _bubble(_messages[i]);
              },
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _bubble(CoachMessage m) {
    final isCoach = m.role == 'coach';
    return Align(
      alignment: isCoach ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: isCoach ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                gradient: isCoach ? AppColors.warmGradient : null,
                color: isCoach ? null : AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(isCoach ? Icons.smart_toy_rounded : Icons.person_rounded,
                  size: 18, color: isCoach ? Colors.white : AppColors.foreground),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isCoach ? AppColors.muted : AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(m.text,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                        height: 1.4, fontSize: 14, color: isCoach ? AppColors.foreground : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(16)),
        child: const SizedBox(
          width: 30,
          child: Text('…', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.mutedForeground)),
        ),
      ),
    );
  }

  Widget _composer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: false, // AI held
              decoration: const InputDecoration(hintText: 'Chat coming soon…'),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(52, 52), padding: EdgeInsets.zero, shape: const CircleBorder()),
            onPressed: null, // AI held
            child: const Icon(Icons.send_rounded, size: 20),
          ),
        ]),
      ),
    );
  }
}
