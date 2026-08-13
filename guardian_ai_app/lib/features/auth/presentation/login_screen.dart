import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _doLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final res = await ApiService.login(email: email, password: password);

    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success'] == true) {
        if (res['token'] != null) {
          ApiService.authToken = res['token'];
        }
        context.go('/onboarding');
      } else if (res['requiresVerification'] == true) {
        context.push('/verify-otp', extra: email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'] ?? 'Login failed. Please check credentials.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primarySky.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_rounded, color: AppColors.primaryLightSky, size: 40),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'PROVO GUARD',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
              ),
              const Center(
                child: Text(
                  'AI Companion Against Cyber Extortion & Exploitation',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                ),
              ),
              const SizedBox(height: 40),

              const Text('Welcome Back', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Sign in to access your encrypted protection vault', style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 24),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySky,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _doLogin,
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign In to Guardian AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
                  onPressed: _doLogin,
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: const Text('Continue with Google Sign-In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
