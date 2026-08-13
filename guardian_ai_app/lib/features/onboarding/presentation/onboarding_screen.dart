import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/location_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _permissions = [
    {
      'title': 'Visible Conversation Protection',
      'permission': 'Accessibility & Notification Service',
      'reason': 'Scans only visible messages in apps like WhatsApp & Instagram to detect extortion, sextortion, and grooming before harm occurs.',
      'icon': 'shield_outlined',
      'consentNote': 'Never accesses hidden messages or bypasses encryption.',
    },
    {
      'title': 'Document Privacy & OCR Scanner',
      'permission': 'Camera & Media Permission',
      'reason': 'Scans photos locally on your device using Google ML Kit to warn you if a photo contains Passports, IDs, or Credit Cards before sending.',
      'icon': 'camera_alt_outlined',
      'consentNote': 'All image scanning stays 100% private on your phone.',
    },
    {
      'title': 'One-Tap Emergency Dispatch',
      'permission': 'Location & Emergency Contacts',
      'reason': 'Allows instant sharing of your live coordinates with trusted contacts or emergency police stations when you trigger Emergency Mode.',
      'icon': 'location_on_outlined',
      'consentNote': 'Location is shared ONLY after your explicit confirmation.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primarySky.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.security, color: AppColors.primaryLightSky, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'PROVO GUARD',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('Skip', style: TextStyle(color: AppColors.textSecondaryDark)),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  final item = _permissions[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightSky.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getIconData(item['icon']!),
                                size: 40,
                                color: AppColors.primaryLightSky,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              item['title']!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLightSky.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['permission']!,
                                style: const TextStyle(color: AppColors.primaryLightSky, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              item['reason']!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.lock_outline, color: Colors.green, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item['consentNote']!,
                                      style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots & Bottom Action
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _permissions.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.primaryLightSky : AppColors.darkBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
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
                      onPressed: () async {
                        if (_currentPage == 0) {
                          await LocationService.requestPermission(Permission.notification);
                        } else if (_currentPage == 1) {
                          await LocationService.requestPermission(Permission.camera);
                          await LocationService.requestPermission(Permission.photos);
                        } else if (_currentPage == 2) {
                          await LocationService.requestPermission(Permission.location);
                        }

                        if (_currentPage < _permissions.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          context.go('/dashboard');
                        }
                      },
                      child: Text(
                        _currentPage == _permissions.length - 1 ? 'Grant Permission & Start' : 'Next Permission Rationale',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'camera_alt_outlined':
        return Icons.camera_alt_outlined;
      case 'location_on_outlined':
        return Icons.location_on_outlined;
      default:
        return Icons.shield_outlined;
    }
  }
}
