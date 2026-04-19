import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class TimezoneService {
  static bool _initialized = false;
  static String? _cachedTimezone;

  // Initialize timezone data
  static Future<void> initialize() async {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }

  // Get the device's timezone ID (e.g., "Asia/Kathmandu", "America/New_York")
  static Future<String> getDeviceTimezone() async {
    await initialize();
    
    try {
      // Method 1: Use flutter_timezone package (returns TimezoneInfo)
      final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
      
      // The TimezoneInfo class has a 'name' property in newer versions
      // But since we're having issues, let's use a different approach
      
      // Method 2: Use tz.local (most reliable)
      final tz.Location location = tz.local;
      String timezoneName = location.name;
      
      // If tz.local returns 'UTC' or empty (common on emulators), 
      // try to get from flutter_timezone differently
      if (timezoneName == 'UTC' || timezoneName.isEmpty) {
        // Try to get from the system timezone offset
        timezoneName = _getTimezoneFromOffset();
      }
      
      _cachedTimezone = timezoneName;
      print('📍 Device Timezone: $timezoneName');
      return timezoneName;
    } catch (e) {
      print('❌ Error getting timezone: $e');
      // Fallback to offset-based detection
      return _getTimezoneFromOffset();
    }
  }

  // Get timezone from UTC offset (works everywhere)
  static String _getTimezoneFromOffset() {
    final DateTime now = DateTime.now();
    final int offsetHours = now.timeZoneOffset.inHours;
    final int offsetMinutes = now.timeZoneOffset.inMinutes.abs() % 60;
    
    // Map common offsets to IANA timezones
    // This covers most major timezones worldwide
    final Map<String, String> offsetMap = {
      '-12:00': 'Etc/GMT+12',
      '-11:00': 'Pacific/Midway',
      '-10:00': 'Pacific/Honolulu',
      '-09:00': 'America/Anchorage',
      '-08:00': 'America/Los_Angeles',
      '-07:00': 'America/Denver',
      '-06:00': 'America/Chicago',
      '-05:00': 'America/New_York',
      '-04:00': 'America/Halifax',
      '-03:00': 'America/Sao_Paulo',
      '-02:00': 'Atlantic/South_Georgia',
      '-01:00': 'Atlantic/Azores',
      '+00:00': 'Europe/London',
      '+01:00': 'Europe/Paris',
      '+02:00': 'Europe/Helsinki',
      '+03:00': 'Europe/Moscow',
      '+03:30': 'Asia/Tehran',
      '+04:00': 'Asia/Dubai',
      '+04:30': 'Asia/Kabul',
      '+05:00': 'Asia/Karachi',
      '+05:30': 'Asia/Kolkata',
      '+05:45': 'Asia/Kathmandu',  // Nepal
      '+06:00': 'Asia/Dhaka',
      '+06:30': 'Asia/Yangon',
      '+07:00': 'Asia/Bangkok',
      '+08:00': 'Asia/Singapore',
      '+08:45': 'Australia/Eucla',
      '+09:00': 'Asia/Tokyo',
      '+09:30': 'Australia/Darwin',
      '+10:00': 'Australia/Sydney',
      '+10:30': 'Australia/Lord_Howe',
      '+11:00': 'Pacific/Noumea',
      '+12:00': 'Pacific/Auckland',
      '+12:45': 'Pacific/Chatham',
      '+13:00': 'Pacific/Tongatapu',
      '+14:00': 'Pacific/Kiritimati',
    };
    
    final String offsetKey = '${offsetHours >= 0 ? '+' : ''}$offsetHours:${offsetMinutes.toString().padLeft(2, '0')}';
    
    if (offsetMap.containsKey(offsetKey)) {
      print('📍 Detected timezone from offset: ${offsetMap[offsetKey]} (offset: $offsetKey)');
      return offsetMap[offsetKey]!;
    }
    
    // Default fallback
    print('⚠️ Unknown offset: $offsetKey, using default timezone');
    return 'Asia/Kathmandu';
  }

  // Get user's current UTC offset as string (e.g., "+05:45")
  static String getCurrentUTCOffset() {
    final DateTime now = DateTime.now();
    final int offsetHours = now.timeZoneOffset.inHours;
    final int offsetMinutes = now.timeZoneOffset.inMinutes.abs() % 60;
    final String sign = offsetHours >= 0 ? '+' : '-';
    return '$sign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMinutes.toString().padLeft(2, '0')}';
  }

  // Convert local time to UTC (24-hour format)
  static String convertLocalToUTC({
    required int hour,
    required int minute,
    required String timezone,
  }) {
    final tz.Location location = tz.getLocation(timezone);
    final tz.TZDateTime now = tz.TZDateTime.now(location);
    
    final tz.TZDateTime localDateTime = tz.TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    final DateTime utcDateTime = localDateTime.toUtc();
    final String utcTimeString = '${utcDateTime.hour.toString().padLeft(2, '0')}:${utcDateTime.minute.toString().padLeft(2, '0')}';
    
    print('🕐 Local: ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $timezone → UTC: $utcTimeString');
    
    return utcTimeString;
  }

  // // Convert UTC time back to local time (returns 24-hour format)
  // static String convertUTCToLocal({
  //   required String utcTime,
  //   required String timezone,
  // }) {
  //   try {
  //     final parts = utcTime.split(':');
  //     final utcHour = int.parse(parts[0]);
  //     final utcMinute = int.parse(parts[1]);
      
  //     final tz.Location location = tz.getLocation(timezone);
  //     final tz.TZDateTime now = tz.TZDateTime.now(location);
      
  //     final DateTime utcDateTime = DateTime(now.year, now.month, now.day, utcHour, utcMinute);
  //     final tz.TZDateTime localDateTime = tz.TZDateTime.from(utcDateTime, location);
      
  //     final String localTimeString = '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
      
  //     print('🕐 UTC: $utcTime → Local: $localTimeString ($timezone)');
      
  //     return localTimeString;
  //   } catch (e) {
  //     print('❌ Error converting UTC to local: $e');
  //     return utcTime;
  //   }
  // }

  // Convert UTC time back to local time (returns 24-hour format like "13:15")
static String convertUTCToLocal({
  required String utcTime,
  required String timezone,
}) {
  try {
    final parts = utcTime.split(':');
    final utcHour = int.parse(parts[0]);
    final utcMinute = int.parse(parts[1]);
    
    final tz.Location location = tz.getLocation(timezone);
    final tz.TZDateTime now = tz.TZDateTime.now(location);
    
    // Create UTC DateTime
    final DateTime utcDateTime = DateTime(now.year, now.month, now.day, utcHour, utcMinute);
    
    // Convert to local time
    final tz.TZDateTime localDateTime = tz.TZDateTime.from(utcDateTime, location);
    
    // Return in 24-hour format
    return '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    print('❌ Error converting UTC to local: $e');
    return utcTime; // Return original if conversion fails
  }
}

  // Get UTC offset for display (e.g., "UTC+5:45")
  static String getUTCOffset(String timezone) {
    try {
      final tz.Location location = tz.getLocation(timezone);
      final tz.TZDateTime now = tz.TZDateTime.now(location);
      final Duration offset = now.timeZoneOffset;
      
      final int offsetHours = offset.inHours;
      final int offsetMinutes = offset.inMinutes.abs() % 60;
      
      final String sign = offset.isNegative ? '-' : '+';
      final String hours = offsetHours.abs().toString();
      final String minutes = offsetMinutes > 0 ? ':$offsetMinutes' : '';
      
      return 'UTC$sign$hours$minutes';
    } catch (e) {
      print('❌ Error getting UTC offset: $e');
      return 'UTC+0';
    }
  }
  
  // Get user's local time as DateTime (for debugging)
  static DateTime getCurrentLocalTime(String timezone) {
    final tz.Location location = tz.getLocation(timezone);
    return tz.TZDateTime.now(location);
  }
}