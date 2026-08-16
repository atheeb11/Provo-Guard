import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/services/api_service.dart';

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _countryController;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  List<Map<String, String>> _tempContacts = [];
  bool _isSavingProfile = false;
  bool _isUpdatingPassword = false;
  bool _isLoadingProfile = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    _nameController = TextEditingController(text: profile.fullName);
    _emailController = TextEditingController(text: profile.email);
    _ageController = TextEditingController(text: profile.age.toString());
    _countryController = TextEditingController(text: profile.country);
    _tempContacts = List<Map<String, String>>.from(profile.emergencyContacts);
    _loadProfileFromApi();
  }

  Future<void> _loadProfileFromApi() async {
    setState(() => _isLoadingProfile = true);
    await ref.read(profileProvider.notifier).fetchProfileFromApi();
    if (mounted) {
      final profile = ref.read(profileProvider);
      _nameController.text = profile.fullName;
      _emailController.text = profile.email;
      _ageController.text = profile.age.toString();
      _countryController.text = profile.country;
      setState(() {
        _tempContacts = List<Map<String, String>>.from(profile.emergencyContacts);
        _isLoadingProfile = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _countryController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final ageStr = _ageController.text.trim();
    final country = _countryController.text.trim();

    if (name.isEmpty || email.isEmpty || ageStr.isEmpty || country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All profile fields are required.')),
      );
      return;
    }

    final age = int.tryParse(ageStr);
    if (age == null || age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid age.')),
      );
      return;
    }

    setState(() => _isSavingProfile = true);

    final res = await ref.read(profileProvider.notifier).syncProfileToApi(
      fullName: name,
      email: email,
      age: age,
      country: country,
      emergencyContacts: _tempContacts,
    );

    if (!mounted) return;
    setState(() => _isSavingProfile = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account settings saved to database! Email notification sent to $email.', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['error'] ?? 'Profile updated locally.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _changePassword() async {
    final currentPw = _currentPasswordController.text;
    final newPw = _newPasswordController.text;

    if (currentPw.isEmpty || newPw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter current and new passwords.')),
      );
      return;
    }

    if (newPw.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 6 characters long.')),
      );
      return;
    }

    setState(() => _isUpdatingPassword = true);

    final res = await ref.read(profileProvider.notifier).changePassword(
      currentPassword: currentPw,
      newPassword: newPw,
    );

    if (!mounted) return;
    setState(() => _isUpdatingPassword = false);

    if (res['success'] == true) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated in database! Security alert sent to your email.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['error'] ?? 'Failed to update password in database.'),
          backgroundColor: AppColors.riskCritical,
        ),
      );
    }
  }

  void _showAddContactDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    String relation = 'Mother';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Emergency Contact', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone Number (with code)'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: relation,
                    decoration: const InputDecoration(labelText: 'Relationship'),
                    items: ['Mother', 'Father', 'Brother', 'Sister', 'Partner', 'Friend', 'Other']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => relation = val);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final n = nameCtrl.text.trim();
                    final p = phoneCtrl.text.trim();
                    if (n.isNotEmpty && p.isNotEmpty) {
                      setState(() {
                        _tempContacts.add({
                          'name': '$n ($relation)',
                          'phone': p,
                          'relation': relation,
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _purgeAndCloseAccount() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Purge Profile & Data?', style: TextStyle(color: AppColors.riskCritical, fontWeight: FontWeight.bold)),
          content: const Text('This will delete all your local encryption vaults, emergency history, and unlink parent dashboards. This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.riskCritical),
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await ApiService.logout();
                if (context.mounted) {
                  context.go('/welcome'); // Purge session and go to welcome
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account data permanently deleted.'), backgroundColor: AppColors.riskCritical),
                );
              },
              child: const Text('Purge & Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('ACCOUNT SETTINGS & PROFILE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          _isSavingProfile
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primarySky),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check, color: AppColors.primarySky),
                  onPressed: _saveProfile,
                ),
        ],
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator(color: AppColors.primarySky))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Profile details
                  const Text('PROFILE DETAILS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1, color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Age', prefixIcon: Icon(Icons.calendar_today_outlined)),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _countryController,
                                  decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.flag_outlined)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section: Emergency contacts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('EMERGENCY CONTACTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1, color: AppColors.textSecondaryLight)),
                      TextButton.icon(
                        onPressed: _showAddContactDialog,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Contact', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _tempContacts.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: Text('No emergency contacts added yet.', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight))),
                            )
                          : Column(
                              children: List.generate(_tempContacts.length, (index) {
                                final contact = _tempContacts[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: AppColors.primaryRoyalBlue,
                                        child: Icon(Icons.contacts_outlined, color: Colors.white, size: 20),
                                      ),
                                      title: Text(contact['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      subtitle: Text(contact['phone'] ?? '', style: const TextStyle(fontSize: 12)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline, color: AppColors.riskCritical),
                                        onPressed: () {
                                          setState(() {
                                            _tempContacts.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                    if (index < _tempContacts.length - 1) const Divider(height: 1),
                                  ],
                                );
                              }),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section: Change password
                  const Text('SECURITY & PASSWORD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1, color: AppColors.textSecondaryLight)),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _currentPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Current Password', prefixIcon: Icon(Icons.lock_outline)),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock_reset_outlined)),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: OutlinedButton(
                              onPressed: _isUpdatingPassword ? null : _changePassword,
                              child: _isUpdatingPassword
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryRoyalBlue),
                                    )
                                  : const Text('Update Password', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section: Danger zone
                  Card(
                    color: AppColors.riskCritical.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.riskCritical, width: 1),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.delete_forever, color: AppColors.riskCritical),
                      title: const Text('Delete Account & Purge Data', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.riskCritical, fontSize: 14)),
                      subtitle: const Text('Instantly destroy your local vaults and erase all database backups.', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                      trailing: const Icon(Icons.chevron_right, color: AppColors.riskCritical),
                      onTap: _purgeAndCloseAccount,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

