// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// // Import your cloud functions package if needed
// // import 'package:cloud_functions/cloud_functions.dart';

// class NotificationSetupScreen extends StatefulWidget {
//   const NotificationSetupScreen({super.key});

//   @override
//   State<NotificationSetupScreen> createState() =>
//       _NotificationSetupScreenState();
// }

// class _NotificationSetupScreenState extends State<NotificationSetupScreen> {
//   bool _notificationsEnabled = false;
//   String _userName = '';
//   final TextEditingController _nameController = TextEditingController();
//   bool _isLoading = false;

//   final Map<String, ServiceData> _services = {
//     'affirmations': ServiceData(
//       name: 'Daily Affirmations',
//       icon: Icons.auto_awesome,
//       color: Colors.purple,
//       enabled: false,
//       times: [],
//     ),
//     'motivations': ServiceData(
//       name: 'Motivations',
//       icon: Icons.trending_up,
//       color: Colors.orange,
//       enabled: false,
//       times: [],
//     ),
//     'quotes': ServiceData(
//       name: 'Quotes',
//       icon: Icons.format_quote,
//       color: Colors.teal,
//       enabled: false,
//       times: [],
//     ),
//     'jokes': ServiceData(
//       name: 'Jokes',
//       icon: Icons.emoji_emotions,
//       color: Colors.amber,
//       enabled: false,
//       times: [],
//     ),
//     'compliments': ServiceData(
//       name: 'Compliments',
//       icon: Icons.favorite,
//       color: Colors.pink,
//       enabled: false,
//       times: [],
//     ),
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedSettings();
//   }

//   @override
//   void dispose() {
//     _nameController
//         .dispose(); // Always dispose controllers to prevent memory leaks
//     super.dispose();
//   }

//   Future<void> _loadSavedSettings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedSettings = prefs.getString('notification_settings');

//     if (savedSettings != null) {
//       final data = json.decode(savedSettings);
//       setState(() {
//         _notificationsEnabled = data['enabled'] ?? false;
//         _userName = data['userName'] ?? '';
//         _nameController.text = _userName;

//         final savedServices = data['services'] ?? {};
//         for (var service in _services.keys) {
//           if (savedServices.containsKey(service)) {
//             _services[service]!.enabled =
//                 savedServices[service]['enabled'] ?? false;
//             _services[service]!.times = List<String>.from(
//               savedServices[service]['times'] ?? [],
//             );
//           }
//         }
//       });
//     }
//   }

//   Future<void> _saveSettings() async {
//     setState(() => _isLoading = true);

//     final servicesData = {};
//     for (var entry in _services.entries) {
//       servicesData[entry.key] = {
//         'enabled': entry.value.enabled,
//         'times': entry.value.times,
//       };
//     }

//     // Updated to use the text from controller directly
//     _userName = _nameController.text;

//   // ✅ Cast to Map<String, dynamic>
// final success = await CloudFunctionService.saveNotificationSettings(
//   notificationsEnabled: _notificationsEnabled,
//   userName: _userName,
//   services: Map<String, dynamic>.from(servicesData),
// );

//     if (success) {
//       final settingsData = {
//         'enabled': _notificationsEnabled,
//         'userName': _userName,
//         'services': servicesData,
//       };
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('notification_settings', json.encode(settingsData));

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Notification settings saved successfully!'),
//           ),
//         );
//         Navigator.pop(context);
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Failed to save settings. Please try again.'),
//           ),
//         );
//       }
//     }

//     if (mounted) setState(() => _isLoading = false);
//   }

//   void _addTime(String serviceId) {
//     showTimePicker(
//       context: context,
//       initialTime: const TimeOfDay(hour: 9, minute: 0),
//     ).then((selectedTime) {
//       if (selectedTime != null) {
//         setState(() {
//           final timeString = _formatTimeOfDay(selectedTime);
//           if (!_services[serviceId]!.times.contains(timeString)) {
//             _services[serviceId]!.times.add(timeString);
//             _services[serviceId]!.times.sort();
//           }
//         });
//       }
//     });
//   }

//   void _removeTime(String serviceId, String time) {
//     setState(() {
//       _services[serviceId]!.times.remove(time);
//     });
//   }

//   String _formatTimeOfDay(TimeOfDay time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }

