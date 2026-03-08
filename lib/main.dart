import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:make_your_day/features/dashboard/view/screens/home_screen.dart';
import 'package:make_your_day/features/onboarding/view/screens/onboarding_screen.dart';
import 'package:make_your_day/features/splash/view/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/onboarding': (context) => OnboardingScreen(),
      },
      // This applies the font to EVERY text widget in your app
      theme: ThemeData(
        fontFamily:
            GoogleFonts.poppins().fontFamily, // Change 'poppins' to any font
        textTheme: GoogleFonts.poppinsTextTheme(), // Apply to all text themes
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
}
