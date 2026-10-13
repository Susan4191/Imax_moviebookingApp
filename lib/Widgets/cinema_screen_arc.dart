import 'package:flutter/material.dart';
import '../utils/app_color.dart';
import '../utils/app_text_style.dart';

class CinemaScreenArc extends StatelessWidget {
  const CinemaScreenArc({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            /// Curved screen line with cyan glow
            CustomPaint(size: const Size(320, 35), painter: _ArcPainter()),

            /// Glow ambient backdrop
            Container(
              width: 220,
              height: 25,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    const Color(0xFF00C6FF).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'S C R E E N',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColor.textSecondary,
            letterSpacing: 4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final path = Path()..addArc(rect, 3.14159, 3.14159);

    /// Outer glow paint
    final glowPaint = Paint()
      ..color = const Color(0xFF00C6FF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    /// Core line paint with cyan gradient
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF00D2FF),
          Colors.white,
          Color(0xFF00D2FF),
          Colors.transparent,
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
