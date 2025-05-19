import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart' as ph;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  double? _latitude;
  double? _longitude;
  bool _isRegistered = false;
  bool _loadingLocation = false;

  final loc.Location _location = loc.Location();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool registered = prefs.getBool('isUserRegistered') ?? false;

    if (registered) {
      setState(() {
        _isRegistered = true;
        _fullNameController.text = prefs.getString('fullName') ?? '';
        _phoneController.text = prefs.getString('phoneNumber') ?? '';
        _cityController.text = prefs.getString('city') ?? '';
        _latitude = prefs.getDouble('latitude');
        _longitude = prefs.getDouble('longitude');
      });
    }
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    if (_latitude == null || _longitude == null) {
      _showLocationPermissionDialog();
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserRegistered', true);
    await prefs.setString('fullName', _fullNameController.text.trim());
    await prefs.setString('phoneNumber', _phoneController.text.trim());
    await prefs.setString('city', _cityController.text.trim());
    await prefs.setDouble('latitude', _latitude!);
    await prefs.setDouble('longitude', _longitude!);

    setState(() {
      _isRegistered = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration successful!')),
    );
  }

  Future<void> _updateLocation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Why Location Permission?'),
        content: const Text(
          'We need your location to calculate how far you are from the marketplace in kilometers.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _loadingLocation = true;
    });

    try {
      if (kIsWeb) {
        html.window.navigator.geolocation?.getCurrentPosition().then((position) async {
          setState(() {
            _latitude = position.coords?.latitude as double?;
            _longitude = position.coords?.longitude as double?;
            _loadingLocation = false;
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('latitude', _latitude!);
          await prefs.setDouble('longitude', _longitude!);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated successfully!')),
          );
        }).catchError((error) {
          setState(() => _loadingLocation = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get location: $error')),
          );
        });
      } else {
        loc.PermissionStatus permissionStatus = await _location.hasPermission();
        if (permissionStatus == loc.PermissionStatus.denied) {
          permissionStatus = await _location.requestPermission();
          if (permissionStatus != loc.PermissionStatus.granted) {
            setState(() => _loadingLocation = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission denied.')),
            );
            return;
          }
        }

        bool serviceEnabled = await _location.serviceEnabled();
        if (!serviceEnabled) {
          serviceEnabled = await _location.requestService();
          if (!serviceEnabled) {
            setState(() => _loadingLocation = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location service is disabled.')),
            );
            return;
          }
        }

        final locData = await _location.getLocation();
        setState(() {
          _latitude = locData.latitude;
          _longitude = locData.longitude;
          _loadingLocation = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('latitude', _latitude!);
        await prefs.setDouble('longitude', _longitude!);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location updated successfully!')),
        );
      }
    } catch (e) {
      setState(() => _loadingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Location Required'),
        content: const Text(
          'We need your location to complete registration and provide better service.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green.shade700),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade900, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildRegisteredView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Full Name: ${_fullNameController.text}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Text('Phone Number: ${_phoneController.text}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Text('City: ${_cityController.text}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Text('Latitude: ${_latitude?.toStringAsFixed(5) ?? 'Not set'}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Text('Longitude: ${_longitude?.toStringAsFixed(5) ?? 'Not set'}', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 24),
        _loadingLocation
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton.icon(
                onPressed: _updateLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Update My Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            label: 'Full Name',
            controller: _fullNameController,
            keyboardType: TextInputType.name,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your full name' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Please enter your phone number';
              if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value.trim())) return 'Enter a valid phone number';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Living City',
            controller: _cityController,
            keyboardType: TextInputType.text,
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your city' : null,
          ),
          const SizedBox(height: 24),
          _loadingLocation
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  onPressed: _updateLocation,
                  icon: const Icon(Icons.location_pin),
                  label: const Text('Get My Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveUserData,
            child: const Text('Register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Personal Info', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _isRegistered ? _buildRegisteredView() : _buildRegistrationForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