//   String _formatDisplayTime(String time) {
//     final parts = time.split(':');
//     final hour = int.parse(parts[0]);
//     final minute = parts[1];
//     final period = hour >= 12 ? 'PM' : 'AM';
//     final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
//     return '$displayHour:$minute $period';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           'Notification Settings',
//           style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeader(),
//                   const SizedBox(height: 24),
//                   _buildMasterSwitch(),
//                   const SizedBox(height: 24),
//                   if (_notificationsEnabled) ...[
//                     _buildNameField(),
//                     const SizedBox(height: 24),
//                     _buildServiceHeader(),
//                     const SizedBox(height: 12),
//                     for (var entry in _services.entries)
//                       _buildServiceCard(
//                         serviceId: entry.key,
//                         service: entry.value,
//                       ),
//                   ],
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//       bottomNavigationBar: _notificationsEnabled ? _buildBottomButton() : null,
//     );
//   }

//   // --- Sub-Widgets for cleaner code ---

//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(24),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.notifications_active, size: 60, color: Colors.white),
//           const SizedBox(height: 16),
//           Text(
//             'Stay Positive Daily',
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Get uplifting content delivered right to your phone',
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               color: Colors.white.withOpacity(0.9),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMasterSwitch() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: _notificationsEnabled
//             ? Colors.blue.shade50
//             : Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(
//           color: _notificationsEnabled ? Colors.blue : Colors.grey.shade300,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.notifications,
//             color: _notificationsEnabled ? Colors.blue : Colors.grey,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Text(
//               'Enable Notifications',
//               style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Switch(
//             value: _notificationsEnabled,
//             onChanged: (val) => setState(() => _notificationsEnabled = val),
//             activeColor: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNameField() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Your Name',
//             style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               hintText: 'Enter your name',
//               prefixIcon: const Icon(Icons.person_outline),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildServiceHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Text(
//         'Select Services & Times',
//         style: GoogleFonts.poppins(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.blue.shade800,
//         ),
//       ),
//     );
//   }

