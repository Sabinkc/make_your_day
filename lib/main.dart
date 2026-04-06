import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:make_your_day/features/dashboard/view/screens/home_screen.dart';
import 'package:make_your_day/features/onboarding/view/screens/onboarding_screen.dart';
import 'package:make_your_day/features/splash/view/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Get FCM Token
  await _getFCMToken();

  runApp(MyApp());
}

Future<void> _getFCMToken() async {
  try {
    // Request permissions (required for iOS, optional for Android 13+)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    print('Notification permission: ${settings.authorizationStatus}');

    // Get FCM Token
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      print('=' * 50);
      print('✅ FCM Token: $token');
      print('=' * 50);
    } else {
      print('❌ Failed to get FCM Token');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔄 Token refreshed: $newToken');
    });
  } catch (e) {
    print('❌ Error: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Make Your Day',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/onboarding': (context) => OnboardingScreen(),
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
