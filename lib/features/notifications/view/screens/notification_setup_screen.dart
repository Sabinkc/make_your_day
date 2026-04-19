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
    _initializeTimezoneAndLoadSettings();
  }

  Future<void> _initializeTimezoneAndLoadSettings() async {
    setState(() => _isLoading = true);

    await TimezoneService.initialize();

    _userTimezone = await TimezoneService.getDeviceTimezone();
    _utcOffset = TimezoneService.getUTCOffset(_userTimezone);

    await CloudFunctionService.saveUserTimezone(_userTimezone);

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
        'times': entry.value.times,
      };
    }

    _userName = _nameController.text.trim();

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
            content: Text(
              'Settings saved! You will receive notifications at your local time.',
            ),
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

  String _formatDisplayTime(String utcTime) {
    print('🔄 Formatting display for UTC: $utcTime');
    print('📍 User timezone: $_userTimezone');

    final localTimeString = TimezoneService.convertUTCToLocal(
      utcTime: utcTime,
      timezone: _userTimezone,
    );

    print('🕐 Converted to local (24h): $localTimeString');

    final parts = localTimeString.split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12;
    displayHour = displayHour == 0 ? 12 : displayHour;

    final result = '$displayHour:$minute $period';
    print('📱 Display result: $result');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallPhone = screenWidth < 360;
    
    // Responsive values
    final double horizontalMargin = isSmallPhone ? 12.0 : (isTablet ? 24.0 : 20.0);
    final double verticalMargin = isSmallPhone ? 8.0 : (isTablet ? 16.0 : 12.0);
    final double headerPadding = isSmallPhone ? 16.0 : 24.0;
    final double titleFontSize = isSmallPhone ? 20.0 : 24.0;
    final double subtitleFontSize = isSmallPhone ? 12.0 : 14.0;
    final double sectionTitleSize = isSmallPhone ? 16.0 : 18.0;
    final double cardPadding = isSmallPhone ? 12.0 : 16.0;
    final double buttonPadding = isSmallPhone ? 12.0 : 20.0;
    final double chipFontSize = isSmallPhone ? 11.0 : 13.0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: isSmallPhone ? 16.0 : 20.0,
          ),
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
                  _buildHeader(headerPadding, titleFontSize, subtitleFontSize, isSmallPhone),
                  SizedBox(height: isSmallPhone ? 16.0 : 24.0),
                  _buildTimezoneCard(horizontalMargin, verticalMargin, isSmallPhone),
                  SizedBox(height: isSmallPhone ? 12.0 : 16.0),
                  _buildMasterSwitch(horizontalMargin, verticalMargin, isSmallPhone),
                  SizedBox(height: isSmallPhone ? 16.0 : 24.0),
                  if (_notificationsEnabled) ...[
                    _buildNameField(horizontalMargin, verticalMargin, isSmallPhone),
                    SizedBox(height: isSmallPhone ? 16.0 : 24.0),
                    _buildServiceHeader(sectionTitleSize, isSmallPhone),
                    SizedBox(height: isSmallPhone ? 8.0 : 12.0),
                    for (var entry in _services.entries)
                      _buildServiceCard(
                        serviceId: entry.key,
                        service: entry.value,
                        isSmallPhone: isSmallPhone,
                        isTablet: isTablet,
                        chipFontSize: chipFontSize,
                      ),
                  ],
                  SizedBox(height: isSmallPhone ? 60.0 : 100.0),
                ],
              ),
            ),
      bottomNavigationBar: _notificationsEnabled 
          ? _buildBottomButton(buttonPadding, isSmallPhone) 
          : null,
    );
  }

  Widget _buildHeader(double padding, double titleSize, double subtitleSize, bool isSmallPhone) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.notifications_active, size: isSmallPhone ? 50.0 : 60.0, color: Colors.white),
          SizedBox(height: isSmallPhone ? 12.0 : 16.0),
          Text(
            'Stay Positive Daily',
            style: GoogleFonts.poppins(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallPhone ? 6.0 : 8.0),
          Text(
            'Get uplifting content delivered at your local time',
            style: GoogleFonts.poppins(
              fontSize: subtitleSize,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneCard(double horizontalMargin, double verticalMargin, bool isSmallPhone) {
    final double padding = isSmallPhone ? 12.0 : 16.0;
    final double fontSize = isSmallPhone ? 12.0 : 14.0;
    final double iconSize = isSmallPhone ? 16.0 : 20.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(isSmallPhone ? 12.0 : 15.0),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isSmallPhone ? 6.0 : 8.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(isSmallPhone ? 8.0 : 10.0),
            ),
            child: Icon(Icons.public, color: Colors.white, size: iconSize),
          ),
          SizedBox(width: isSmallPhone ? 8.0 : 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Timezone',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize * 0.85,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  '$_userTimezone ($_utcOffset)',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: isSmallPhone ? 16.0 : 20.0),
        ],
      ),
    );
  }

  Widget _buildMasterSwitch(double horizontalMargin, double verticalMargin, bool isSmallPhone) {
    final double padding = isSmallPhone ? 12.0 : 16.0;
    final double fontSize = isSmallPhone ? 14.0 : 16.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: _notificationsEnabled
            ? Colors.blue.shade50
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(isSmallPhone ? 12.0 : 15.0),
        border: Border.all(
          color: _notificationsEnabled ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications,
            color: _notificationsEnabled ? Colors.blue : Colors.grey,
            size: isSmallPhone ? 24.0 : 30.0,
          ),
          SizedBox(width: isSmallPhone ? 12.0 : 16.0),
          Expanded(
            child: Text(
              'Enable Notifications',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
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

  Widget _buildNameField(double horizontalMargin, double verticalMargin, bool isSmallPhone) {
    final double padding = isSmallPhone ? 12.0 : 16.0;
    final double fontSize = isSmallPhone ? 14.0 : 16.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 12.0 : 15.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10.0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Name',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
          SizedBox(height: isSmallPhone ? 8.0 : 12.0),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person_outline, size: isSmallPhone ? 18.0 : 24.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallPhone ? 10.0 : 12.0),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallPhone ? 12.0 : 16.0,
                vertical: isSmallPhone ? 10.0 : 12.0,
              ),
            ),
            style: TextStyle(fontSize: isSmallPhone ? 14.0 : 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceHeader(double fontSize, bool isSmallPhone) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallPhone ? 12.0 : 20.0),
      child: Text(
        'Select Services & Times (Your Local Time)',
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String serviceId,
    required ServiceData service,
    required bool isSmallPhone,
    required bool isTablet,
    required double chipFontSize,
  }) {
    final double margin = isSmallPhone ? 12.0 : 20.0;
    final double padding = isSmallPhone ? 12.0 : 16.0;
    final double iconSize = isSmallPhone ? 20.0 : 24.0;
    final double titleSize = isSmallPhone ? 14.0 : 16.0;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin, vertical: isSmallPhone ? 4.0 : 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallPhone ? 12.0 : 15.0),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: isSmallPhone ? 6.0 : 8.0),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(service.icon, color: service.color, size: iconSize),
          title: Text(
            service.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: titleSize,
            ),
          ),
          trailing: Switch(
            value: service.enabled,
            onChanged: (val) => setState(() => service.enabled = val),
            activeColor: service.color,
          ),
          children: [
            if (service.enabled)
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (service.times.isNotEmpty)
                      Wrap(
                        spacing: isSmallPhone ? 6.0 : 8.0,
                        runSpacing: isSmallPhone ? 6.0 : 8.0,
                        children: service.times.map((utcTime) {
                          return Chip(
                            label: Text(
                              _formatDisplayTime(utcTime),
                              style: GoogleFonts.poppins(fontSize: chipFontSize),
                            ),
                            onDeleted: () => _removeTime(serviceId, utcTime),
                            deleteIcon: Icon(Icons.close, size: isSmallPhone ? 14.0 : 16.0),
                            backgroundColor: service.color.withOpacity(0.1),
                          );
                        }).toList(),
                      ),
                    SizedBox(height: isSmallPhone ? 6.0 : 8.0),
                    TextButton.icon(
                      onPressed: () => _addTime(serviceId),
                      icon: Icon(Icons.add, size: isSmallPhone ? 16.0 : 18.0),
                      label: Text(
                        'Add Time (Your Local Time)',
                        style: GoogleFonts.poppins(fontSize: isSmallPhone ? 12.0 : 14.0),
                      ),
                      style: TextButton.styleFrom(foregroundColor: service.color),
                    ),
                    if (service.times.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: isSmallPhone ? 6.0 : 8.0),
                        child: Text(
                          'Add at least one time to receive notifications',
                          style: GoogleFonts.poppins(
                            fontSize: isSmallPhone ? 10.0 : 12.0,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(double padding, bool isSmallPhone) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(double.infinity, isSmallPhone ? 44.0 : 50.0),
          padding: EdgeInsets.symmetric(vertical: isSmallPhone ? 12.0 : 14.0),
        ),
        child: Text(
          'Save Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallPhone ? 14.0 : 16.0,
          ),
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
  List<String> times;

  ServiceData({
    required this.name,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.times,
  });
}