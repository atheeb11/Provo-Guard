import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/threat_model.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/welcome_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/dashboard/presentation/dashboard_shell.dart';
import '../../features/dashboard/presentation/home_dashboard_screen.dart';
import '../../features/ai_coach/presentation/ai_coach_screen.dart';
import '../../features/analyze/presentation/analyze_hub_screen.dart';
import '../../features/alerts/presentation/security_alerts_screen.dart';
import '../../features/settings_profile/presentation/profile_screen.dart';
import '../../features/parent_dashboard/presentation/parent_dashboard_screen.dart';
import '../../features/threat_monitor/presentation/xai_risk_detail_screen.dart';
import '../../features/evidence_vault/presentation/evidence_vault_screen.dart';
import '../../features/emergency/presentation/emergency_mode_screen.dart';
import '../../features/location/presentation/safe_places_map_screen.dart';
import '../../features/settings_profile/presentation/privacy_center_screen.dart';
import '../../features/settings_profile/presentation/notification_preferences_screen.dart';
import '../../features/settings_profile/presentation/account_settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final email = state.extra as String? ?? 'alex@guardian.ai';
        return OTPVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/emergency',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EmergencyModeScreen(),
    ),
    GoRoute(
      path: '/vault',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const EvidenceVaultScreen(),
    ),
    GoRoute(
      path: '/safe-places',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SafePlacesMapScreen(),
    ),
    GoRoute(
      path: '/privacy-center',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrivacyCenterScreen(),
    ),
    GoRoute(
      path: '/notification-preferences',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationPreferencesScreen(),
    ),
    GoRoute(
      path: '/account-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/parent-dashboard',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ParentDashboardScreen(),
    ),
    GoRoute(
      path: '/threat-detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final threat = state.extra as ThreatModel? ?? ThreatModel(
          id: 'demo_1',
          riskScore: 92,
          riskLevel: 'Critical',
          category: 'Sextortion',
          appSource: 'WhatsApp',
          scannedTextSnippet: 'Pay \$500 in crypto or I leak your Snapchat photos...',
          explanation: 'Coercive digital extortion threat detected.',
          redFlags: ['Financial demand', 'Exposure threat'],
          actionableSteps: ['DO NOT PAY', 'Save to Vault'],
          psychologicalSupport: 'Take a deep breath. You are safe.',
          timestamp: DateTime.now(),
        );
        return XAIRiskDetailScreen(threat: threat);
      },
    ),

    // 5-Tab Dashboard Shell
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const HomeDashboardScreen(),
        ),
        GoRoute(
          path: '/dashboard/ai-chat',
          builder: (context, state) => const AICoachScreen(),
        ),
        GoRoute(
          path: '/dashboard/analyze',
          builder: (context, state) => const AnalyzeHubScreen(),
        ),
        GoRoute(
          path: '/dashboard/alerts',
          builder: (context, state) => const SecurityAlertsScreen(),
        ),
        GoRoute(
          path: '/dashboard/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
