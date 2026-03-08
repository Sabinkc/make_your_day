import 'package:flutter/material.dart';
import 'package:make_your_day/features/onboarding/model/onboarding_options.dart';
import 'package:make_your_day/features/onboarding/model/user_data_model.dart';
import 'package:make_your_day/features/onboarding/view/widgets/feature_card.dart';
import 'package:make_your_day/features/onboarding/view/widgets/info_container.dart';

class FeatureSelectionPage extends StatelessWidget {
  final UserData userData;
  final Function(UserData) onUpdate;

  const FeatureSelectionPage({
    Key? key,
    required this.userData,
    required this.onUpdate,
  }) : super(key: key);

  void _toggleFeature(String featureName) {
    final updatedFeatures = List<String>.from(userData.selectedFeatures);
    if (updatedFeatures.contains(featureName)) {
      updatedFeatures.remove(featureName);
    } else {
      updatedFeatures.add(featureName);
    }
    onUpdate(userData..selectedFeatures = updatedFeatures);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            'What brings you here?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Select the features you\'re most interested in',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 30),

          ...OnboardingOptions.appFeatures.map(
            (feature) => FeatureCard(
              feature: feature,
              isSelected: userData.selectedFeatures.contains(feature['name']),
              onTap: () => _toggleFeature(feature['name']),
            ),
          ),

          SizedBox(height: 30),

          InfoContainer(
            title: 'How it works:',
            icon: Icons.info_outline,
            color: Colors.blue,
            points: [
              'Daily notifications based on your preferences',
              'Fresh content every day',
              'Customizable to your mood and needs',
              'Share positivity with friends',
            ],
          ),
        ],
      ),
    );
  }
}
