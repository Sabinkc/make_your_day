import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// Import your cloud functions package if needed
// import 'package:cloud_functions/cloud_functions.dart';

class NotificationSetupScreen extends StatefulWidget {
  const NotificationSetupScreen({super.key});

  @override
  State<NotificationSetupScreen> createState() =>
      _NotificationSetupScreenState();
}

class _NotificationSetupScreenState extends State<NotificationSetupScreen> {
  bool _notificationsEnabled = false;
  String _userName = '';
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  final Map<String, ServiceData> _services = {
    'affirmations': ServiceData(
      name: 'Daily Affirmations',
      icon: Icons.auto_awesome,
      color: Colors.purple,
      enabled: false,
      times: [],
    ),
    'motivations': ServiceData(
      name: 'Motivations',
      icon: Icons.trending_up,
      color: Colors.orange,
      enabled: false,
      times: [],
    ),
    'quotes': ServiceData(
      name: 'Quotes',
      icon: Icons.format_quote,
      color: Colors.teal,
      enabled: false,
      times: [],
    ),
    'jokes': ServiceData(
      name: 'Jokes',
      icon: Icons.emoji_emotions,
      color: Colors.amber,
      enabled: false,
      times: [],
    ),
    'compliments': ServiceData(
      name: 'Compliments',
      icon: Icons.favorite,
      color: Colors.pink,
      enabled: false,
      times: [],
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  @override
  void dispose() {
    _nameController
        .dispose(); // Always dispose controllers to prevent memory leaks
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSettings = prefs.getString('notification_settings');

    if (savedSettings != null) {
      final data = json.decode(savedSettings);
      setState(() {
        _notificationsEnabled = data['enabled'] ?? false;
        _userName = data['userName'] ?? '';
        _nameController.text = _userName;

        final savedServices = data['services'] ?? {};
        for (var service in _services.keys) {
          if (savedServices.containsKey(service)) {
            _services[service]!.enabled =
                savedServices[service]['enabled'] ?? false;
            _services[service]!.times = List<String>.from(
              savedServices[service]['times'] ?? [],
            );
          }
        }
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);

    final servicesData = {};
    for (var entry in _services.entries) {
      servicesData[entry.key] = {
        'enabled': entry.value.enabled,
        'times': entry.value.times,
      };
    }

    // Updated to use the text from controller directly
    _userName = _nameController.text;

  // ✅ Cast to Map<String, dynamic>
final success = await CloudFunctionService.saveNotificationSettings(
  notificationsEnabled: _notificationsEnabled,
  userName: _userName,
  services: Map<String, dynamic>.from(servicesData),
);

    if (success) {
      final settingsData = {
        'enabled': _notificationsEnabled,
        'userName': _userName,
        'services': servicesData,
      };
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_settings', json.encode(settingsData));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification settings saved successfully!'),
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save settings. Please try again.'),
          ),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _addTime(String serviceId) {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          final timeString = _formatTimeOfDay(selectedTime);
          if (!_services[serviceId]!.times.contains(timeString)) {
            _services[serviceId]!.times.add(timeString);
            _services[serviceId]!.times.sort();
          }
        });
      }
    });
  }

  void _removeTime(String serviceId, String time) {
    setState(() {
      _services[serviceId]!.times.remove(time);
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDisplayTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildMasterSwitch(),
                  const SizedBox(height: 24),
                  if (_notificationsEnabled) ...[
                    _buildNameField(),
                    const SizedBox(height: 24),
                    _buildServiceHeader(),
                    const SizedBox(height: 12),
                    for (var entry in _services.entries)
                      _buildServiceCard(
                        serviceId: entry.key,
                        service: entry.value,
                      ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: _notificationsEnabled ? _buildBottomButton() : null,
    );
  }

  // --- Sub-Widgets for cleaner code ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.notifications_active, size: 60, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            'Stay Positive Daily',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get uplifting content delivered right to your phone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMasterSwitch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _notificationsEnabled
            ? Colors.blue.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _notificationsEnabled ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: _notificationsEnabled ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Enable Notifications',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Name',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Select Services & Times',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String serviceId,
    required ServiceData service,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: ExpansionTile(
        leading: Icon(service.icon, color: service.color),
        title: Text(
          service.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        trailing: Switch(
          value: service.enabled,
          onChanged: (val) => setState(() => service.enabled = val),
          activeColor: service.color,
        ),
        children: [
          if (service.enabled)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    children: service.times
                        .map(
                          (t) => Chip(
                            label: Text(_formatDisplayTime(t)),
                            onDeleted: () => _removeTime(serviceId, t),
                          ),
                        )
                        .toList(),
                  ),
                  TextButton.icon(
                    onPressed: () => _addTime(serviceId),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Time'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text(
          'Save Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}


class CloudFunctionService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
static Future<bool> saveNotificationSettings({
    required bool notificationsEnabled,
    required String userName,
    required Map<String, dynamic> services,  // ← Explicit type
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        return false;
      }
      
      print('📤 Saving settings for user: ${user.uid}');
      print('📤 Services data: $services');
      
      final result = await FirebaseFunctions.instance
          .httpsCallable('saveNotificationSettings')
          .call({
        'userId': user.uid,
        'userName': userName,
        'notificationsEnabled': notificationsEnabled,
        'services': services,
      });
      
      print('✅ Settings saved: ${result.data}');
      return true;
      
    } catch (e) {
      print('❌ Error saving settings: $e');
      return false;
    }
  }
  
  static Future<bool> registerFCMToken(String fcmToken) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      await _functions.httpsCallable('registerFCMToken').call({
        'userId': user.uid,
        'fcmToken': fcmToken,
      });
      
      return true;
    } catch (e) {
      print('❌ Error registering token: $e');
      return false;
    }
  }
  
  static Future<bool> sendTestNotification({String? serviceId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;
      
      await _functions.httpsCallable('sendTestNotification').call({
        'userId': user.uid,
        'serviceId': serviceId ?? 'affirmations',
      });
      
      return true;
    } catch (e) {
      print('❌ Error sending test notification: $e');
      return false;
    }
  }
}

class ServiceData {
  final String name;
  final IconData icon;
  final Color color;
  bool enabled;
  List<String> times;

  ServiceData({
    required this.name,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.times,
  });
}
