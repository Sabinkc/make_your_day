import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CloudFunctionService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Save notification settings to Firestore via Cloud Function
  static Future<bool> saveNotificationSettings({
    required bool notificationsEnabled,
    required String userName,
    required Map<String, dynamic> services,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        return false;
      }

      final result = await _functions
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

  // Register FCM token with Cloud Function
  static Future<bool> registerFCMToken(String fcmToken) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        return false;
      }

      // Get device info
      String deviceType = 'unknown';
      String deviceName = 'unknown';

      if (await _isAndroid()) {
        deviceType = 'android';
        final androidInfo = await _deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (await _isiOS()) {
        deviceType = 'ios';
        final iosInfo = await _deviceInfo.iosInfo;
        deviceName = iosInfo.model;
      }

      final result = await _functions.httpsCallable('registerFCMToken').call({
        'userId': user.uid,
        'fcmToken': fcmToken,
        'deviceType': deviceType,
        'deviceName': deviceName,
      });

      print('✅ Token registered: ${result.data}');
      return true;
    } catch (e) {
      print('❌ Error registering token: $e');
      return false;
    }
  }

  // Remove FCM token (call on logout)
  static Future<bool> removeFCMToken(String fcmToken) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final result = await _functions.httpsCallable('removeFCMToken').call({
        'userId': user.uid,
        'fcmToken': fcmToken,
      });

      print('✅ Token removed: ${result.data}');
      return true;
    } catch (e) {
      print('❌ Error removing token: $e');
      return false;
    }
  }

  // Send test notification (for debugging)
  static Future<bool> sendTestNotification({String? serviceId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final result = await _functions
          .httpsCallable('sendTestNotification')
          .call({'userId': user.uid, 'serviceId': serviceId ?? 'affirmations'});

      print('✅ Test notification sent: ${result.data}');
      return true;
    } catch (e) {
      print('❌ Error sending test notification: $e');
      return false;
    }
  }

  static Future<bool> _isAndroid() async {
    final info = await _deviceInfo.androidInfo;
    return true; // Returns true for Android
  }

  static Future<bool> _isiOS() async {
    final info = await _deviceInfo.iosInfo;
    return true; // Returns true for iOS
  }
}
