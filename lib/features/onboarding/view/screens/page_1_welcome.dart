import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/view/widgets/feature_card.dart';

class WelcomePage extends StatelessWidget {
  final List<String> selectedFeatures;
  final Function(String) onFeatureToggle;

  const WelcomePage({
    Key? key,
    required this.selectedFeatures,
    required this.onFeatureToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.wb_sunny, size: 40, color: Colors.blue),
          ),
          SizedBox(height: 20),
          Text(
            'Welcome to\nMake Your Day! ✨',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Your all-in-one companion for positivity, laughter, and motivation',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 40),
          Text(
            'Here\'s what you\'ll get:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 20),
          ...OnboardingOptions.appFeatures.map(
            (feature) =>
                FeatureCard(feature: feature, isSelected: false, onTap: () {}),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
