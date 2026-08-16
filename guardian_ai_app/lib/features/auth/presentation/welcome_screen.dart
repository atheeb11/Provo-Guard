import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/provo_guard_logo.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final int _activePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: Stack(
        children: [
          // Background Light Wavy Accents & Bottom Wave
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundWavePainter(),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // Top Logo Header (Provo Guard Shield + Text)
                    const ProvoGuardLogo(size: 96),

                    const SizedBox(height: 24),

                    // Main Heading
                    const Text(
                      'Smart Protection\nFor Your World',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2540),
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Provo Guard helps you stay safe, secure\nand in control—anytime, anywhere.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Center 3D Smartphone Illustration + 4 Feature Node Badges
                    const _SecurityPhoneGraphic(),

                    const SizedBox(height: 20),

                    // Page Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        final isActive = index == _activePageIndex;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 10 : 8,
                          height: isActive ? 10 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFF0075FF) : const Color(0xFFD0E3FF),
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    // Primary Button: Get Started
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF0075FF), Color(0xFF0052CC)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0075FF).withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () => context.push('/register'),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Secondary Outlined Button: I already have an account
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF0075FF).withOpacity(0.4), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0075FF).withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => context.push('/login'),
                        borderRadius: BorderRadius.circular(16),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline, color: Color(0xFF0075FF), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'I already have an account',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0075FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 3D Phone Graphic with Orbital Feature Badges
class _SecurityPhoneGraphic extends StatelessWidget {
  const _SecurityPhoneGraphic();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glowing Orbit Lines
          CustomPaint(
            size: const Size(320, 230),
            painter: _OrbitLinesPainter(),
          ),

          // Center 3D Smartphone Frame
          Container(
            width: 110,
            height: 205,
            decoration: BoxDecoration(
              color: const Color(0xFF0A2540),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0052CC).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0075FF), Color(0xFF0038A8)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Container(
                  width: 52,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Icon(Icons.shield, size: 36, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

          // Feature Badge 1: Top Left - Secure Your Data
          Positioned(
            left: 10,
            top: 25,
            child: _buildFeatureNode(
              icon: Icons.lock_outline,
              label: 'Secure\nYour Data',
            ),
          ),

          // Feature Badge 2: Top Right - Advanced Protection
          Positioned(
            right: 10,
            top: 25,
            child: _buildFeatureNode(
              icon: Icons.verified_user_outlined,
              label: 'Advanced\nProtection',
            ),
          ),

          // Feature Badge 3: Bottom Left - Real-time Alerts
          Positioned(
            left: 10,
            bottom: 25,
            child: _buildFeatureNode(
              icon: Icons.notifications_outlined,
              label: 'Real-time\nAlerts',
            ),
          ),

          // Feature Badge 4: Bottom Right - Empower Communities
          Positioned(
            right: 10,
            bottom: 25,
            child: _buildFeatureNode(
              icon: Icons.groups_outlined,
              label: 'Empower\nCommunities',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureNode({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEBF4FF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0075FF).withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(icon, color: const Color(0xFF0075FF), size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0A2540),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

// Orbit Lines Painter around Phone
class _OrbitLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final orbitPaint = Paint()
      ..color = const Color(0xFF0075FF).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Outer Elliptical Orbit
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.92, height: h * 0.75),
      orbitPaint,
    );

    // Connecting Nodes Glow Dots
    final dotPaint = Paint()..color = const Color(0xFF0075FF).withOpacity(0.4);
    canvas.drawCircle(Offset(w * 0.22, h * 0.28), 3, dotPaint);
    canvas.drawCircle(Offset(w * 0.78, h * 0.28), 3, dotPaint);
    canvas.drawCircle(Offset(w * 0.22, h * 0.72), 3, dotPaint);
    canvas.drawCircle(Offset(w * 0.78, h * 0.72), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Background Wave Overlay Painter (Top & Bottom Curve)
class _BackgroundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top Wave Accent Path
    final topWave = Path()
      ..moveTo(0, h * 0.15)
      ..cubicTo(w * 0.3, h * 0.05, w * 0.7, h * 0.12, w, h * 0.04)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0075FF).withOpacity(0.05),
          const Color(0xFF0052CC).withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.15));

    canvas.drawPath(topWave, topPaint);

    // Bottom Deep Blue Wave Accent Path
    final bottomWave = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(w * 0.35, h * 0.82, w * 0.65, h * 0.94, w, h * 0.86)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final bottomPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0075FF),
          Color(0xFF0052CC),
          Color(0xFF0038A8),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.82, w, h * 0.18));

    canvas.drawPath(bottomWave, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

