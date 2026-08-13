import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/location_service.dart';

class EmergencyModeScreen extends StatefulWidget {
  const EmergencyModeScreen({super.key});

  @override
  State<EmergencyModeScreen> createState() => _EmergencyModeScreenState();
}

class _EmergencyModeScreenState extends State<EmergencyModeScreen> {
  int _secondsRemaining = 3;
  Timer? _timer;
  bool _isActivated = false;
  bool _isCancelled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        _triggerEmergencyAlert();
      }
    });
  }

  void _cancelEmergency() {
    _timer?.cancel();
    setState(() => _isCancelled = true);
    context.pop();
  }

  Future<void> _triggerEmergencyAlert() async {
    setState(() => _isActivated = true);
    final pos = await LocationService.getCurrentPosition();
    final lat = pos?.latitude ?? 37.7749;
    final lng = pos?.longitude ?? -122.4194;
    await ApiService.triggerEmergency(
      lat: lat,
      lng: lng,
      customMessage: 'EMERGENCY: Coercive extortion threat detected.',
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isActivated ? AppColors.darkBackground : AppColors.riskCritical.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ONE-TAP EMERGENCY MODE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _cancelEmergency,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isActivated) ...[
                const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  'DISPATCHING EMERGENCY ALERT',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Broadcasting live GPS coordinates & evidence summary to your trusted emergency contacts and nearby police cybercrime unit.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 30),

                // Countdown Timer Circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      '$_secondsRemaining',
                      style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.riskCritical,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _cancelEmergency,
                    child: const Text('ABORT EMERGENCY ALERT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ] else ...[
                // Activated State Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.green, size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        'EMERGENCY ALERT DISPATCHED',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Alert sent to: Sarah Vance (Mother) & Police Cybercrime Unit.\nIncident Report PDF generated and locked in Vault.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondaryDark, height: 1.4),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primarySky,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        onPressed: () => context.push('/safe-places'),
                        icon: const Icon(Icons.navigation, color: Colors.white),
                        label: const Text('Navigate to Nearby Safe Haven', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('Return to Home Dashboard'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
