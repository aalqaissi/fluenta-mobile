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
        const Text('Households with internet access (%)',
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