//   Widget _buildServiceCard({
//     required String serviceId,
//     required ServiceData service,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
//         ],
//       ),
//       child: ExpansionTile(
//         leading: Icon(service.icon, color: service.color),
//         title: Text(
//           service.name,
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         trailing: Switch(
//           value: service.enabled,
//           onChanged: (val) => setState(() => service.enabled = val),
//           activeColor: service.color,
//         ),
//         children: [
//           if (service.enabled)
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Wrap(
//                     spacing: 8,
//                     children: service.times
//                         .map(
//                           (t) => Chip(
//                             label: Text(_formatDisplayTime(t)),
//                             onDeleted: () => _removeTime(serviceId, t),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                   TextButton.icon(
//                     onPressed: () => _addTime(serviceId),
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add Time'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomButton() {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: ElevatedButton(
//         onPressed: _isLoading ? null : _saveSettings,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: const Text(
//           'Save Settings',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }


// class CloudFunctionService {
//   static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
// static Future<bool> saveNotificationSettings({
//     required bool notificationsEnabled,
//     required String userName,
//     required Map<String, dynamic> services,  // ← Explicit type
//   }) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         print('❌ User not authenticated');
//         return false;
//       }
      
//       print('📤 Saving settings for user: ${user.uid}');
//       print('📤 Services data: $services');
      
//       final result = await FirebaseFunctions.instance
//           .httpsCallable('saveNotificationSettings')
//           .call({
//         'userId': user.uid,
//         'userName': userName,
//         'notificationsEnabled': notificationsEnabled,
//         'services': services,
//       });
      
//       print('✅ Settings saved: ${result.data}');
//       return true;
      
//     } catch (e) {
//       print('❌ Error saving settings: $e');
//       return false;
//     }
//   }
  
//   static Future<bool> registerFCMToken(String fcmToken) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return false;
      
//       await _functions.httpsCallable('registerFCMToken').call({
//         'userId': user.uid,
//         'fcmToken': fcmToken,
//       });
      
//       return true;
//     } catch (e) {
//       print('❌ Error registering token: $e');
//       return false;
//     }
//   }
  
//   static Future<bool> sendTestNotification({String? serviceId}) async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return false;
      
//       await _functions.httpsCallable('sendTestNotification').call({
//         'userId': user.uid,
//         'serviceId': serviceId ?? 'affirmations',
//       });
      
//       return true;
//     } catch (e) {
//       print('❌ Error sending test notification: $e');
//       return false;
//     }
//   }
// }

// class ServiceData {
//   final String name;
//   final IconData icon;
//   final Color color;
//   bool enabled;
//   List<String> times;

//   ServiceData({
//     required this.name,
//     required this.icon,
//     required this.color,
//     required this.enabled,
//     required this.times,
//   });
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/notifications/service/cloud_function_service.dart';
import 'package:make_your_day/features/notifications/service/timezone_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class NotificationSetupScreen extends StatefulWidget {
  const NotificationSetupScreen({super.key});

  @override
  State<NotificationSetupScreen> createState() =>
      _NotificationSetupScreenState();
}

class _NotificationSetupScreenState extends State<NotificationSetupScreen> {
  bool _notificationsEnabled = false;
  String _userName = '';
  String _userTimezone = '';
  String _utcOffset = '';
  bool _isLoading = true;
  final TextEditingController _nameController = TextEditingController();

  final Map<String, ServiceData> _services = {
    'affirmations': ServiceData(
      name: 'Daily Affirmations',
      icon: Icons.auto_awesome,
      color: Colors.purple,
      enabled: false,
      times: [], // Will store UTC times
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
    _initializeTimezoneAndLoadSettings();
  }

  Future<void> _initializeTimezoneAndLoadSettings() async {
    setState(() => _isLoading = true);
    
    // Initialize timezone service
    await TimezoneService.initialize();
    
    // Get device timezone
    _userTimezone = await TimezoneService.getDeviceTimezone();
    _utcOffset = TimezoneService.getUTCOffset(_userTimezone);
    
    // Save timezone to Firestore
    await CloudFunctionService.saveUserTimezone(_userTimezone);
    
    // Load saved settings
    await _loadSavedSettings();
    
    setState(() => _isLoading = false);
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

    final Map<String, dynamic> servicesData = {};
    for (var entry in _services.entries) {
      servicesData[entry.key] = {
        'enabled': entry.value.enabled,
        'times': entry.value.times, // Already in UTC
      };
    }

    _userName = _nameController.text.trim();

    // Save to Cloud Function with timezone
    final success = await CloudFunctionService.saveNotificationSettings(
      notificationsEnabled: _notificationsEnabled,
      userName: _userName,
      timezone: _userTimezone,
      services: servicesData,
    );

    if (success) {
      final settingsData = {
        'enabled': _notificationsEnabled,
        'userName': _userName,
        'timezone': _userTimezone,
        'services': servicesData,
      };
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_settings', json.encode(settingsData));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Settings saved! You will receive notifications at your local time.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save settings. Please try again.'),
            backgroundColor: Colors.red,
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
          // Convert local time to UTC before saving
          final utcTimeString = TimezoneService.convertLocalToUTC(
            hour: selectedTime.hour,
            minute: selectedTime.minute,
            timezone: _userTimezone,
          );
          
          if (!_services[serviceId]!.times.contains(utcTimeString)) {
            _services[serviceId]!.times.add(utcTimeString);
            _services[serviceId]!.times.sort();
          }
        });
      }
    });
  }

  void _removeTime(String serviceId, String utcTime) {
    setState(() {
      _services[serviceId]!.times.remove(utcTime);
    });
  }

  // Convert UTC time back to local for display
// Convert UTC time (24-hour format) to local time for display
String _formatDisplayTime(String utcTime) {
  // Convert UTC to local time (returns 24-hour format like "13:15")
  final localTimeString = TimezoneService.convertUTCToLocal(
    utcTime: utcTime,
    timezone: _userTimezone,
  );
  
  // Parse the 24-hour format
  final parts = localTimeString.split(':');
  int hour = int.parse(parts[0]);
  final minute = parts[1];
  
  // Convert to 12-hour format
  final period = hour >= 12 ? 'PM' : 'AM';
  int displayHour = hour % 12;
  displayHour = displayHour == 0 ? 12 : displayHour;
  
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
                  _buildTimezoneCard(),
                  const SizedBox(height: 16),
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

  Widget _buildTimezoneCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.public, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Timezone',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  '$_userTimezone ($_utcOffset)',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 20),
        ],
      ),
    );
  }

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
            'Get uplifting content delivered at your local time',
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
        'Select Services & Times (Your Local Time)',
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
                  if (service.times.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: service.times.map((utcTime) {
                        return Chip(
                          label: Text(_formatDisplayTime(utcTime)),
                          onDeleted: () => _removeTime(serviceId, utcTime),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          backgroundColor: service.color.withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _addTime(serviceId),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Time (Your Local Time)'),
                    style: TextButton.styleFrom(
                      foregroundColor: service.color,
                    ),
                  ),
                  if (service.times.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Add at least one time to receive notifications',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
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

// Helper class for service data
class ServiceData {
  final String name;
  final IconData icon;
  final Color color;
  bool enabled;
  List<String> times; // Stores UTC times

  ServiceData({
    required this.name,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.times,
  });
}