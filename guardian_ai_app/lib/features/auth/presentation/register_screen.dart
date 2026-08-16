import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/location_service.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/widgets/provo_guard_logo.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedCountry = 'United States';
  String _selectedDialCode = '+1';
  String _selectedFlag = '🇺🇸';

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String? _errorMessage;

  final Map<String, Map<String, String>> _countryData = {
    'Afghanistan': {'code': '+93', 'flag': '🇦🇫'},
    'Albania': {'code': '+355', 'flag': '🇦🇱'},
    'Algeria': {'code': '+213', 'flag': '🇩🇿'},
    'Andorra': {'code': '+376', 'flag': '🇦🇩'},
    'Angola': {'code': '+244', 'flag': '🇦🇴'},
    'Argentina': {'code': '+54', 'flag': '🇦🇷'},
    'Armenia': {'code': '+374', 'flag': '🇦🇲'},
    'Australia': {'code': '+61', 'flag': '🇦🇺'},
    'Austria': {'code': '+43', 'flag': '🇦🇹'},
    'Azerbaijan': {'code': '+994', 'flag': '🇦🇿'},
    'Bahamas': {'code': '+1-242', 'flag': '🇧🇸'},
    'Bahrain': {'code': '+973', 'flag': '🇧🇭'},
    'Bangladesh': {'code': '+880', 'flag': '🇧🇩'},
    'Barbados': {'code': '+1-246', 'flag': '🇧🇧'},
    'Belarus': {'code': '+375', 'flag': '🇧🇾'},
    'Belgium': {'code': '+32', 'flag': '🇧🇪'},
    'Belize': {'code': '+501', 'flag': '🇧🇿'},
    'Benin': {'code': '+229', 'flag': '🇧🇯'},
    'Bhutan': {'code': '+975', 'flag': '🇧🇹'},
    'Bolivia': {'code': '+591', 'flag': '🇧🇴'},
    'Bosnia & Herzegovina': {'code': '+387', 'flag': '🇧🇦'},
    'Botswana': {'code': '+267', 'flag': '🇧🇼'},
    'Brazil': {'code': '+55', 'flag': '🇧🇷'},
    'Brunei': {'code': '+673', 'flag': '🇧🇳'},
    'Bulgaria': {'code': '+359', 'flag': '🇧🇬'},
    'Burkina Faso': {'code': '+226', 'flag': '🇧🇫'},
    'Burundi': {'code': '+257', 'flag': '🇧🇮'},
    'Cambodia': {'code': '+855', 'flag': '🇰🇭'},
    'Cameroon': {'code': '+237', 'flag': '🇨🇲'},
    'Canada': {'code': '+1', 'flag': '🇨🇦'},
    'Chile': {'code': '+56', 'flag': '🇨🇱'},
    'China': {'code': '+86', 'flag': '🇨🇳'},
    'Colombia': {'code': '+57', 'flag': '🇨🇴'},
    'Costa Rica': {'code': '+506', 'flag': '🇨🇷'},
    'Croatia': {'code': '+385', 'flag': '🇭🇷'},
    'Cuba': {'code': '+53', 'flag': '🇨🇺'},
    'Cyprus': {'code': '+357', 'flag': '🇨🇾'},
    'Czech Republic': {'code': '+420', 'flag': '🇨🇿'},
    'Denmark': {'code': '+45', 'flag': '🇩🇰'},
    'Dominican Republic': {'code': '+1-809', 'flag': '🇩🇴'},
    'Ecuador': {'code': '+593', 'flag': '🇪🇨'},
    'Egypt': {'code': '+20', 'flag': '🇪🇬'},
    'El Salvador': {'code': '+503', 'flag': '🇸🇻'},
    'Estonia': {'code': '+372', 'flag': '🇪🇪'},
    'Ethiopia': {'code': '+251', 'flag': '🇪🇹'},
    'Fiji': {'code': '+679', 'flag': '🇫🇯'},
    'Finland': {'code': '+358', 'flag': '🇫🇮'},
    'France': {'code': '+33', 'flag': '🇫🇷'},
    'Georgia': {'code': '+995', 'flag': '🇬🇪'},
    'Germany': {'code': '+49', 'flag': '🇩🇪'},
    'Ghana': {'code': '+233', 'flag': '🇬🇭'},
    'Greece': {'code': '+30', 'flag': '🇬🇷'},
    'Guatemala': {'code': '+502', 'flag': '🇬🇹'},
    'Haiti': {'code': '+509', 'flag': '🇭🇹'},
    'Honduras': {'code': '+504', 'flag': '🇭🇳'},
    'Hong Kong': {'code': '+852', 'flag': '🇭🇰'},
    'Hungary': {'code': '+36', 'flag': '🇭🇺'},
    'Iceland': {'code': '+354', 'flag': '🇮🇸'},
    'India': {'code': '+91', 'flag': '🇮🇳'},
    'Indonesia': {'code': '+62', 'flag': '🇮🇩'},
    'Iran': {'code': '+98', 'flag': '🇮🇷'},
    'Iraq': {'code': '+964', 'flag': '🇮🇶'},
    'Ireland': {'code': '+353', 'flag': '🇮🇪'},
    'Israel': {'code': '+972', 'flag': '🇮🇱'},
    'Italy': {'code': '+39', 'flag': '🇮🇹'},
    'Jamaica': {'code': '+1-876', 'flag': '🇯🇲'},
    'Japan': {'code': '+81', 'flag': '🇯🇵'},
    'Jordan': {'code': '+962', 'flag': '🇯🇴'},
    'Kazakhstan': {'code': '+7', 'flag': '🇰🇿'},
    'Kenya': {'code': '+254', 'flag': '🇰🇪'},
    'Kuwait': {'code': '+965', 'flag': '🇰🇼'},
    'Laos': {'code': '+856', 'flag': '🇱🇦'},
    'Latvia': {'code': '+371', 'flag': '🇱🇻'},
    'Lebanon': {'code': '+961', 'flag': '🇱🇧'},
    'Libya': {'code': '+218', 'flag': '🇱🇾'},
    'Lithuania': {'code': '+370', 'flag': '🇱🇹'},
    'Luxembourg': {'code': '+352', 'flag': '🇱🇺'},
    'Malaysia': {'code': '+60', 'flag': '🇲🇾'},
    'Maldives': {'code': '+960', 'flag': '🇲🇻'},
    'Malta': {'code': '+356', 'flag': '🇲🇹'},
    'Mexico': {'code': '+52', 'flag': '🇲🇽'},
    'Moldova': {'code': '+373', 'flag': '🇲🇩'},
    'Monaco': {'code': '+377', 'flag': '🇲🇨'},
    'Mongolia': {'code': '+976', 'flag': '🇲🇳'},
    'Montenegro': {'code': '+382', 'flag': '🇲🇪'},
    'Morocco': {'code': '+212', 'flag': '🇲🇦'},
    'Myanmar': {'code': '+95', 'flag': '🇲🇲'},
    'Nepal': {'code': '+977', 'flag': '🇳🇵'},
    'Netherlands': {'code': '+31', 'flag': '🇳🇱'},
    'New Zealand': {'code': '+64', 'flag': '🇳🇿'},
    'Nicaragua': {'code': '+505', 'flag': '🇳🇮'},
    'Nigeria': {'code': '+234', 'flag': '🇳🇬'},
    'North Macedonia': {'code': '+389', 'flag': '🇲🇰'},
    'Norway': {'code': '+47', 'flag': '🇳🇴'},
    'Oman': {'code': '+968', 'flag': '🇴🇲'},
    'Pakistan': {'code': '+92', 'flag': '🇵🇰'},
    'Palestine': {'code': '+970', 'flag': '🇵🇸'},
    'Panama': {'code': '+507', 'flag': '🇵🇦'},
    'Paraguay': {'code': '+595', 'flag': '🇵🇾'},
    'Peru': {'code': '+51', 'flag': '🇵🇪'},
    'Philippines': {'code': '+63', 'flag': '🇵🇭'},
    'Poland': {'code': '+48', 'flag': '🇵🇱'},
    'Portugal': {'code': '+351', 'flag': '🇵🇹'},
    'Qatar': {'code': '+974', 'flag': '🇶🇦'},
    'Romania': {'code': '+40', 'flag': '🇷🇴'},
    'Russia': {'code': '+7', 'flag': '🇷🇺'},
    'Rwanda': {'code': '+250', 'flag': '🇷🇼'},
    'Saudi Arabia': {'code': '+966', 'flag': '🇸🇦'},
    'Senegal': {'code': '+221', 'flag': '🇸🇳'},
    'Serbia': {'code': '+381', 'flag': '🇷🇸'},
    'Singapore': {'code': '+65', 'flag': '🇸🇬'},
    'Slovakia': {'code': '+421', 'flag': '🇸🇰'},
    'Slovenia': {'code': '+386', 'flag': '🇸🇮'},
    'South Africa': {'code': '+27', 'flag': '🇿🇦'},
    'South Korea': {'code': '+82', 'flag': '🇰🇷'},
    'Spain': {'code': '+34', 'flag': '🇪🇸'},
    'Sri Lanka': {'code': '+94', 'flag': '🇱🇰'},
    'Sudan': {'code': '+249', 'flag': '🇸🇩'},
    'Sweden': {'code': '+46', 'flag': '🇸🇪'},
    'Switzerland': {'code': '+41', 'flag': '🇨🇭'},
    'Syria': {'code': '+963', 'flag': '🇸🇾'},
    'Taiwan': {'code': '+886', 'flag': '🇹🇼'},
    'Tanzania': {'code': '+255', 'flag': '🇹🇿'},
    'Thailand': {'code': '+66', 'flag': '🇹🇭'},
    'Tunisia': {'code': '+216', 'flag': '🇹🇳'},
    'Turkey': {'code': '+90', 'flag': '🇹🇷'},
    'Uganda': {'code': '+256', 'flag': '🇺🇬'},
    'Ukraine': {'code': '+380', 'flag': '🇺🇦'},
    'United Arab Emirates': {'code': '+971', 'flag': '🇦🇪'},
    'United Kingdom': {'code': '+44', 'flag': '🇬🇧'},
    'United States': {'code': '+1', 'flag': '🇺🇸'},
    'Uruguay': {'code': '+598', 'flag': '🇺🇾'},
    'Uzbekistan': {'code': '+998', 'flag': '🇺🇿'},
    'Venezuela': {'code': '+58', 'flag': '🇻🇪'},
    'Vietnam': {'code': '+84', 'flag': '🇻🇳'},
    'Yemen': {'code': '+967', 'flag': '🇾🇪'},
    'Zambia': {'code': '+260', 'flag': '🇿🇲'},
    'Zimbabwe': {'code': '+263', 'flag': '🇿🇼'},
  };

  final List<String> _countries = [
    'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 'Armenia', 'Australia', 'Austria',
    'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados', 'Belarus', 'Belgium', 'Belize', 'Benin',
    'Bhutan', 'Bolivia', 'Bosnia and Herzegovina', 'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso',
    'Burundi', 'Cambodia', 'Cameroon', 'Canada', 'Cape Verde', 'Central African Republic', 'Chad', 'Chile',
    'China', 'Colombia', 'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus', 'Czech Republic',
    'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea',
    'Eritrea', 'Estonia', 'Eswatini', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia',
    'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau', 'Guyana', 'Haiti',
    'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland', 'Israel', 'Italy',
    'Jamaica', 'Japan', 'Jordan', 'Kazakhstan', 'Kenya', 'Kiribati', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia',
    'Lebanon', 'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar', 'Malawi',
    'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania', 'Mauritius', 'Mexico', 'Micronesia',
    'Moldova', 'Monaco', 'Mongolia', 'Montenegro', 'Morocco', 'Mozambique', 'Myanmar', 'Namibia', 'Nauru',
    'Nepal', 'Netherlands', 'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia',
    'Norway', 'Oman', 'Pakistan', 'Palau', 'Panama', 'Papua New Guinea', 'Paraguay', 'Peru', 'Philippines',
    'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia', 'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia',
    'Saint Vincent and the Grenadines', 'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal',
    'Serbia', 'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands', 'Somalia',
    'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan', 'Suriname', 'Sweden', 'Switzerland',
    'Syria', 'Taiwan', 'Tajikistan', 'Tanzania', 'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago',
    'Tunisia', 'Turkey', 'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
    'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela', 'Vietnam', 'Yemen',
    'Zambia', 'Zimbabwe'
  ];

  @override
  void initState() {
    super.initState();
    _detectLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _detectLocation() async {
    final country = await LocationService.detectUserCountry();
    if (mounted) {
      setState(() {
        if (_countries.contains(country)) {
          _selectedCountry = country;
          if (_countryData.containsKey(country)) {
            _selectedDialCode = _countryData[country]!['code']!;
            _selectedFlag = _countryData[country]!['flag']!;
          }
        }
      });
    }
  }

  void _showCountryCodePickerModal() {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            final filteredEntries = _countryData.entries.where((entry) {
              final countryName = entry.key.toLowerCase();
              final dialCode = entry.value['code']!.toLowerCase();
              final q = searchQuery.toLowerCase().trim();
              return countryName.contains(q) || dialCode.contains(q);
            }).toList();

            return Container(
              height: MediaQuery.of(modalContext).size.height * 0.75,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Select Country Calling Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0A2540))),
                  const SizedBox(height: 14),
                  TextField(
                    onChanged: (val) => setModalState(() => searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search country or code (e.g. +1, Saudi)...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0075FF)),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredEntries.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        final countryName = entry.key;
                        final flag = entry.value['flag']!;
                        final code = entry.value['code']!;

                        return ListTile(
                          leading: Text(flag, style: const TextStyle(fontSize: 24)),
                          title: Text(countryName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF0A2540))),
                          trailing: Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0075FF))),
                          onTap: () {
                            setState(() {
                              _selectedCountry = countryName;
                              _selectedDialCode = code;
                              _selectedFlag = flag;
                            });
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectDateOfBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0075FF),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0A2540),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      int age = now.year - picked.year;
      if (now.month < picked.month || (now.month == picked.month && now.day < picked.day)) {
        age--;
      }

      setState(() {
        _dobController.text = formattedDate;
        _ageController.text = age > 0 ? age.toString() : '18';
      });
    }
  }

  void _doRegister() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final country = _selectedCountry;
    final ageStr = _ageController.text.trim();
    final age = int.tryParse(ageStr) ?? 20;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() => _errorMessage = 'All required fields must be filled.');
      return;
    }

    if (password != confirmPassword) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    if (password.length < 8 || !RegExp(r'(?=.*[0-9])(?=.*[A-Z])').hasMatch(password)) {
      setState(() => _errorMessage = 'Password must be at least 8 characters and include a number and an uppercase letter.');
      return;
    }

    if (!_agreeToTerms) {
      setState(() => _errorMessage = 'Please agree to the Terms of Service & Privacy Policy.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Update profile provider with user's sign up input
    ref.read(profileProvider.notifier).updateProfile(
      fullName: fullName,
      email: email,
      age: age,
      country: country,
    );

    final res = await ApiService.register(
      email: email,
      password: password,
      fullName: fullName,
      age: age,
      country: country,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'OTP sent to your email!')),
        );
        context.push('/verify-otp', extra: email);
      } else {
        setState(() => _errorMessage = res['error'] ?? 'Registration failed. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: Stack(
        children: [
          // Background Light Wavy Accents & Bottom Wave
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundWavePainter(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top Row: Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF0A2540), size: 24),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/welcome');
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Brand Header (Logo + PROVO GUARD + Tagline)
                  const ProvoGuardLogo(size: 90),

                  const SizedBox(height: 24),

                  // Heading Text
                  const Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2540),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join Provo Guard and stay protected.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Field 1: Full Name
                  _buildInputField(
                    controller: _nameController,
                    hintText: 'Full Name',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 12),

                  // Field 2: Email Address
                  _buildInputField(
                    controller: _emailController,
                    hintText: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 12),

                  // Field 3: Phone Number with Country Code Dropdown (+62 ∨)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0075FF).withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_outlined, color: Color(0xFF0075FF), size: 20),
                        const SizedBox(width: 10),
                        // Country Code Selector Chip (All Global Countries)
                        InkWell(
                          onTap: _showCountryCodePickerModal,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedFlag, style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 4),
                                Text(
                                  _selectedDialCode,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0A2540)),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0075FF), size: 18),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 1,
                          height: 24,
                          color: const Color(0xFFE2E8F0),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF0A2540)),
                            decoration: const InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Field 4: Date of Birth (Calendar Picker)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0075FF).withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: _selectDateOfBirth,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0A2540)),
                      decoration: InputDecoration(
                        hintText: 'Date of Birth',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.event_outlined, color: Color(0xFF0075FF), size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today_outlined, color: Color(0xFF0075FF), size: 18),
                          onPressed: _selectDateOfBirth,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Field 5: Age (Years ∨)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0075FF).withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF0A2540)),
                      decoration: InputDecoration(
                        hintText: 'Age',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0075FF), size: 20),
                        suffixIcon: PopupMenuButton<int>(
                          onSelected: (selectedAge) {
                            setState(() => _ageController.text = selectedAge.toString());
                          },
                          itemBuilder: (context) {
                            return List.generate(80, (index) => index + 13).map((ageVal) {
                              return PopupMenuItem<int>(
                                value: ageVal,
                                child: Text('$ageVal Years', style: const TextStyle(fontSize: 13)),
                              );
                            }).toList();
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Years',
                                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.keyboard_arrow_down, color: Color(0xFF0075FF), size: 20),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Field 6: Select Country Dropdown
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0075FF).withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: _selectedCountry,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0075FF)),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.public, color: Color(0xFF0075FF), size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        items: _countries.map((c) {
                          return DropdownMenuItem<String>(
                            value: c,
                            child: Text(c, style: const TextStyle(fontSize: 14, color: Color(0xFF0A2540))),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCountry = val;
                              if (_countryData.containsKey(val)) {
                                _selectedDialCode = _countryData[val]!['code']!;
                                _selectedFlag = _countryData[val]!['flag']!;
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Field 7: Create Password
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Create Password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: const Color(0xFF0075FF),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Field 8: Confirm Password
                  _buildInputField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: const Color(0xFF0075FF),
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Password Requirement Callout Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF4FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD0E3FF)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.shield_outlined, size: 18, color: Color(0xFF0075FF)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Password must be at least 8 characters and include a number and an uppercase letter.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0A2540),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Terms of Service Agreement Checkbox
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeToTerms,
                          activeColor: const Color(0xFF0075FF),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          children: [
                            const Text('I agree to the ', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            GestureDetector(
                              onTap: () {},
                              child: const Text('Terms of Service', style: TextStyle(fontSize: 13, color: Color(0xFF0075FF), fontWeight: FontWeight.w600)),
                            ),
                            const Text(' and ', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            GestureDetector(
                              onTap: () {},
                              child: const Text('Privacy Policy', style: TextStyle(fontSize: 13, color: Color(0xFF0075FF), fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Primary Button: Sign Up
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0075FF), Color(0xFF0052CC)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0075FF).withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _isLoading ? null : _doRegister,
                      child: _isLoading
                          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Divider: —— or sign up with ——
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'or sign up with',
                          style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Social Sign Up Buttons (Google & Apple)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: _doRegister,
                            borderRadius: BorderRadius.circular(14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _GoogleLogoIcon(),
                                const SizedBox(width: 6),
                                const Text('Google', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0A2540))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: _doRegister,
                            borderRadius: BorderRadius.circular(14),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.apple, size: 22, color: Color(0xFF0A2540)),
                                SizedBox(width: 6),
                                Text('Apple', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0A2540))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Footer Link: Already have an account? Log In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF0075FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0075FF).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: Color(0xFF0A2540)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          prefixIcon: Icon(icon, color: const Color(0xFF0075FF), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// Google 'G' Multicolor Logo Widget
class _GoogleLogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(
        painter: _GoogleGPainter(),
      ),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2 - 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.stroke..strokeWidth = 3.2;
    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.stroke..strokeWidth = 3.2;
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.stroke..strokeWidth = 3.2;
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.stroke..strokeWidth = 3.2;

    // Draw 4 Google Brand Color Arcs
    canvas.drawArc(rect, -0.4, 1.8, false, bluePaint);
    canvas.drawArc(rect, 1.4, 1.2, false, greenPaint);
    canvas.drawArc(rect, 2.6, 1.2, false, yellowPaint);
    canvas.drawArc(rect, 3.8, 1.2, false, redPaint);

    canvas.drawLine(Offset(center.dx, center.dy), Offset(center.dx + radius, center.dy), bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Background Wave Overlay Painter (Top & Bottom Curve)
class _BackgroundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Top Wave Accent Path
    final topWave = Path()
      ..moveTo(0, h * 0.12)
      ..cubicTo(w * 0.3, h * 0.04, w * 0.7, h * 0.1, w, h * 0.03)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();

    final topPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF0075FF).withOpacity(0.05),
          const Color(0xFF0052CC).withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.12));

    canvas.drawPath(topWave, topPaint);

    // Bottom Deep Blue Wave Accent Path
    final bottomWave = Path()
      ..moveTo(0, h * 0.9)
      ..cubicTo(w * 0.35, h * 0.84, w * 0.65, h * 0.95, w, h * 0.88)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final bottomPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0075FF),
          Color(0xFF0052CC),
          Color(0xFF0038A8),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.84, w, h * 0.16));

    canvas.drawPath(bottomWave, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

