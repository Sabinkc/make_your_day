import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFunctionService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  // Save notification settings with timezone and UTC times
  static Future<bool> saveNotificationSettings({
    required bool notificationsEnabled,
    required String userName,
    required String timezone,
    required Map<String, dynamic> services,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('❌ User not authenticated');
        return false;
      }
      
      print('📤 Saving settings for user: ${user.uid}');
      print('📍 Timezone: $timezone');
      print('📋 Services: $services');
      
      // Save to Firestore directly (more reliable)
      await FirebaseFirestore.instance
          .collection('user_notification_settings')
          .doc(user.uid)
          .set({
            'userId': user.uid,
            'userName': userName,
            'timezone': timezone,
            'notificationsEnabled': notificationsEnabled,
            'services': services,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      
      print('✅ Settings saved to Firestore');
      return true;
      
    } catch (e) {
      print('❌ Error saving settings: $e');
      return false;
    }
  }
  
  // Save user's timezone to user document
  static Future<void> saveUserTimezone(String timezone) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'timezone': timezone,
        'utcOffset': await _getTimezoneOffset(timezone),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      print('✅ Timezone saved: $timezone');
    } catch (e) {
      print('❌ Error saving timezone: $e');
    }
  }
  
  static Future<int> _getTimezoneOffset(String timezone) async {
    // You can implement this to store offset for quick reference
    return 0;
  }


static Future<bool> registerFCMToken(String fcmToken) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    final tokenObject = {
      'token': fcmToken,
      'deviceType': 'android',
      'registeredAt': DateTime.now().toIso8601String(),  // Use DateTime string
    };
    
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcm_tokens': FieldValue.arrayUnion([tokenObject]),
      'lastActive': DateTime.now().toIso8601String(),
    }, SetOptions(merge: true));
    
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
}