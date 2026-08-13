import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String fullName;
  final String email;
  final int age;
  final String country;
  final List<Map<String, String>> emergencyContacts;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.age,
    required this.country,
    this.emergencyContacts = const [],
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    int? age,
    String? country,
    List<Map<String, String>>? emergencyContacts,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      age: age ?? this.age,
      country: country ?? this.country,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile(
    fullName: 'Alex Johnson',
    email: 'alex@example.com',
    age: 20,
    country: 'United States',
    emergencyContacts: [
      {'name': 'Sarah Johnson (Mother)', 'phone': '+1-555-0199', 'relation': 'Mother'},
      {'name': 'David Johnson (Father)', 'phone': '+1-555-0198', 'relation': 'Father'},
    ],
  ));

  void updateProfile({String? fullName, String? email, int? age, String? country}) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      age: age,
      country: country,
    );
  }

  void updateEmergencyContacts(List<Map<String, String>> contacts) {
    state = state.copyWith(emergencyContacts: contacts);
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
