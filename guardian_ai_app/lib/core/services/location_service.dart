import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String city;
  final String state;
  final String country;
  final String fullAddress;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.state,
    required this.country,
    required this.fullAddress,
  });
}

class LocationService {
  /// Fetch the user's country using IP-based geolocation or live GPS coordinates
  static Future<String> detectUserCountry() async {
    try {
      final pos = await getCurrentPosition();
      if (pos != null) {
        final locDetails = await getReverseGeocode(pos.latitude, pos.longitude);
        if (locDetails != null && locDetails.country.isNotEmpty) {
          return locDetails.country;
        }
      }
    } catch (_) {}

    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final country = data['country_name'] ?? 'United States';
        return country;
      }
    } catch (_) {}

    return 'United States';
  }

  /// Get live device GPS position (High Accuracy)
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location service is disabled on device
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 8),
      );
    } catch (e) {
      return null;
    }
  }

  /// Reverse geocode GPS coordinates to real city, state, country, and address
  static Future<LocationDetails?> getReverseGeocode(double lat, double lng) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lng&format=json');
      final response = await http.get(url, headers: {
        'User-Agent': 'ProvoGuard/1.0',
      }).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] ?? {};
        final city = address['city'] ?? address['town'] ?? address['village'] ?? address['county'] ?? 'Local Area';
        final state = address['state'] ?? '';
        final country = address['country'] ?? '';
        final fullAddress = data['display_name'] ?? '$lat, $lng';

        return LocationDetails(
          latitude: lat,
          longitude: lng,
          city: city,
          state: state,
          country: country,
          fullAddress: fullAddress,
        );
      }
    } catch (_) {}
    return null;
  }

  /// Calculate distance between two coordinates in miles
  static double calculateDistanceMiles(double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters = Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
    return distanceInMeters / 1609.344;
  }

  /// Request actual OS permissions for onboarding
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }
}

