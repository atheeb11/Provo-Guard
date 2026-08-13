import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SafePlacesMapScreen extends StatelessWidget {
  const SafePlacesMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = [
      {
        'name': 'Central Police Station - Cybercrime Unit',
        'type': 'POLICE',
        'address': '750 Bryant St, San Francisco, CA 94103',
        'distance': '0.8 miles away',
        'phone': '+1-415-553-0123',
        'open24H': true,
      },
      {
        'name': 'UCSF Medical Center & Crisis Support',
        'type': 'HOSPITAL',
        'address': '505 Parnassus Ave, San Francisco, CA 94143',
        'distance': '2.1 miles away',
        'phone': '+1-415-476-1000',
        'open24H': true,
      },
      {
        'name': 'Youth Digital Safety Sanctuary & Resource Center',
        'type': 'SAFE_HAVEN',
        'address': '1000 Van Ness Ave, San Francisco, CA 94109',
        'distance': '1.4 miles away',
        'phone': '+1-415-998-3321',
        'open24H': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEARBY SAFE PLACES & POLICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Column(
        children: [
          // Google Maps Embed Visual Container
          Container(
            height: 220,
            width: double.infinity,
            color: AppColors.darkCard,
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.darkBackground, AppColors.darkSurface],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 48, color: AppColors.primaryLightSky),
                        SizedBox(height: 8),
                        Text('Google Maps SDK Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Pinpointing 3 verified safe places within 2.5 miles', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: FloatingActionButton.small(
                    onPressed: () {},
                    backgroundColor: AppColors.primarySky,
                    child: const Icon(Icons.my_location, color: Colors.white),
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
                  const Text('VERIFIED SAFE HAVENS NEAR YOU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final p = places[index];
                        final isPolice = p['type'] == 'POLICE';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isPolice ? AppColors.riskCritical.withOpacity(0.2) : Colors.green.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPolice ? Icons.local_police : Icons.local_hospital,
                                color: isPolice ? AppColors.riskCritical : Colors.green,
                              ),
                            ),
                            title: Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['address'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(p['distance'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryLightSky)),
                                      const SizedBox(width: 8),
                                      if (p['open24H'] == true)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                                          child: const Text('24/7 OPEN', style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone, color: Colors.green),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Dialing ${p['name']} (${p['phone']})...')),
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
