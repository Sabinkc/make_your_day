import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cloud_function_service.dart';

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Initialize notification system
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    // Request permission
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Get and register FCM Token
    await _getAndRegisterFCMToken();

    // Listen to token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      _registerTokenWithCloudFunction(newToken);
    });

    // Handle messages in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle when app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);

    _initialized = true;
    print('✅ Notification Service initialized');
  }

  static Future<void> _getAndRegisterFCMToken() async {
    String? token = await _fcm.getToken();
    if (token != null) {
      await _registerTokenWithCloudFunction(token);
      print('📱 FCM Token: $token');
    }
  }

  static Future<void> _registerTokenWithCloudFunction(String token) async {
    // Save locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);

    // Register with Cloud Function
    await CloudFunctionService.registerFCMToken(token);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📨 Received message in foreground');

    final title = message.notification?.title ?? 'Make Your Day';
    final body = message.notification?.body ?? '';

    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: message.data['service'] ?? '',
    );
  }

  static Future<void> _handleInitialMessage(RemoteMessage? message) async {
    if (message != null) {
      print('📨 App opened from terminated state');
      // TODO: Navigate to relevant screen based on payload
    }
  }

  static Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'make_your_day_channel',
          'Make Your Day Notifications',
          channelDescription: 'Daily positive content notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  // Remove token on logout
  static Future<void> unregisterToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('fcm_token');
    if (token != null) {
      await CloudFunctionService.removeFCMToken(token);
      await prefs.remove('fcm_token');
    }
  }
}
