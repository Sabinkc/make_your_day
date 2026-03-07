import 'package:flutter/material.dart';
import 'package:make_your_day/features/home/view/screens/home_screen.dart';
import 'package:make_your_day/features/splash/view/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
