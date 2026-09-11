import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/brand.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../theme/app_colors.dart';

const _examTypes = [
  ('IELTS (Academic/General)', '🎓'),
  ('TOEFL', '📗'),
  ('PTE Academic', '🏫'),
  ('Duolingo English Test', '🦉'),
  ('Cambridge English', '🎯'),
  ('Other English Exam', '📝'),
];
const _purposes = [
  ('Study Abroad', '🎓'),
  ('Immigration/PR', '✈️'),
  ('Work Abroad', '💼'),
  ('Local University', '🏛️'),
  ('Career Advancement', '📈'),
  ('I am a Teacher', '🧑‍🏫'),
];
const _levels = [
  ('beginner', 'Beginner', 'Just starting out', '🌱'),
  ('elementary', 'Elementary', 'Basic understanding', '🌿'),
  ('intermediate', 'Intermediate', 'Good conversation skills', '🌳'),
  ('upper-intermediate', 'Upper Intermediate', 'Confident speaker', '🌲'),
  ('advanced', 'Advanced', 'Near-native fluency', '🌴'),
];
const _bands = ['5.0', '5.5', '6.0', '6.5', '7.0', '7.5', '8.0', '8.5', '9.0'];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 1; // 1..4
  String _examType = 'IELTS (Academic/General)';
  String _purpose = '';
  DateTime? _examDate;
  String _level = '';
  String _target = '6.5';
  bool _saving = false;

  int? get _daysUntil {
    final d = _examDate;
    if (d == null) return null;
    return d.difference(DateTime.now()).inDays.clamp(0, 100000);
  }

  Future<void> _complete() async {
    final auth = context.read<AuthState>();
    setState(() => _saving = true);
    try {
      await auth.updateMe({
        'examType': _examType,
        'purpose': _purpose,
        'level': _level,
        'targetBand': double.parse(_target),
        'examDate': _examDate?.toIso8601String().split('T').first ?? '',
        'track': 'ielts',
        'onboarded': true,
      });
      // AuthState notifies -> router redirect moves us to '/'.
    } on ApiException catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate ?? now.add(const Duration(days: 60)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                if (_step > 1) _progress(),
                switch (_step) {
                  1 => _stepWelcome(),
                  2 => _stepExam(),
                  3 => _stepDate(),
                  _ => _stepLevel(),
                },
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _progress() => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton.icon(
              onPressed: () => setState(() => _step -= 1),
              icon: const Icon(Icons.chevron_left, size: 18),
              label: const Text('Back'),
            ),
            Text('Step $_step of 4',
                style: const TextStyle(
                    color: AppColors.mutedForeground, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _step / 4,
              minHeight: 6,
              backgroundColor: AppColors.muted,
              valueColor: const AlwaysStoppedAnimation(AppColors.foreground),
            ),
          ),
        ]),
      );

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: child,
      );

  Widget _stepWelcome() => _card(
        child: Column(children: [
          Container(
            width: 72, height: 72,
            decoration: const BoxDecoration(
                gradient: AppColors.warmGradient, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text(Brand.logoInitial,
                style: TextStyle(
                    color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 20),
          const Text('Welcome to ${Brand.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 10),
          const Text('Answer 3 quick questions to personalize your learning experience',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedForeground)),
          const SizedBox(height: 14),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.access_time, size: 16, color: AppColors.mutedForeground),
            SizedBox(width: 6),
            Text('Less than 1 minute',
                style: TextStyle(color: AppColors.mutedForeground)),
          ]),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(220, 52)),
            onPressed: () => setState(() => _step = 2),
            child: const Text("Let's get started!"),
          ),
        ]),
      );

  Widget _stepExam() => _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _StepHeader(
            icon: Icons.track_changes,
            color: AppColors.info,
            title: 'What exam are you preparing for?',
            subtitle: 'Tell us about your English proficiency goals',
          ),
          const SizedBox(height: 18),
          _choiceGrid(_examTypes, _examType, (k) => setState(() => _examType = k)),
          const SizedBox(height: 18),
          const Text('Why are you preparing?',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          _choiceGrid(_purposes, _purpose, (k) => setState(() => _purpose = k)),
          const SizedBox(height: 20),
          Center(
            child: FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
              onPressed: (_examType.isNotEmpty && _purpose.isNotEmpty)
                  ? () => setState(() => _step = 3)
                  : null,
              child: const Text('Continue'),
            ),
          ),
        ]),
      );

  Widget _stepDate() => _card(
        child: Column(children: [
          const _StepHeader(
            icon: Icons.calendar_today,
            color: AppColors.primary,
            title: 'When is your exam?',
            subtitle: "Optional — we'll create a personalized study schedule for you",
            center: true,
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
            onPressed: _pickDate,
            icon: const Icon(Icons.event),
            label: Text(_examDate == null
                ? 'Pick exam date (optional)'
                : _examDate!.toIso8601String().split('T').first),
          ),
          if (_daysUntil != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.info),
                const SizedBox(width: 8),
                Expanded(
                    child: Text('$_daysUntil days until your exam — let\'s make every day count!',
                        style: const TextStyle(color: AppColors.info))),
              ]),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(200, 52)),
            onPressed: () => setState(() => _step = 4),
            child: const Text('Continue'),
          ),
        ]),
      );

  Widget _stepLevel() => _card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _StepHeader(
            icon: Icons.trending_up,
            color: AppColors.success,
            title: "What's your current level?",
            subtitle: 'This helps us personalize your learning experience',
            center: true,
          ),
          const SizedBox(height: 18),
          ..._levels.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => _level = l.$1),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _level == l.$1
                          ? AppColors.success.withValues(alpha: 0.06)
                          : AppColors.surface,
                      border: Border.all(
                          color: _level == l.$1 ? AppColors.success : AppColors.border,
                          width: _level == l.$1 ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Text(l.$4, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(l.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(l.$3,
                              style: const TextStyle(
                                  color: AppColors.mutedForeground, fontSize: 13)),
                        ]),
                      ),
                      if (_level == l.$1)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                    ]),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          const Text('Target Band Score (IELTS) or equivalent',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _target,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: [
              for (final b in _bands)
                DropdownMenuItem(value: b, child: Text('Band $b')),
            ],
            onChanged: (v) => setState(() => _target = v ?? _target),
          ),
          const SizedBox(height: 20),
          Center(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                  minimumSize: const Size(220, 52),
                  backgroundColor: AppColors.success),
              onPressed: (_level.isNotEmpty && !_saving) ? _complete : null,
              icon: _saving
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Complete setup'),
            ),
          ),
        ]),
      );

  Widget _choiceGrid(
      List<(String, String)> items, String selected, void Function(String) onTap) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3.1,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (final (key, emoji) in items)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: selected == key
                    ? AppColors.primary.withValues(alpha: 0.05)
                    : AppColors.surface,
                border: Border.all(
                    color: selected == key ? AppColors.primary : AppColors.border,
                    width: selected == key ? 1.5 : 1),
              ),
              child: Row(children: [
                Text(emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(key,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
              ]),
            ),
          ),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool center;
  const _StepHeader({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 12),
        Text(title,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: const TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
      ],
    );
  }
}
