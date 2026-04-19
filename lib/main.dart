import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:make_your_day/features/dashboard/view/screens/home_screen.dart';
import 'package:make_your_day/features/notifications/service/notification_service.dart';
import 'package:make_your_day/features/notifications/service/timezone_service.dart';
import 'package:make_your_day/features/onboarding/view/screens/onboarding_screen.dart';
import 'package:make_your_day/features/splash/view/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Timezone Service
  await TimezoneService.initialize();

  // Initialize Notification Service
  await NotificationService.initialize();

  // Sign in anonymously
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
    print('✅ Anonymous user created: ${FirebaseAuth.instance.currentUser?.uid}');
  }

  // Register FCM Token
  await _registerFCMToken();

  runApp(MyApp());
}

Future<void> _registerFCMToken() async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    print('📱 FCM Token: $token');

    final tokenObject = {
      'token': token,
      'deviceType': 'android',
      'registeredAt': DateTime.now().toIso8601String(),
    };

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    
    if (userDoc.exists) {
      final existingTokens = userDoc.data()?['fcm_tokens'] as List? ?? [];
      bool tokenExists = existingTokens.any((t) => t['token'] == token);
      
      if (!tokenExists) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'fcm_tokens': FieldValue.arrayUnion([tokenObject]),
          'lastActive': DateTime.now().toIso8601String(),
        });
        print('✅ Token added to Firestore');
      }
    } else {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'createdAt': DateTime.now().toIso8601String(),
        'fcm_tokens': [tokenObject],
        'lastActive': DateTime.now().toIso8601String(),
      });
      print('✅ New user created with token');
    }
  } catch (e) {
    print('❌ Error registering FCM token: $e');
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