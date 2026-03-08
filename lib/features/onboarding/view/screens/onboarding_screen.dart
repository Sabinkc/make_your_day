import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_1_welcome.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_2_basic_info.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_3_feature_selection.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_4_affirmations.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_5_motivation.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_6_jokes.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_7_quotes.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_8_notifications.dart';
import 'package:make_your_day/features/onboarding/view/screens/page_9_final_preferences.dart';
import 'package:make_your_day/features/onboarding/view/widgets/navigation_buttons.dart';
import 'package:make_your_day/features/onboarding/view/widgets/progress_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final UserData _userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
      ),
      body: Column(
        children: [
          OnboardingProgress(currentPage: _currentPage, totalPages: 9),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                WelcomePage(
                  selectedFeatures: _userData.selectedFeatures,
                  onFeatureToggle: (feature) {
                    // Handle feature toggle if needed
                  },
                ),
                BasicInfoPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                FeatureSelectionPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                AffirmationsPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                MotivationPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                JokesPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                QuotesPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
                NotificationsPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                  onTimePicker: _showTimePicker,
                ),
                FinalPreferencesPage(
                  userData: _userData,
                  onUpdate: (updated) => setState(() => _userData),
                ),
              ],
            ),
          ),
          OnboardingNavigation(
            currentPage: _currentPage,
            totalPages: 9,
            onNext: _currentPage == 8 ? _submitOnboarding : _nextPage,
            onSkip: _skipToHome,
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 8) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToHome() {
    _saveUserData();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _submitOnboarding() {
    _saveUserData();
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _userData.notificationTime = picked;
      });
    }
  }

  void _saveUserData() {
    print('User Data: ${_userData.toJson()}');
    // TODO: Save to SharedPreferences or database
  }
}
