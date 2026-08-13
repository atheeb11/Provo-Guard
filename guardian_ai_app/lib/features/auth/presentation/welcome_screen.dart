import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              // Language Selector Header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.lightBorder),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.language, size: 16, color: AppColors.primaryRoyalBlue),
                        SizedBox(width: 6),
                        Text('English (US)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        Icon(Icons.arrow_drop_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Friendly Welcome Graphic Card
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.primaryRoyalBlue.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.security_rounded,
                    size: 72,
                    color: AppColors.primaryRoyalBlue,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Welcome to Provo Guard',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your AI companion for digital safety and cyber threat prevention. Protecting you before harm happens.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondaryLight, height: 1.5),
              ),

              const Spacer(),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRoyalBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.push('/register'),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 14)),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: AppColors.primaryRoyalBlue, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
