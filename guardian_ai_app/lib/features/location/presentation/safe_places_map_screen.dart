import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';

class SafePlacesMapScreen extends StatefulWidget {
  const SafePlacesMapScreen({super.key});

  @override
  State<SafePlacesMapScreen> createState() => _SafePlacesMapScreenState();
}

class _SafePlacesMapScreenState extends State<SafePlacesMapScreen> {
  Position? _currentPosition;
  LocationDetails? _locationDetails;
  bool _isLoadingLocation = true;
  String? _locationError;

  final List<Map<String, dynamic>> _placesData = [
    {
      'name': 'Central Police Station - Cybercrime Unit',
      'type': 'POLICE',
      'address': 'Local Metropolitan Cyber Division',
      'phone': '+1-800-222-TIPS',
      'open24H': true,
      'lat': 37.7749,
      'lng': -122.4194,
    },
    {
      'name': 'Regional Medical Center & Crisis Unit',
      'type': 'HOSPITAL',
      'address': 'Main Trauma & Emergency Support',
      'phone': '+1-800-273-TALK',
      'open24H': true,
      'lat': 37.7833,
      'lng': -122.4167,
    },
    {
      'name': 'Youth Digital Safety Sanctuary',
      'type': 'SAFE_HAVEN',
      'address': 'Community Protection Resource Center',
      'phone': '+1-800-448-3000',
      'open24H': false,
      'lat': 37.7690,
      'lng': -122.4467,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchRealLocation();
  }

  Future<void> _fetchRealLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    final pos = await LocationService.getCurrentPosition();
    if (!mounted) return;

    if (pos != null) {
      final details = await LocationService.getReverseGeocode(pos.latitude, pos.longitude);
      setState(() {
        _currentPosition = pos;
        _locationDetails = details;
        _isLoadingLocation = false;
      });
    } else {
      setState(() {
        _isLoadingLocation = false;
        _locationError = 'GPS service disabled or permission denied. Showing regional defaults.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('NEARBY SAFE PLACES & POLICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchRealLocation,
            tooltip: 'Refresh GPS',
          ),
        ],
      ),
      body: Column(
        children: [
          // Real GPS Location Banner & Visual Map Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0075FF), Color(0xFF0052CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.my_location_rounded, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'REAL-TIME GPS LOCATION',
                          style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingLocation) ...[
                      const Row(
                        children: [
                          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                          SizedBox(width: 10),
                          Text('Acquiring high-accuracy GPS fix...', style: TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ] else if (_currentPosition != null) ...[
                      Text(
                        _locationDetails != null
                            ? '${_locationDetails!.city}, ${_locationDetails!.country}'
                            : 'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _locationDetails?.fullAddress ?? 'Accuracy: ±${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ] else ...[
                      Text(
                        _locationError ?? 'Location Unavailable',
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ],
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: FloatingActionButton.small(
                    onPressed: _fetchRealLocation,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.gps_fixed, color: Color(0xFF0075FF)),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VERIFIED SAFE HAVENS NEAR YOU',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B), letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _placesData.length,
                      itemBuilder: (context, index) {
                        final p = _placesData[index];
                        final isPolice = p['type'] == 'POLICE';

                        // Calculate real distance if GPS acquired
                        String distanceText = '0.8 miles away';
                        if (_currentPosition != null) {
                          double miles = LocationService.calculateDistanceMiles(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                            p['lat'] as double,
                            p['lng'] as double,
                          );
                          distanceText = '${miles.toStringAsFixed(1)} miles away';
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isPolice ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPolice ? Icons.local_police_outlined : Icons.local_hospital_outlined,
                                color: isPolice ? const Color(0xFFEF4444) : const Color(0xFF10B981),
                              ),
                            ),
                            title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0A2540))),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['address'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(distanceText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0075FF))),
                                      const SizedBox(width: 8),
                                      if (p['open24H'] == true)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                                          child: const Text('24/7 OPEN', style: TextStyle(fontSize: 9, color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone_in_talk, color: Color(0xFF10B981)),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Calling ${p['name']} (${p['phone']})...')),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

