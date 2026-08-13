import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/location_service.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/services/api_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _detectedCountry = "Detecting country...";

  @override
  void initState() {
    super.initState();
    _loadLocationAndCountry();
  }

  Future<void> _loadLocationAndCountry() async {
    final country = await LocationService.detectUserCountry();
    if (mounted) {
      ref.read(profileProvider.notifier).updateProfile(country: country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('USER PROFILE & SETTINGS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // User Avatar Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryRoyalBlue,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 12),
                    Text(ref.watch(profileProvider).fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(ref.watch(profileProvider).email, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.primarySky),
                        const SizedBox(width: 4),
                        Text(ref.watch(profileProvider).country, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentMint.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('PROVO GUARD PROTECTED', style: TextStyle(color: AppColors.accentMint, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Settings Options List
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline, color: AppColors.primaryRoyalBlue),
                    title: const Text('Account Settings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/account-settings'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryRoyalBlue),
                    title: const Text('Privacy & Security Center', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/privacy-center'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.supervisor_account_outlined, color: AppColors.primaryRoyalBlue),
                    title: const Text('Parent Connection & Dashboard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/parent-dashboard'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_none_outlined, color: AppColors.primaryRoyalBlue),
                    title: const Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/notification-preferences'),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primaryRoyalBlue),
                    title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    value: ref.watch(themeModeProvider) == ThemeMode.dark,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).toggleTheme(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: AppColors.primaryRoyalBlue),
                    title: const Text('Help & Support Center', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: AppColors.primaryRoyalBlue),
                    title: const Text('About Provo Guard', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('v1.0.0 • UNESCO Digital Safety Standards'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.riskCritical)),
                onPressed: () async {
                  await ApiService.logout();
                  if (context.mounted) {
                    context.go('/welcome');
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.riskCritical),
                label: const Text('Log Out', style: TextStyle(color: AppColors.riskCritical, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
