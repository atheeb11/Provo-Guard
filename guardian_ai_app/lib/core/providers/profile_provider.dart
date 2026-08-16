import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

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
    fullName: 'User Profile',
    email: 'user@provo.guard',
    age: 20,
    country: 'United States',
    emergencyContacts: const [],
  ));

  void setProfileFromUser(Map<String, dynamic> user) {
    final rawContacts = user['emergencyContacts'];
    List<Map<String, String>> contacts = [];
    if (rawContacts is List) {
      contacts = rawContacts.map((c) => Map<String, String>.from(c as Map)).toList();
    }

    state = state.copyWith(
      fullName: user['fullName']?.toString() ?? state.fullName,
      email: user['email']?.toString() ?? state.email,
      age: user['age'] != null ? int.tryParse(user['age'].toString()) ?? state.age : state.age,
      country: user['country']?.toString() ?? state.country,
      emergencyContacts: contacts.isNotEmpty ? contacts : state.emergencyContacts,
    );
  }

  Future<void> fetchProfileFromApi() async {
    final res = await ApiService.getProfile();
    if (res['success'] == true && res['user'] != null) {
      setProfileFromUser(Map<String, dynamic>.from(res['user']));
    }
  }

  void updateProfile({String? fullName, String? email, int? age, String? country}) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      age: age,
      country: country,
    );
  }

  Future<Map<String, dynamic>> syncProfileToApi({
    required String fullName,
    required String email,
    required int age,
    required String country,
    required List<Map<String, String>> emergencyContacts,
  }) async {
    // Update local state first
    state = state.copyWith(
      fullName: fullName,
      email: email,
      age: age,
      country: country,
      emergencyContacts: emergencyContacts,
    );

    // Call backend API to persist to DB & trigger email
    final result = await ApiService.updateProfile(
      fullName: fullName,
      email: email,
      age: age,
      country: country,
      emergencyContacts: emergencyContacts,
    );

    return result;
  }

  Future<Map<String, dynamic>> updateEmergencyContacts(List<Map<String, String>> contacts) async {
    state = state.copyWith(emergencyContacts: contacts);
    return await ApiService.updateEmergencyContacts(contacts);
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await ApiService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

