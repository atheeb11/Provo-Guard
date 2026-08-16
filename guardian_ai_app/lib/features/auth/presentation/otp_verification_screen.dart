import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/widgets/provo_guard_logo.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;
  int _focusedIndex = 0;

  // Countdown timer: 3 minutes (180 seconds)
  Timer? _timer;
  int _startSeconds = 165; // 02:45

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() => _focusedIndex = i);
        }
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _startSeconds = 165);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startSeconds > 0) {
        if (mounted) {
          setState(() => _startSeconds--);
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  String get _formattedTimer {
    final minutes = (_startSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_startSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text.trim()).join();
    if (otp.length < 6) {
      setState(() => _errorMessage = 'Please enter all 6 verification digits.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final res = await ApiService.verifyOtp(
      email: widget.email.isEmpty ? 'mubarak.atheeb@email.com' : widget.email,
      otp: otp,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success'] == true) {
        if (res['token'] != null) {
          ApiService.authToken = res['token'];
        }
        if (res['user'] != null) {
          ref.read(profileProvider.notifier).setProfileFromUser(Map<String, dynamic>.from(res['user']));
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account verified successfully!', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/onboarding');
      } else {
        setState(() => _errorMessage = res['error'] ?? 'Invalid verification code. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayEmail = widget.email.isEmpty ? 'mubarak.atheeb@email.com' : widget.email;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Row: Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF0A2540), size: 24),
                      onPressed: () => context.pop(),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Brand Header (Logo + PROVO GUARD + Tagline)
                  const ProvoGuardLogo(size: 90),

                  const SizedBox(height: 24),

                  // Heading Text
                  const Text(
                    'Verify Your Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2540),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle Email Note
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                      children: [
                        const TextSpan(text: "We've sent a 6-digit verification code to\n"),
                        TextSpan(
                          text: displayEmail,
                          style: const TextStyle(
                            color: Color(0xFF0075FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please enter the code below to verify your account.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // 6 OTP Digit Input Boxes Grid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      final isFocused = _focusedIndex == index;
                      final hasValue = _controllers[index].text.isNotEmpty;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 44,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isFocused
                                ? const Color(0xFF0075FF)
                                : (hasValue ? const Color(0xFF0075FF).withOpacity(0.5) : const Color(0xFFE2E8F0)),
                            width: isFocused ? 1.8 : 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isFocused
                                  ? const Color(0xFF0075FF).withOpacity(0.12)
                                  : Colors.black.withOpacity(0.02),
                              blurRadius: isFocused ? 8 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2540),
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            setState(() {});
                            if (value.isNotEmpty) {
                              if (index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else {
                                _focusNodes[index].unfocus();
                                _verifyOtp();
                              }
                            } else {
                              if (index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                  // Countdown Timer: ⏱ Code expires in 02:45
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 6),
                      const Text(
                        'Code expires in ',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      Text(
                        _formattedTimer,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0075FF),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Resend Code Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't receive the code? ",
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      GestureDetector(
                        onTap: () {
                          for (var c in _controllers) {
                            c.clear();
                          }
                          _startTimer();
                          _focusNodes[0].requestFocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('A new 6-digit verification code has been dispatched.')),
                          );
                        },
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0075FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Secure Verification Callout Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF4FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFD0E3FF)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0075FF).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.shield_outlined, color: Color(0xFF0075FF), size: 22),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Verification',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A2540),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Your security is our priority. This helps us keep your account safe.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Primary Button: Verify Account
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
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Verify Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider: —— or verify with ——
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'or verify with',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Secondary Button: Verify with Email Link
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('A magic verification link has been sent to your email inbox.')),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email_outlined, color: Color(0xFF0075FF), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Verify with Email Link',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0A2540),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer Link: Having trouble? Contact Support
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Having trouble? ',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Contacting Provo Guard 24/7 Security Support...')),
                          );
                        },
                        child: const Text(
                          'Contact Support',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0075FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Background Wave Overlay Painter (Top & Bottom Curve)
class _BackgroundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top Wave Accent Path
    final topWave = Path()
      ..moveTo(0, h * 0.12)
      ..cubicTo(w * 0.3, h * 0.04, w * 0.7, h * 0.1, w, h * 0.03)
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
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.12));

    canvas.drawPath(topWave, topPaint);

    // Bottom Deep Blue Wave Accent Path
    final bottomWave = Path()
      ..moveTo(0, h * 0.9)
      ..cubicTo(w * 0.35, h * 0.84, w * 0.65, h * 0.95, w, h * 0.88)
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
      ).createShader(Rect.fromLTWH(0, h * 0.84, w, h * 0.16));

    canvas.drawPath(bottomWave, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

