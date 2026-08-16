import 'package:flutter/material.dart';

class ProvoGuardLogo extends StatelessWidget {
  final double size;
  const ProvoGuardLogo({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/provo_guard_logo.png',
      width: size * 2.5,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: size,
              height: size * 1.15,
              child: CustomPaint(
                painter: _ShieldPainter(),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'PROVO ',
                    style: TextStyle(
                      color: Color(0xFF0A2540),
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                  TextSpan(
                    text: 'GUARD',
                    style: TextStyle(
                      color: Color(0xFF0075FF),
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                      fontFamily: 'sans-serif',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 28, height: 1.5, color: const Color(0xFF0A2540).withOpacity(0.3)),
                const SizedBox(width: 8),
                const Text(
                  'PROTECT. EMPOWER. PREVENT.',
                  style: TextStyle(
                    color: Color(0xFF0A2540),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 28, height: 1.5, color: const Color(0xFF0A2540).withOpacity(0.3)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Shield Shadow / Glow
    final shadowPath = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.96, h * 0.18)
      ..lineTo(w * 0.96, h * 0.48)
      ..cubicTo(w * 0.96, h * 0.78, w * 0.62, h * 0.96, w * 0.5, h)
      ..cubicTo(w * 0.38, h * 0.96, w * 0.04, h * 0.78, w * 0.04, h * 0.48)
      ..lineTo(w * 0.04, h * 0.18)
      ..close();

    canvas.drawShadow(shadowPath, const Color(0xFF0052CC).withOpacity(0.3), 8, true);

    // Left Facet Shield
    final leftShield = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.04, h * 0.18)
      ..lineTo(w * 0.04, h * 0.48)
      ..cubicTo(w * 0.04, h * 0.78, w * 0.38, h * 0.96, w * 0.5, h)
      ..close();

    final leftGrad = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF00A2FF), Color(0xFF0066FF)],
    );

    canvas.drawPath(leftShield, Paint()..shader = leftGrad.createShader(Rect.fromLTWH(0, 0, w, h)));

    // Right Facet Shield
    final rightShield = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.96, h * 0.18)
      ..lineTo(w * 0.96, h * 0.48)
      ..cubicTo(w * 0.96, h * 0.78, w * 0.62, h * 0.96, w * 0.5, h)
      ..close();

    final rightGrad = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF0052CC), Color(0xFF0038A8)],
    );

    canvas.drawPath(rightShield, Paint()..shader = rightGrad.createShader(Rect.fromLTWH(0, 0, w, h)));

    // Inner White Shield Frame Cutout
    final innerFrame = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..lineTo(w * 0.86, h * 0.24)
      ..lineTo(w * 0.86, h * 0.48)
      ..cubicTo(w * 0.86, h * 0.72, w * 0.58, h * 0.87, w * 0.5, h * 0.9)
      ..cubicTo(w * 0.42, h * 0.87, w * 0.14, h * 0.72, w * 0.14, h * 0.48)
      ..lineTo(w * 0.14, h * 0.24)
      ..close();

    canvas.drawPath(innerFrame, Paint()..color = Colors.white);

    // Inner 'P' Shield Graphic
    final pGraphic = Path()
      ..moveTo(w * 0.32, h * 0.24)
      ..lineTo(w * 0.65, h * 0.24)
      ..cubicTo(w * 0.86, h * 0.24, w * 0.86, h * 0.52, w * 0.65, h * 0.52)
      ..lineTo(w * 0.52, h * 0.52)
      ..lineTo(w * 0.52, h * 0.78)
      ..cubicTo(w * 0.62, h * 0.72, w * 0.72, h * 0.6, w * 0.72, h * 0.48)
      ..lineTo(w * 0.42, h * 0.48)
      ..lineTo(w * 0.42, h * 0.72)
      ..lineTo(w * 0.32, h * 0.72)
      ..close();

    final pGrad = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFF0075FF), Color(0xFF0044CC)],
    );

    canvas.drawPath(pGraphic, Paint()..shader = pGrad.createShader(Rect.fromLTWH(0, 0, w, h)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
